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
    let details: [String: Any]
    let error: String
    
    let args: [Any]?
    let kwargs: [String: Any]?
    
    init(requestType: SwampMessages, requestId: Int, details: [String: Any], error: String, args: [Any]?=nil, kwargs: [String: Any]?=nil) {
        self.requestType = requestType
        self.requestId = requestId
        self.details = details
        self.error = error
        self.args = args
        self.kwargs = kwargs
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [Any]) {
        self.requestType = SwampMessages(rawValue: payload[0] as! Int)!
        self.requestId = payload[1] as! Int
        self.details = payload[2] as! [String: Any]
        self.error = payload[3] as! String
        
        self.args = payload[safe: 4] as? [Any]
        self.kwargs = payload[safe: 5] as? [String: Any]
    }
    
    func marshal() -> [Any] {
        var marshalled: [Any] = [SwampMessages.error.rawValue, self.requestType.rawValue, self.requestId, self.details, self.error]
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
