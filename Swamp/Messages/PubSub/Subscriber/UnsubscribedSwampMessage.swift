//
//  UnsubscribedSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 24/08/2016.
//
//

import Foundation

/// [UNSUBSCRIBED, requestId|number]
class UnsubscribedSwampMessage: SwampMessage {

    let requestId: Int

    init(requestId: Int) {
        self.requestId = requestId
    }

    // MARK: SwampMessage protocol

    required init(payload: [AnyObject]) {
        self.requestId = payload[0] as! Int
    }



    func marshal() -> [AnyObject] {
        return [SwampMessages.unsubscribed.rawValue as AnyObject, self.requestId as AnyObject]


    }
}
