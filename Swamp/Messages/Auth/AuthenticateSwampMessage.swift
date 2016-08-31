//
//  AuthenticateSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 22/08/2016.
//
//

import Foundation
import SwiftyJSON

/// [AUTHENTICATE, signature|string, extra|dict]
class AuthenticateSwampMessage: SwampMessage {
    
    let signature: String
    let extra: [String: AnyObject]
    
    init(signature: String, extra: [String: AnyObject]) {
        self.signature = signature
        self.extra = extra
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [AnyObject]) {
        self.signature  = payload[0] as! String
        self.extra = payload[1] as! [String: AnyObject]
    }
    
    func marshal() -> [AnyObject] {
        return [SwampMessages.Authenticate.rawValue, self.signature, self.extra]
    }
}