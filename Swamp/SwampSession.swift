//
//  SwampSession.swift
//

import Foundation
import SwiftyJSON

// MARK: Call callbacks
public typealias CallCallback = (details: [String: AnyObject], results: [AnyObject]?, kwResults: [String: AnyObject]?) -> Void
public typealias ErrorCallCallback = (details: [String: AnyObject], error: String, args: [AnyObject]?, kwargs: [String: AnyObject]?) -> Void
// MARK: Subscribe callbacks
public typealias SubscribeCallback = (subscription: Subscription) -> Void
public typealias ErrorSubscribeCallback = (details: [String: AnyObject], error: String) -> Void
public typealias EventCallback = (details: [String: AnyObject], results: [AnyObject]?, kwResults: [String: AnyObject]?) -> Void
public typealias UnsubscribeCallback = () -> Void
public typealias ErrorUnsubscribeCallback = (details: [String: AnyObject], error: String) -> Void

// TODO: Expose only an interface (like Cancellable) to user
public class Subscription {
    private let session: SwampSession
    internal let subscription: Int
    internal let eventCallback: EventCallback
    private var isActive: Bool = true
    
    internal init(session: SwampSession, subscription: Int, onEvent: EventCallback) {
        self.session = session
        self.subscription = subscription
        self.eventCallback = onEvent
    }
    
    internal func invalidate() {
        self.isActive = false
    }
    
    public func cancel(onSuccess: UnsubscribeCallback, onError: ErrorUnsubscribeCallback) {
        if !self.isActive {
            onError(details: [:], error: "Subscription already inactive.")
        }
        self.session.unsubscribe(self.subscription, onSuccess: onSuccess, onError: onError)
    }
}

public protocol SwampSessionDelegate {
    func swampSessionHandleChallenge(authMethod: String, extra: [String: AnyObject]) -> String
    func swampSessionConnected(session: SwampSession, sessionId: Int)
    func swampSessionEnded(reason: String)
}

public class SwampSession: SwampTransportDelegate {
    // MARK: Public typealiases
    
    // MARK: delegate
    public var delegate: SwampSessionDelegate?
    
    // MARK: Constants
    private let supportedRoles: [SwampRole] = [SwampRole.Caller, SwampRole.Callee, SwampRole.Subscriber, SwampRole.Publisher]
    private let clientName = "Swamp-dev-0.1.0"
    
    // MARK: Members
    private let realm: String
    private let transport: SwampTransport
    private let authmethods: [String]?
    private let authid: String?
    private let authrole: String?
    private let authextra: [String: AnyObject]?
    
    // MARK: State members
    private var currRequestId: Int = 1
    
    // MARK: Session state
    private var serializer: SwampSerializer?
    private var sessionId: Int?
    private var routerSupportedRoles: [SwampRole]?
    
    // MARK: Call role
    //                         requestId
    private var callRequests: [Int: (callback: CallCallback, errorCallback: ErrorCallCallback)] = [:]
    // MARK: Subscribe role
    //                              requestId
    private var subscribeRequests: [Int: (callback: SubscribeCallback, errorCallback: ErrorSubscribeCallback, eventCallback: EventCallback)] = [:]
    //                          subscription
    private var subscriptions: [Int: Subscription] = [:]
    //                                requestId
    private var unsubscribeRequests: [Int: (subscription: Int, callback: UnsubscribeCallback, errorCallback: ErrorUnsubscribeCallback)] = [:]
    
    // MARK: C'tor
    required public init(realm: String, transport: SwampTransport, authmethods: [String]?=nil, authid: String?=nil, authrole: String?=nil, authextra: [String: AnyObject]?=nil){
        self.realm = realm
        self.transport = transport
        self.authmethods = authmethods
        self.authid = authid
        self.authrole = authrole
        self.authextra = authextra
        self.transport.delegate = self
    }
    
    // MARK: Public API
    
    final public func isConnected() -> Bool {
        return self.sessionId != nil
    }
    
    final public func connect() {
        self.transport.connect()
    }
    
    final public func disconnect(reason: String="wamp.error.close_realm") {
        self.sendMessage(GoodbyeSwampMessage(details: [:], reason: reason))
    }
    
    // MARK: Caller role
    
    public func call(proc: String, options: [String: AnyObject]=[:], args: [AnyObject]?=nil, kwargs: [String: AnyObject]?=nil, onSuccess: CallCallback, onError: ErrorCallCallback) {
        let callRequestId = self.generateRequestId()
        // Tell router to dispatch call
        self.sendMessage(CallSwampMessage(requestId: callRequestId, options: options, proc: proc, args: args, kwargs: kwargs))
        // Store request ID to handle result
        self.callRequests[callRequestId] = (callback: onSuccess, errorCallback: onError)
    }
    
    // MARK: Subscriber role
    
