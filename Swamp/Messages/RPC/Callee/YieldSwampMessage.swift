//
//  YieldSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 01/09/2016.
//
//

import Foundation

// [YIELD, requestId|number, options|dict, args|array?, kwargs|dict?]
class YieldSwampMessage: SwampMessage {

    let requestId: Int
    let options: [String: Any]

    let args: [Any]?
    let kwargs: [String: Any]?

    init(requestId: Int, options: [String: Any], args: [Any]?=nil, kwargs: [String: Any]?=nil) {
        self.requestId = requestId
        self.options = options

        self.args = args
        self.kwargs = kwargs
    }

    // MARK: SwampMessage protocol

    required init(payload: [Any]) {
        self.requestId = payload[0] as! Int
        self.options = payload[1] as! [String: Any]
        self.args = payload[safe: 2] as? [Any]
        self.kwargs = payload[safe: 3] as? [String: Any]
    }

    func marshal() -> [Any] {
        var marshalled: [Any] = [SwampMessages.yield.rawValue, self.requestId, self.options]

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
