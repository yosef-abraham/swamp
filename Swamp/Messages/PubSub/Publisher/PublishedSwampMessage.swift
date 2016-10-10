//
//  PublishedSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 01/09/2016.
//
//

import Foundation

/// [PUBLISHED, requestId|number, options|dict, topic|String, args|list?, kwargs|dict?]
class PublishedSwampMessage: SwampMessage {

    let requestId: Int
    let publication: Int

    init(requestId: Int, publication: Int) {
        self.requestId = requestId
        self.publication = publication
    }

    // MARK: SwampMessage protocol
    required init(payload: [AnyObject]) {
        self.requestId = payload[0] as! Int
        self.publication = payload[1] as! Int
    }



    func marshal() -> [AnyObject] {
        let marshalled: [AnyObject] = [SwampMessages.published.rawValue as AnyObject, self.requestId as AnyObject, self.publication as AnyObject]


        return marshalled
    }
}
