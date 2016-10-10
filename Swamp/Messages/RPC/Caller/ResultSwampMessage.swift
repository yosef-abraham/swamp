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
    let details: [String: AnyObject]
    let results: [AnyObject]?
    let kwResults: [String: AnyObject]?

    init(requestId: Int, details: [String: AnyObject], results: [AnyObject]?=nil, kwResults: [String: AnyObject]?=nil) {
        self.requestId = requestId
        self.details = details
        self.results = results
        self.kwResults = kwResults
    }

    /// MARK: SwampMessage protocol

    required init(payload: [AnyObject]) {
        self.requestId = payload[0] as! Int
        self.details = payload[1] as! [String: AnyObject]
        self.results  = payload[safe: 2] as? [AnyObject]
        self.kwResults = payload[safe: 3] as? [String: AnyObject]
    }



    func marshal() -> [AnyObject] {
        var marshalled: [AnyObject] = [SwampMessages.result.rawValue as AnyObject, self.requestId as AnyObject, self.details as AnyObject]



        if let results = self.results {
            marshalled.append(results as AnyObject)
            if let kwResults = self.kwResults {
                marshalled.append(kwResults as AnyObject)
            }
        } else {
            if let kwResults = self.kwResults {
                marshalled.append([AnyObject]() as AnyObject)
                marshalled.append(kwResults as AnyObject)
            }
        }

        return marshalled
    }

}
