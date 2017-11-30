//
//  WelcomeMessage.swift
//  swamp
//
//  Created by Yossi Abraham on 18/08/2016.
//  Copyright © 2016 Yossi Abraham. All rights reserved.
//

import Foundation

/// [WELCOME, sessionId|number, details|Dict]
class WelcomeSwampMessage: SwampMessage {
    
    let sessionId: Int
    let details: [String: AnyObject]
    
    init(sessionId: Int, details: [String: AnyObject]) {
        self.sessionId = sessionId
        self.details = details
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [Any]) {
        self.sessionId = payload[0] as! Int
        self.details = payload[1] as! [String: AnyObject]
    }
    
    func marshal() -> [Any] {
        return [SwampMessages.welcome.rawValue, self.sessionId, self.details]
    }
}
