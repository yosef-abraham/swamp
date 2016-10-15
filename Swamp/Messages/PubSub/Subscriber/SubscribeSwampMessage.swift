//
//  SubscribeSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 24/08/2016.
//
//

import Foundation

/// [SUBSCRIBE, requestId|number, options|dict, topic|string] 
class SubscribeSwampMessage: SwampMessage {
    
    let requestId: Int
    let options: [String: Any]
    let topic: String
    
    init(requestId: Int, options: [String: Any], topic: String) {
        self.requestId = requestId
        self.options = options
        self.topic = topic
    }
    
    // MARK: SwampMessage protocol
    required init(payload: [Any]) {
        self.requestId = payload[0] as! Int
        self.options = payload[1] as! [String: Any]
        self.topic = payload[2] as! String
    }
    
    func marshal() -> [Any] {
        return [SwampMessages.subscribe.rawValue, self.requestId, self.options, self.topic]
    }
}
