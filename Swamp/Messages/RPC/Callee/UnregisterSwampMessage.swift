//
//  UnregisterSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 01/09/2016.
//
//

import Foundation

/// [UNREGISTER, requestId|number, registration|number]
class UnregisterSwampMessage: SwampMessage {
    
    let requestId: Int
    let registration: Int
    
    init(requestId: Int, registration: Int) {
        self.requestId = requestId
        self.registration = registration
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [Any]) {
        self.requestId = payload[0] as! Int
        self.registration = payload[1] as! Int
    }
    
    func marshal() -> [Any] {
        return [SwampMessages.unregister.rawValue, self.requestId, self.registration]
    }
}
