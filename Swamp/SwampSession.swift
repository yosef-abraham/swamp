//
//  SwampSession.swift
//

import Foundation
import SwiftyJSON

public protocol SwampSessionDelegate {
    func swampSessionHandleChallenge(challenge: String) -> String
    func swampSessionConnected(session: SwampSession, sessionId: Int)
    func swampSessionEnded(reason: String)
}

public class SwampSession: SwampTransportDelegate {
    public var delegate: SwampSessionDelegate?
    
    // MARK: Constants
    private let supportedRoles: [SwampRole] = [SwampRole.Caller, SwampRole.Callee, SwampRole.Subscriber, SwampRole.Publisher]
    
    // MARK: Members
    private var realm: String
    private var transport: SwampTransport
    
    private var serializer: SwampSerializer?
    private var sessionId: Int?
    private var routerSupportedRoles: [SwampRole]?
    
    public init(realm: String, transport: SwampTransport){
        self.realm = realm
        self.transport = transport
        self.transport.delegate = self
    }
    
    // MARK: Public API
    
    public func connect(){
        self.transport.connect()
    }
    
    public func disconnect() {
        self.sendMessage(GoodbyeSwampMessage(details: [:], reason: "wamp.error.close_realm"))
    }
    
    public func abort() throws {
        if self.sessionId != nil {
            throw SwampError.AbortCanOnlyHappenBeforeSessionInitiated
        }
        self.sendMessage(AbortSwampMessage(details: [:], reason: "wamp.error.system_shutdown"))
        self.transport.disconnect("Aborted upon user request.")
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
        self.sendMessage(HelloSwampMessage(realm: self.realm, details: ["agent": "Swamp-dev-0.1.0", "roles": roles]))
    }
    
    public func swampTransportReceivedData(data: NSData) {
        if let payload = self.serializer?.unpack(data), let message = SwampMessages.createMessage(payload) {
            self.handleMessage(message)
        }
    }
    
    // MARK: Private methods
    private func handleMessage(message: SwampMessage) {
        switch message {
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
        default:
            return
        }
    }
    
    private func sendMessage(message: SwampMessage){
        if let data = self.serializer?.pack(message.marshall()) {
            self.transport.sendData(data)
        }
    }
}