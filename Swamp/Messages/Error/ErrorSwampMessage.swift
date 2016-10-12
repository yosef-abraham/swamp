//
//  ErrorSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 22/08/2016.
//
//

import Foundation

/// [ERROR, requestType|number, requestId|number, details|dict, error|string, args|array?, kwargs|dict?]
class ErrorSwampMessage: SwampMessage {
    let requestType: SwampMessages
    let requestId: Int
    let details: [String: AnyObject]
    let error: String

    let args: [AnyObject]?
    let kwargs: [String: AnyObject]?

    init(requestType: SwampMessages, requestId: Int, details: [String: AnyObject], error: String, args: [AnyObject]?=nil, kwargs: [String: AnyObject]?=nil) {
        self.requestType = requestType
        self.requestId = requestId
        self.details = details
        self.error = error
        self.args = args
        self.kwargs = kwargs
    }

    // MARK: SwampMessage protocol

    required init(payload: [AnyObject]) {
        self.requestType = SwampMessages(rawValue: payload[0] as! Int)!
        self.requestId = payload[1] as! Int
        self.details = payload[2] as! [String: AnyObject]
        self.error = payload[3] as! String

        self.args = payload[safe: 4] as? [AnyObject]
        self.kwargs = payload[safe: 5] as? [String: AnyObject]
    }



    func marshal() -> [AnyObject] {
        var marshalled: [AnyObject] = [SwampMessages.error.rawValue as AnyObject, self.requestType.rawValue as AnyObject, self.requestId as AnyObject, self.details as AnyObject, self.error as AnyObject]


        if let args = self.args {
            marshalled.append(args as AnyObject)
            if let kwargs = self.kwargs {
                marshalled.append(kwargs as AnyObject)
            }
        } else {
            if let kwargs = self.kwargs {


                marshalled.append([AnyObject]() as AnyObject)


                marshalled.append(kwargs as AnyObject)
            }
        }


        return marshalled
    }
}
