//
//  WampCraAuthHelper.swift
//  Pods
//
//  Created by Yossi Abraham on 31/08/2016.
//
//

import Foundation
import CryptoSwift

open class SwampCraAuthHelper {
    open static func sign(_ secret: String, challenge: String) -> String {
        let hmac: Array<UInt8> = try! CryptoSwift.HMAC(key: secret.utf8.map {$0}, variant: .sha256).authenticate(challenge.utf8.map {$0})
        return hmac.toBase64()!
    }
}
