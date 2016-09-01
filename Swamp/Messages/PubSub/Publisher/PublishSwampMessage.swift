//
//  PublishSwampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 01/09/2016.
//
//

import Foundation

/// [PUBLISH, requestId|number, options|dict, topic|String, args|list?, kwargs|dict?]
class PublishSwampMessage: SwampMessage {
    
    let requestId: Int
    let options: [String: AnyObject]
    let topic: String
    
    let args: [AnyObject]?
    let kwargs: [String: AnyObject]?
    
    init(requestId: Int, options: [String: AnyObject], topic: String, args: [AnyObject]?=nil, kwargs: [String: AnyObject]?=nil) {
        self.requestId = requestId
        self.options = options
        self.topic = topic
        
        self.args = args
        self.kwargs = kwargs
    }
    
    // MARK: SwampMessage protocol
    
    required init(payload: [AnyObject]) {
        self.requestId = payload[0] as! Int
        self.options = payload[1] as! [String: AnyObject]
        self.topic = payload[2] as! String
        self.args = payload[safe: 3] as? [AnyObject]
        self.kwargs = payload[safe: 4] as? [String: AnyObject]
    }
    
    func marshal() -> [AnyObject] {
        var marshalled: [AnyObject] = [SwampMessages.Publish.rawValue, self.requestId, self.options, self.topic]
        
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