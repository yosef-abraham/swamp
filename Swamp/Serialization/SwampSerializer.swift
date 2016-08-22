//
//  SwampSerializer.swift
//  Pods
//
//  Created by Yossi Abraham on 21/08/2016.
//
//

import Foundation

public protocol SwampSerializer {
    func pack(data: [AnyObject]) -> NSData?
    func unpack(data: NSData) -> [AnyObject]?
}