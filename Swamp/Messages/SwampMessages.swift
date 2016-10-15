//
//  SwampMessages.swift
//  Defines all swamp messages, and provide basic factory function for each one
//
//  Created by Yossi Abraham on 18/08/2016.
//  Copyright © 2016 Yossi Abraham. All rights reserved.
//

enum SwampMessages: Int {

    // MARK: Basic profile messages

    case hello = 1
    case welcome = 2
    case abort = 3
    case goodbye = 6

    case error = 8

    case publish = 16
    case published = 17
    case subscribe = 32
    case subscribed = 33
    case unsubscribe = 34
    case unsubscribed = 35
    case event = 36

    case call = 48
    case result = 50
    case register = 64
    case registered = 65
    case unregister = 66
    case unregistered = 67
    case invocation = 68
    case yield = 70

    // MARK: Advance profile messages
    case challenge = 4
    case authenticate = 5

    /// payload consists of all data related to a message, WIHTHOUT the first one - the message identifier
    typealias WampMessageFactory = (_ payload: [Any]) -> SwampMessage

    // Split into 2 dictionaries because Swift compiler thinks a single one is too complex
    // Perhaps find a better solution in the future

    fileprivate static let mapping1: [SwampMessages: WampMessageFactory] = [
        SwampMessages.error: ErrorSwampMessage.init,

        // Session
        SwampMessages.hello: HelloSwampMessage.init,
        SwampMessages.welcome: WelcomeSwampMessage.init,
        SwampMessages.abort: AbortSwampMessage.init,
        SwampMessages.goodbye: GoodbyeSwampMessage.init,

        // Auth
        SwampMessages.challenge: ChallengeSwampMessage.init,
        SwampMessages.authenticate: AuthenticateSwampMessage.init
    ]

    fileprivate static let mapping2: [SwampMessages: WampMessageFactory] = [
        // RPC
        SwampMessages.call: CallSwampMessage.init,
        SwampMessages.result: ResultSwampMessage.init,
        SwampMessages.register: RegisterSwampMessage.init,
        SwampMessages.registered: RegisteredSwampMessage.init,
        SwampMessages.invocation: InvocationSwampMessage.init,
        SwampMessages.yield: YieldSwampMessage.init,
        SwampMessages.unregister: UnregisterSwampMessage.init,
        SwampMessages.unregistered: UnregisteredSwampMessage.init,

        // PubSub
        SwampMessages.publish: PublishSwampMessage.init,
        SwampMessages.published: PublishedSwampMessage.init,
        SwampMessages.event: EventSwampMessage.init,
        SwampMessages.subscribe: SubscribeSwampMessage.init,
        SwampMessages.subscribed: SubscribedSwampMessage.init,
        SwampMessages.unsubscribe: UnsubscribeSwampMessage.init,
        SwampMessages.unsubscribed: UnsubscribedSwampMessage.init
    ]


    static func createMessage(_ payload: [Any]) -> SwampMessage? {
        if let messageType = SwampMessages(rawValue: payload[0] as! Int) {
            if let messageFactory = mapping1[messageType] {
                return messageFactory(Array(payload[1..<payload.count]))
            }
            if let messageFactory = mapping2[messageType] {
                return messageFactory(Array(payload[1..<payload.count]))
            }
        }
        return nil
    }
}
