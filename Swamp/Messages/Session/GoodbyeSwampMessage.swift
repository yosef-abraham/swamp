//
//  GoodbyeSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 22/08/2016.
//
//

import Foundation

/// [GOODBYE, details|dict, reason|uri]
class GoodbyeSwampMessage: SwampMessage {
    
    let details: [String: AnyObject]
    let reason: String
    
    init(details: [String: AnyObject], reason: String) {
        self.details = details
        self.reason = reason
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [Any]) {
        self.details = payload[0] as! [String: AnyObject]
        self.reason = payload[1] as! String
    }
    
    func marshal() -> [Any] {
        return [SwampMessages.goodbye.rawValue, self.details, self.reason]
    }
}
