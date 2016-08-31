//
//  ChallengeSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 22/08/2016.
//
//

import Foundation
import SwiftyJSON

/// [CHALLENGE, authMethod|string, extra|dict]
class ChallengeSwampMessage: SwampMessage {
    
    let authMethod: String
    let extra: [String: AnyObject]
    
    init(authMethod: String, extra: [String: AnyObject]) {
        self.authMethod = authMethod
        self.extra = extra
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [AnyObject]) {
        self.authMethod = payload[0] as! String
        self.extra = payload[1] as! [String: AnyObject]
    }
    
    func marshal() -> [AnyObject] {
        return [SwampMessages.Challenge.rawValue, self.authMethod, self.extra]
    }
}