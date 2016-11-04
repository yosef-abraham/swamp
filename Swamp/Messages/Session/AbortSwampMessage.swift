//
//  AbortSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 22/08/2016.
//
//

import Foundation
import SwiftyJSON

/// [ABORT, details|dict, reason|uri]
class AbortSwampMessage: SwampMessage {

    let details: [String: Any]
    let reason: String

    init(details: [String: Any], reason: String) {
        self.details = details
        self.reason = reason
    }

    // MARK: SwampMessage protocol

    required init(payload: [Any]) {
        self.details = payload[0] as! [String: Any]
        self.reason = payload[1] as! String
    }

    func marshal() -> [Any] {
        return [SwampMessages.abort.rawValue, self.details, self.reason]
    }
}
