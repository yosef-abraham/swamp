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
        var marshalled: [AnyObject] = [SwampMessages.Error.rawValue, self.requestType.rawValue, self.requestId, self.details, self.error]
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