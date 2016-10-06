//
//  UnsubscribeSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 24/08/2016.
//
//

import Foundation

/// [UNSUBSCRIBE, requestId|number, subscription|number]
class UnsubscribeSwampMessage: SwampMessage {
    
    let requestId: Int
    let subscription: Int
    
    init(requestId: Int, subscription: Int) {
        self.requestId = requestId
        self.subscription = subscription
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [Any]) {
        self.requestId = payload[0] as! Int
        self.subscription = payload[1] as! Int
    }
    
    func marshal() -> [Any] {
        return [SwampMessages.unsubscribe.rawValue, self.requestId, self.subscription]
    }
}
