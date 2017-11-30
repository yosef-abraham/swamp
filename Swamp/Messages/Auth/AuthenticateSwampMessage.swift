//
//  AuthenticateSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 22/08/2016.
//
//

import Foundation

/// [AUTHENTICATE, signature|string, extra|dict]
class AuthenticateSwampMessage: SwampMessage {
    
    let signature: String
    let extra: [String: Any]
    
    init(signature: String, extra: [String: AnyObject]) {
        self.signature = signature
        self.extra = extra
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [Any]) {
        self.signature  = payload[0] as! String
        self.extra = payload[1] as! [String: Any]
    }
    
    func marshal() -> [Any] {
        return [SwampMessages.authenticate.rawValue, self.signature, self.extra]
    }
}
