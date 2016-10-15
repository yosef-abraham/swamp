//
//  Extensions.swift
//
//  Created by Yossi Abraham on 23/08/2016.
//
//

import Foundation

// from http://stackoverflow.com/a/30593673/4017443
extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
