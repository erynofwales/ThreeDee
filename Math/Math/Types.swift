//
//  Types.swift
//  Math
//
//  Created by Eryn Wells on 11/6/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import Foundation

public typealias Float = Swift.Float

/** Acceptable tolerance for Float equality. */
let Epsilon: Float = 1e-6

extension Float {
    /** Test that `other` is almost equal (i.e. within the +/- Epsilon) to `self`. */
    func almostEqual(other: Float) -> Bool {
        return other >= (self - Epsilon) && other <= (self + Epsilon)
    }
}

/** Custom operator for almost-equality of floats. */
infix operator =~ { associativity left precedence 130 }
public func =~(lhs: Float, rhs: Float) -> Bool {
    return lhs.almostEqual(rhs)
}