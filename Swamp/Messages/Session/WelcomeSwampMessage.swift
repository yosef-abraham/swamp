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

    let sessionId: NSNumber
    let details: [String: Any]

    init(sessionId: NSNumber, details: [String: Any]) {
        self.sessionId = sessionId
        self.details = details
    }

    // MARK: SwampMessage protocol

    required init(payload: [Any]) {
        self.sessionId = payload[0] as! NSNumber

        self.details = payload[1] as! [String: Any]
    }

    func marshal() -> [Any] {
        return [SwampMessages.welcome.rawValue, self.sessionId, self.details]
    }
}
