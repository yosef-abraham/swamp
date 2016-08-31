//
//  WampCraAuthHelper.swift
//  Pods
//
//  Created by Yossi Abraham on 31/08/2016.
//
//

import Foundation
import CryptoSwift

public class SwampCraAuthHelper {
    public static func sign(secret: String, challenge: String) -> String {
        let hmac: Array<UInt8> = try! Authenticator.HMAC(key: secret.utf8.map {$0}, variant: .sha256).authenticate(challenge.utf8.map {$0})
        return hmac.toBase64()!
    }
}