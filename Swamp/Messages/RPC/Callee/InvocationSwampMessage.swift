//
//  InvocationSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 01/09/2016.
//
//

import Foundation

// [INVOCATION, requestId|number, registration|number, details|dict, args|array?, kwargs|dict?]
class InvocationSwampMessage: SwampMessage {

    let requestId: Int
    let registration: Int
    let details: [String: AnyObject]

    let args: [AnyObject]?
    let kwargs: [String: AnyObject]?

    init(requestId: Int, registration: Int, details: [String: AnyObject], args: [AnyObject]?=nil, kwargs: [String: AnyObject]?=nil) {
        self.requestId = requestId
        self.registration = registration
        self.details = details

        self.args = args
        self.kwargs = kwargs
    }

    // MARK: SwampMessage protocol

    required init(payload: [AnyObject]) {
        self.requestId = payload[0] as! Int
        self.registration = payload[1] as! Int
        self.details = payload[2] as! [String: AnyObject]
        self.args = payload[safe: 3] as? [AnyObject]
        self.kwargs = payload[safe: 4] as? [String: AnyObject]
    }



    func marshal() -> [AnyObject] {
        var marshalled: [AnyObject] = [SwampMessages.invocation.rawValue as AnyObject, self.requestId as AnyObject, self.registration as AnyObject, self.details as AnyObject]



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
