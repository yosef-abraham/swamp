//
//  JSONSwampSerializer.swift
//  Pods
//
//  Created by Yossi Abraham on 21/08/2016.
//
//

import Foundation
import SwiftyJSON

class JSONSwampSerializer: SwampSerializer {
    func pack(data: [AnyObject]) -> NSData? {
        let json = JSON(data)
        do {
            return try json.rawData()
        }
        catch {
            return nil
        }
    }
    
    func unpack(data: NSData) -> [AnyObject]? {
        let json = JSON(data: data)
        return json.arrayObject
    }
}
