//
//  HelloMessage.swift
//  swamp
//
//  Created by Yossi Abraham on 18/08/2016.
//  Copyright © 2016 Yossi Abraham. All rights reserved.
//

import Foundation
import SwiftyJSON

/// [HELLO, realm|string, details|dict]
class HelloSwampMessage: SwampMessage {
    
    let realm: String
    let details: [String: AnyObject]
    
    init(realm: String, details: [String: AnyObject]) {
        self.realm = realm
        self.details = details
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [AnyObject]) {
        self.realm = payload[0] as! String
        self.details = payload[1] as! [String: AnyObject]
    }
    
    func marshall() -> [AnyObject] {
        return [SwampMessages.Hello.rawValue, self.realm, self.details]
    }
}