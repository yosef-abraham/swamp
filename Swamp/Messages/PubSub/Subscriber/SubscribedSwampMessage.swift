//
//  SubscribedSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 24/08/2016.
//
//

import Foundation

/// [SUBSCRIBED, requestId|number, subscription|number]
class SubscribedSwampMessage: SwampMessage {
    
    let requestId: Int
    let subscription: Int
    
    init(requestId: Int, subscription: Int) {
        self.requestId = requestId
        self.subscription = subscription
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [AnyObject]) {
        self.requestId = payload[0] as! Int
        self.subscription = payload[1] as! Int
    }
    
    func marshall() -> [AnyObject] {
        return [SwampMessages.Subscribed.rawValue, self.requestId, self.subscription]
    }
}