//
//  JSONSwampSerializer.swift
//  Pods
//
//  Created by Yossi Abraham on 21/08/2016.
//
//

import Foundation
import SwiftyJSON

open class JSONSwampSerializer: SwampSerializer {
    
    public init() {}
    
    open func pack(_ data: [AnyObject]) -> Data? {
        let json = JSON(data)
        do {
            return try json.rawData()
        }
        catch {
            return nil
        }
    }
    
    open func unpack(_ data: Data) -> [AnyObject]? {
        let json = JSON(data: data)
        return json.arrayObject as [AnyObject]?
    }
}
