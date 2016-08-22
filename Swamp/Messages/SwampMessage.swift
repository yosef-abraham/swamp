//
//  WampMessage.swift
//  Pods
//
//  Created by Yossi Abraham on 22/08/2016.
//
//

import Foundation

protocol SwampMessage {
    init(payload: [AnyObject])
    func marshall() -> [AnyObject]
}