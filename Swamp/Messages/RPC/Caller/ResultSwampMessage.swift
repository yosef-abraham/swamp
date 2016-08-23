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
    let args: [AnyObject]?
    let kwargs: [String: AnyObject]?
    
    init(requestId: Int, details: [String: AnyObject], args: [AnyObject]?=nil, kwargs: [String: AnyObject]?=nil) {
        self.requestId = requestId
        self.details = details
        self.args = args
        self.kwargs = kwargs
    }
    
    /// MARK: SwampMessage protocol
    required init(payload: [AnyObject]) {
        self.requestId = payload[0] as! Int
        self.details = payload[1] as! [String: AnyObject]
        self.args = payload[safe: 3] as? [AnyObject]
        self.kwargs = payload[safe: 4] as? [String: AnyObject]
    }
    
    func marshall() -> [AnyObject] {
        var marshalled: [AnyObject] = [SwampMessages.Result.rawValue, self.requestId, self.details]
        
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