//
//  UnregisteredSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 01/09/2016.
//
//

import Foundation

/// [UNREGISTERED, requestId|number]
class UnregisteredSwampMessage: SwampMessage {

    let requestId: Int

    init(requestId: Int) {
        self.requestId = requestId
    }

    // MARK: SwampMessage protocol

    required init(payload: [AnyObject]) {
        self.requestId = payload[0] as! Int
    }



    func marshal() -> [AnyObject] {
        return [SwampMessages.unregistered.rawValue as AnyObject, self.requestId as AnyObject]


    }
}
