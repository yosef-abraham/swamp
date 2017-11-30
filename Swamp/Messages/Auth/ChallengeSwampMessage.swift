//
//  ChallengeSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 22/08/2016.
//
//

import Foundation

/// [CHALLENGE, authMethod|string, extra|dict]
class ChallengeSwampMessage: SwampMessage {
    
    let authMethod: String
    let extra: [String: Any]
    
    init(authMethod: String, extra: [String: Any]) {
        self.authMethod = authMethod
        self.extra = extra
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [Any]) {
        self.authMethod = payload[0] as! String
        self.extra = payload[1] as! [String: Any]
    }
    
    func marshal() -> [Any] {
        return [SwampMessages.challenge.rawValue, self.authMethod, self.extra]
    }
}