    public func subscribe(topic: String, options: [String: AnyObject]=[:], onSuccess: SubscribeCallback, onError: ErrorSubscribeCallback, onEvent: EventCallback) {
        // TODO: assert topic is a valid WAMP uri
        let subscribeRequestId = self.generateRequestId()
        // Tell router to subscribe client on a topic
        self.sendMessage(SubscribeSwampMessage(requestId: subscribeRequestId, options: options, topic: topic))
        // Store request ID to handle result
        self.subscribeRequests[subscribeRequestId] = (callback: onSuccess, errorCallback: onError, eventCallback: onEvent)
    }
    
    // Internal because only a Subscription object can call this
    internal func unsubscribe(subscription: Int, onSuccess: UnsubscribeCallback, onError: ErrorUnsubscribeCallback) {
        let unsubscribeRequestId = self.generateRequestId()
        // Tell router to unsubscribe me from some subscription
        self.sendMessage(UnsubscribeSwampMessage(requestId: unsubscribeRequestId, subscription: subscription))
        // Store request ID to handle result
        self.unsubscribeRequests[unsubscribeRequestId] = (subscription, onSuccess, onError)
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
        
        var details: [String: AnyObject] = [:]
        
        if let authmethods = self.authmethods {
            details["authmethods"] = authmethods
        }
        if let authid = self.authid {
            details["authid"] = authid
        }
        if let authrole = self.authrole {
            details["authrole"] = authrole
        }
        if let authextra = self.authextra {
            details["authextra"] = authextra
        }
        
        details["agent"] = self.clientName
        details["roles"] = roles
        self.sendMessage(HelloSwampMessage(realm: self.realm, details: details))
    }
    
    public func swampTransportReceivedData(data: NSData) {
        if let payload = self.serializer?.unpack(data), let message = SwampMessages.createMessage(payload) {
            self.handleMessage(message)
        }
    }
    
    private func handleMessage(message: SwampMessage) {
        switch message {
        // MARK: Auth responses
        case let message as ChallengeSwampMessage:
            if let authResponse = self.delegate?.swampSessionHandleChallenge(message.authMethod, extra: message.extra) {
                self.sendMessage(AuthenticateSwampMessage(signature: authResponse, extra: [:]))
            } else {
                print("There was no delegate, aborting.")
                try! self.abort()
            }
        // MARK: Session responses
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
        // MARK: Call role
        case let message as ResultSwampMessage:
            let requestId = message.requestId
            if let (callback, errorCallback) = self.callRequests.removeValueForKey(requestId) {
                callback(details: message.details, results: message.results, kwResults: message.kwResults)
            } else {
                // TODO: log this erroneous situation
            }
        // MARK: Subscribe role
        case let message as SubscribedSwampMessage:
            let requestId = message.requestId
            if let (callback, _, eventCallback) = self.subscribeRequests.removeValueForKey(requestId) {
                // Notify user and delegate him to unsubscribe this subscription
                let subscription = Subscription(session: self, subscription: message.subscription, onEvent: eventCallback)
                callback(subscription: subscription)
                // Subscription succeeded, we should store event callback for when it's fired
                self.subscriptions[message.subscription] = subscription
            } else {
                // TODO: log this erroneous situation
            }
        case let message as EventSwampMessage:
            if let subscription = self.subscriptions[message.subscription] {
                subscription.eventCallback(details: message.details, results: message.args, kwResults: message.kwargs)
            } else {
                // TODO: log this erroneous situation
            }
        case let message as UnsubscribedSwampMessage:
            let requestId = message.requestId
            if let (subscription, callback, _) = self.unsubscribeRequests.removeValueForKey(requestId) {
                if let subscription = self.subscriptions.removeValueForKey(subscription) {
                    subscription.invalidate()
                    callback()
                } else {
                    // TODO: log this erroneous situation
                }
            } else {
                // TODO: log this erroneous situation
            }
            
        ////////////////////////////////////////////
        // MARK: Handle error responses
        ////////////////////////////////////////////
        case let message as ErrorSwampMessage:
            switch message.requestType {
            case SwampMessages.Call:
                if let (callback, errorCallback) = self.callRequests.removeValueForKey(message.requestId) {
                    errorCallback(details: message.details, error: message.error, args: message.args, kwargs: message.kwargs)
                } else {
                    // TODO: log this erroneous situation
                }
            case SwampMessages.Subscribe:
                if let (_, errorCallback, _) = self.subscribeRequests.removeValueForKey(message.requestId) {
                    errorCallback(details: message.details, error: message.error)
                } else {
                    // TODO: log this erroneous situation
                }
            case SwampMessages.Unsubscribe:
                if let (_, _, errorCallback) = self.unsubscribeRequests.removeValueForKey(message.requestId) {
                    errorCallback(details: message.details, error: message.error)
                } else {
                    // TODO: log this erroneous situation
                }
            default:
                return
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
        self.transport.disconnect("No challenge delegate found.")
    }
    
    private func sendMessage(message: SwampMessage){
        let marshalledMessage = message.marshal()
        let data = self.serializer!.pack(marshalledMessage)!
        self.transport.sendData(data)
    }
    
    private func generateRequestId() -> Int {
        return self.currRequestId++
    }
}