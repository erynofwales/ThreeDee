//
//  Types.swift
//  Math
//
//  Created by Eryn Wells on 11/6/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import Foundation

public typealias Float = Swift.Float
public typealias Double = Swift.Double

public protocol AlmostEquatable {
    @warn_unused_result
    func ==~(lhs: Self, rhs: Self) -> Bool
}

public protocol EquatableWithinEpsilon: Strideable {
    static var Epsilon: Self.Stride { get }
}

extension Float: EquatableWithinEpsilon {
    public static let Epsilon: Float.Stride = 1e-8
}

extension Double: EquatableWithinEpsilon {
    public static let Epsilon: Double.Stride = 1e-16
}

private func almostEqual<T: EquatableWithinEpsilon>(lhs: T, _ rhs: T, epsilon: T.Stride) -> Bool {
    return abs(lhs - rhs) <= epsilon
}

/** Almost-equality of floating point types. */
infix operator ==~ { associativity left precedence 130 }
public func ==~<T: protocol<AlmostEquatable, EquatableWithinEpsilon>>(lhs: T, rhs: T) -> Bool {
    return almostEqual(lhs, rhs, epsilon: T.Epsilon)
}

infix operator !==~ { associativity left precedence 130 }
public func !==~<T: AlmostEquatable>(lhs: T, rhs: T) -> Bool {
    return !(lhs ==~ rhs)
}