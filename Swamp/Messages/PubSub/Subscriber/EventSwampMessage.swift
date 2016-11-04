//
//  EventSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 24/08/2016.
//
//

import Foundation

/// [EVENT, subscription|number, publication|number, details|dict, args|list?, kwargs|dict?]
class EventSwampMessage: SwampMessage {

    let subscription: NSNumber
    let publication: NSNumber
    let details: [String: Any]

    let args: [Any]?
    let kwargs: [String: Any]?

    init(subscription: NSNumber, publication: NSNumber, details: [String: Any], args: [Any]?=nil, kwargs: [String: Any]?=nil) {
        self.subscription = subscription
        self.publication = publication
        self.details = details

        self.args = args
        self.kwargs = kwargs
    }

    // MARK: SwampMessage protocol

    required init(payload: [Any]) {
        self.subscription = (payload[0] as! NSNumber)
        self.publication = (payload[1] as! NSNumber)
        self.details = payload[2] as! [String: Any]
        self.args = payload[safe: 3] as? [Any]
        self.kwargs = payload[safe: 4] as? [String: Any]
    }

    func marshal() -> [Any] {
        var marshalled: [Any] = [SwampMessages.event.rawValue, self.subscription, self.publication, self.details]

        if let args = self.args {
            marshalled.append(args)
            if let kwargs = self.kwargs {
                marshalled.append(kwargs)
            }
        } else {
            if let kwargs = self.kwargs {
                marshalled.append([])
                marshalled.append(kwargs)
            }
        }

        return marshalled
    }
}
