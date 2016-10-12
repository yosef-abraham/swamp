//
//  SwampSerializer.swift
//  Pods
//
//  Created by Yossi Abraham on 21/08/2016.
//
//

import Foundation

public protocol SwampSerializer {
    func pack(_ data: [AnyObject]) -> Data?
    func unpack(_ data: Data) -> [AnyObject]?
}
