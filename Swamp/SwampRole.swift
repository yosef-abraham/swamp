//
//  SwampRole.swift
//  Pods
//
//  Created by Yossi Abraham on 22/08/2016.
//
//

import Foundation

enum SwampRole: String {
    // Client roles
    case Caller = "caller"
    case Callee = "callee"
    case Subscriber = "subscriber"
    case Publisher = "publisher"
    
    // Route roles
    case Broker = "broker"
    case Dealer = "dealer"
}