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
    case Goodbye = 4
    
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
    // TODO
    
    /// payload consists of all data related to a message, WIHTHOUT the first one - the message identifier
    typealias WampMessageFactory = (payload: [AnyObject]) -> SwampMessage
    
    private static let mapping: [SwampMessages: WampMessageFactory] = [
        SwampMessages.Hello: { return HelloSwampMessage(payload: $0) },
        SwampMessages.Welcome: { return WelcomeSwampMessage(payload: $0) },
    ]
    
    
    static func createMessage(payload: [AnyObject]) -> SwampMessage? {
        if let messageType = SwampMessages(rawValue: payload[0] as! Int) {
            if let messageFactory = mapping[messageType] {
                return messageFactory(payload: Array(payload[1..<payload.count]))
            }
        }
        return nil
    }
}
