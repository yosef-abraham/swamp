//
//  WelcomeMessage.swift
//  swamp
//
//  Created by Yossi Abraham on 18/08/2016.
//  Copyright © 2016 Yossi Abraham. All rights reserved.
//

import Foundation
import SwiftyJSON

/// [WELCOME, sessionId|number, details|Dict]
class WelcomeSwampMessage: SwampMessage {
    
    let sessionId: Int
    let details: [String: AnyObject]
    
    init(sessionId: Int, details: [String: AnyObject]) {
        self.sessionId = sessionId
        self.details = details
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [AnyObject]) {
        self.sessionId = payload[0] as! Int
        self.details = payload[1] as! [String: AnyObject]
    }
    
    func marshal() -> [AnyObject] {
        return [SwampMessages.Welcome.rawValue, self.sessionId, self.details]
    }
}