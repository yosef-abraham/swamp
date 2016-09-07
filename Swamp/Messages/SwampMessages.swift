//
//  SwampMessages.swift
//  Defines all swamp messages, and provide basic factory function for each one
//
//  Created by Yossi Abraham on 18/08/2016.
//  Copyright © 2016 Yossi Abraham. All rights reserved.
//

enum SwampMessages: Int {
    
    // MARK: Basic profile messages
    
    case Hello = 1
    case Welcome = 2
    case Abort = 3
    case Goodbye = 6
    
    case Error = 8
    
    case Publish = 16
    case Published = 17
    case Subscribe = 32
    case Subscribed = 33
    case Unsubscribe = 34
    case Unsubscribed = 35
    case Event = 36
    
    case Call = 48
    case Result = 50
    case Register = 64
    case Registered = 65
    case Unregister = 66
    case Unregistered = 67
    case Invocation = 68
    case Yield = 70
    
    // MARK: Advance profile messages
    case Challenge = 4
    case Authenticate = 5
    
    /// payload consists of all data related to a message, WIHTHOUT the first one - the message identifier
    typealias WampMessageFactory = (payload: [AnyObject]) -> SwampMessage
    
    // Split into 2 dictionaries because Swift compiler thinks a single one is too complex
    // Perhaps find a better solution in the future
    
    private static let mapping1: [SwampMessages: WampMessageFactory] = [
        SwampMessages.Error: ErrorSwampMessage.init,
        
        // Session
        SwampMessages.Hello: HelloSwampMessage.init,
        SwampMessages.Welcome: WelcomeSwampMessage.init,
        SwampMessages.Abort: AbortSwampMessage.init,
        SwampMessages.Goodbye: GoodbyeSwampMessage.init,
        
        // Auth
        SwampMessages.Challenge: ChallengeSwampMessage.init,
        SwampMessages.Authenticate: AuthenticateSwampMessage.init
    ]
    
    private static let mapping2: [SwampMessages: WampMessageFactory] = [
        // RPC
        SwampMessages.Call: CallSwampMessage.init,
        SwampMessages.Result: ResultSwampMessage.init,
        SwampMessages.Register: RegisterSwampMessage.init,
        SwampMessages.Registered: RegisteredSwampMessage.init,
        SwampMessages.Invocation: InvocationSwampMessage.init,
        SwampMessages.Yield: YieldSwampMessage.init,
        SwampMessages.Unregister: UnregisterSwampMessage.init,
        SwampMessages.Unregistered: UnregisteredSwampMessage.init,
        
        // PubSub
        SwampMessages.Publish: PublishSwampMessage.init,
        SwampMessages.Published: PublishedSwampMessage.init,
        SwampMessages.Event: EventSwampMessage.init,
        SwampMessages.Subscribe: SubscribeSwampMessage.init,
        SwampMessages.Subscribed: SubscribedSwampMessage.init,
        SwampMessages.Unsubscribe: UnsubscribeSwampMessage.init,
        SwampMessages.Unsubscribed: UnsubscribedSwampMessage.init
    ]
    
    
    static func createMessage(payload: [AnyObject]) -> SwampMessage? {
        if let messageType = SwampMessages(rawValue: payload[0] as! Int) {
            if let messageFactory = mapping1[messageType] {
                return messageFactory(payload: Array(payload[1..<payload.count]))
            }
            if let messageFactory = mapping2[messageType] {
                return messageFactory(payload: Array(payload[1..<payload.count]))
            }
        }
        return nil
    }
}
