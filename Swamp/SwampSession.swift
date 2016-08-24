//
//  SwampSession.swift
//

import Foundation
import SwiftyJSON

public protocol SwampSessionDelegate {
    func swampSessionHandleChallenge(authMethod: String, extra: [String: AnyObject]) -> String
    func swampSessionConnected(session: SwampSession, sessionId: Int)
    func swampSessionEnded(reason: String)
}

public class SwampSession: SwampTransportDelegate {
    // MARK: Public typealiases
    //                               details              results      kwResults
    public typealias CallCallback = ([String: AnyObject], [AnyObject]?, [String: AnyObject]?) -> Void
    //                                    details              uri     args          kwargs
    public typealias ErrorCallCallback = ([String: AnyObject], String, [AnyObject]?, [String: AnyObject]?) -> Void
    
    // MARK: delegate
    public var delegate: SwampSessionDelegate?
    
    // MARK: Constants
    private let supportedRoles: [SwampRole] = [SwampRole.Caller, SwampRole.Callee, SwampRole.Subscriber, SwampRole.Publisher]
    
    // MARK: Members
    private var realm: String
    private var transport: SwampTransport
    private var details: [String: AnyObject]
    
    private var serializer: SwampSerializer?
    private var sessionId: Int?
    private var routerSupportedRoles: [SwampRole]?
    
    // MARK: State members
    private var currRequestId: Int = 1
    private var callRequests: [Int: (callback: CallCallback?, errorCallback: ErrorCallCallback?)] = [:]
    
    public init(realm: String, transport: SwampTransport, details: [String: AnyObject]=[:]){
        self.realm = realm
        self.transport = transport
        self.details = details
        self.transport.delegate = self
    }
    
    // MARK: Public API
    
    public func connect(){
        self.transport.connect()
    }
    
    public func disconnect() {
        self.sendMessage(GoodbyeSwampMessage(details: [:], reason: "wamp.error.close_realm"))
    }
    
    // MARK: Caller role
    
    public func call(uri: String, options: [String: AnyObject], args: [AnyObject]?=nil, kwargs: [String: AnyObject]?=nil, callback: CallCallback?, errorCallback: ErrorCallCallback?) {
        let callRequestId = self.generateRequestId()
        // Tell router to dispatch call
        self.sendMessage(CallSwampMessage(requestId: callRequestId, options: options, proc: uri, args: args, kwargs: kwargs))
        // Store request ID to handle result
        self.callRequests[callRequestId] = (callback: callback, errorCallback: errorCallback)
    }
    
    // MARK: SwampTransportDelegate
    
    public func swampTransportDidDisconnect(error: NSError?, reason: String?) {
        if reason != nil {
            self.delegate?.swampSessionEnded(reason!)
        }
        else if error != nil {
            self.delegate?.swampSessionEnded("Unexpected error: \(error!.description)")
        } else {
            self.delegate?.swampSessionEnded("Unknown error.")
        }
    }
    
    public func swampTransportDidConnectWithSerializer(serializer: SwampSerializer) {
        self.serializer = serializer
        // Start session by sending a Hello message!
        
        var roles = [String: AnyObject]()
        for role in self.supportedRoles {
            // For now basic profile, (demands empty dicts)
            roles[role.rawValue] = [:]
        }
        self.details["agent"] = "Swamp-dev-0.1.0"
        self.details["roles"] = roles
        self.sendMessage(HelloSwampMessage(realm: self.realm, details: self.details))
    }
    
    public func swampTransportReceivedData(data: NSData) {
        if let payload = self.serializer?.unpack(data), let message = SwampMessages.createMessage(payload) {
            self.handleMessage(message)
        }
    }
    
    private func handleMessage(message: SwampMessage) {
        switch message {
        case let message as ChallengeSwampMessage:
            if let authResponse = self.delegate?.swampSessionHandleChallenge(message.authMethod, extra: message.extra) {
                self.sendMessage(AuthenticateSwampMessage(signature: authResponse, extra: [:]))
            } else {
                print("There was no delegate, aborting.")
                try! self.abort()
            }
        case let message as WelcomeSwampMessage:
            self.sessionId = message.sessionId
            let routerRoles = message.details["roles"]! as! [String : [String : AnyObject]]
            self.routerSupportedRoles = routerRoles.keys.map { SwampRole(rawValue: $0)! }
            self.delegate?.swampSessionConnected(self, sessionId: message.sessionId)
        case let message as GoodbyeSwampMessage:
            if message.reason != "wamp.error.goodbye_and_out" {
                // Means it's not our initiated goodbye, and we should reply with goodbye
                self.sendMessage(GoodbyeSwampMessage(details: [:], reason: "wamp.error.goodbye_and_out"))
            }
            self.transport.disconnect(message.reason)
        case let message as AbortSwampMessage:
            self.transport.disconnect(message.reason)
        case let message as ErrorSwampMessage:
            switch message.requestType {
            case SwampMessages.Call:
                let requestId = message.requestId
                if let (callback, errorCallback) = self.callRequests[requestId] {
                    if errorCallback != nil {
                        errorCallback!(message.details, message.error, message.args, message.kwargs)
                    }
                }
            default:
                return
            }
        case let message as ResultSwampMessage:
            let requestId = message.requestId
            if let (callback, errorCallback) = self.callRequests[requestId] {
                if callback != nil {
                    callback!(message.details, message.results, message.kwResults)
                }
            }
            
        default:
            return
        }
    }
    
    // MARK: Private methods
    
    private func abort() {
        if self.sessionId != nil {
            return
        }
        self.sendMessage(AbortSwampMessage(details: [:], reason: "wamp.error.system_shutdown"))
    }
    
    private func sendMessage(message: SwampMessage){
        if let data = self.serializer?.pack(message.marshall()) {
            self.transport.sendData(data)
        }
    }
    
    private func generateRequestId() -> Int {
        return self.currRequestId++
    }
}