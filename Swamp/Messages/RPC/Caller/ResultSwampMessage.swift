//
//  ResultSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 23/08/2016.
//
//

import Foundation

/// [RESULT, requestId|number, details|dict, args|array?, kwargs|dict?]
class ResultSwampMessage: SwampMessage {

    let requestId: Int
    let details: [String: Any]
    let results: [Any]?
    let kwResults: [String: Any]?

    init(requestId: Int, details: [String: Any], results: [Any]?=nil, kwResults: [String: Any]?=nil) {
        self.requestId = requestId
        self.details = details
        self.results = results
        self.kwResults = kwResults
    }

    /// MARK: SwampMessage protocol

    required init(payload: [Any]) {
        self.requestId = payload[0] as! Int
        self.details = payload[1] as! [String: Any]
        self.results  = payload[safe: 2] as? [Any]
        self.kwResults = payload[safe: 3] as? [String: Any]
    }

    func marshal() -> [Any] {
        var marshalled: [Any] = [SwampMessages.result.rawValue, self.requestId, self.details]

        if let results = self.results {
            marshalled.append(results)
            if let kwResults = self.kwResults {
                marshalled.append(kwResults)
            }
        } else {
            if let kwResults = self.kwResults {
                marshalled.append([])
                marshalled.append(kwResults)
            }
        }

        return marshalled
    }

}
