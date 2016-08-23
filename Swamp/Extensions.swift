//
//  Extensions.swift
//
//  Created by Yossi Abraham on 23/08/2016.
//
//

import Foundation

// from http://stackoverflow.com/a/30593673/4017443
extension CollectionType {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}