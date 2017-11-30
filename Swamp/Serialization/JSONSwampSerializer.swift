//
//  JSONSwampSerializer.swift
//  Pods
//
//  Created by Yossi Abraham on 21/08/2016.
//
//

import Foundation

open class JSONSwampSerializer: SwampSerializer {
    
    public init() {}
    
    open func pack(_ data: [Any]) -> Data? {
        do {
            let returnData = try JSONSerialization.data(withJSONObject: data, options: [])
            return returnData
        }
        catch {
            return nil
        }
    }
    
    open func unpack(_ data: Data) -> [Any]? {
        do {
            let unpackedData = try JSONSerialization.jsonObject(with: data, options: [])

            if let returnedArray = unpackedData as? [Any] {
                return returnedArray
            }
            
            return []
        } catch {
            return []
        }
    }
}
