//
//  CallSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 23/08/2016.
//
//

import Foundation

/// [CALL, requestId|number, options|dict, proc|string, args|array?, kwargs|dict?]
class CallSwampMessage: SwampMessage {

    let requestId: Int
    let options: [String: AnyObject]
    let proc: String
    let args: [AnyObject]?
    let kwargs: [String: AnyObject]?

    init(requestId: Int, options: [String: AnyObject], proc: String, args: [AnyObject]?=nil, kwargs: [String: AnyObject]?=nil) {
        self.requestId = requestId
        self.options = options
        self.proc = proc
        self.args = args
        self.kwargs = kwargs
    }

    /// MARK: SwampMessage protocol

    required init(payload: [AnyObject]) {
        self.requestId = payload[0] as! Int
        self.options = payload[1] as! [String: AnyObject]
        self.proc = payload[2] as! String
        self.args = payload[safe: 3] as? [AnyObject]
        self.kwargs = payload[safe: 4] as? [String: AnyObject]
    }



    func marshal() -> [AnyObject] {
        var marshalled: [AnyObject] = [SwampMessages.call.rawValue as AnyObject, self.requestId as AnyObject, self.options as AnyObject, self.proc as AnyObject]



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
