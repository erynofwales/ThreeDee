//
//  Vector.swift
//  Math
//
//  Created by Eryn Wells on 10/29/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import Foundation

/** A vector. */
public protocol Vector: Equatable, AlmostEquatable {
    init()

    /** Number of elements in the vector. */
    static var count: Int { get }

    /** Element access by index. */
    subscript(idx: Int) -> Float { get set }

    /** Length of the vector. */
    var length2: Float { get }
    /** Length-squared of the vector. */
    var length: Float { get }
    /** A normalized copy of the vector. */
    var normalized: Self { get }

    /** The dot product of this vector with another. */
    func dot(lhs: Self) -> Float
}

extension Vector {
    public var length: Float {
        return sqrtf(length2)
    }

    public var length2: Float {
        var l2: Float = 0.0
        for i in 0..<Self.count {
            l2 += self[i] * self[i]
        }
        return l2
    }

    public var normalized: Self {
        return self / length
    }
}

/** A vector with three components: X, Y, and Z. */
public struct Vector3: Vector {
    private var data: [Float]

    public init() {
        self.init(x: 0.0, y: 0.0, z: 0.0)
    }

    public init(v: Vector4) {
        self.init(x: v.x, y: v.y, z: v.z)
    }

    public init(x: Float, y: Float, z: Float) {
        data = [x, y, z]
    }

    // MARK: CollectionType-ish

    public static var count: Int {
        return 3
    }

    public subscript(idx: Int) -> Float {
        get {
            return data[idx]
        }
        set(value) {
            data[idx] = value
        }
    }

    // MARK: Element access

    public var x: Float {
        get {
            return data[0]
        }
        set(value) {
            data[0] = value
        }
    }

    public var y: Float {
        get {
            return data[1]
        }
        set(value) {
            data[1] = value
        }
    }

    public var z: Float {
        get {
            return data[2]
        }
        set(value) {
            data[2] = value
        }
    }
}

extension Vector3: CustomStringConvertible {
    public var description: String {
        return "<\(x), \(y), \(z)>"
    }
}

public struct Vector4: Vector {
    private var data: [Float]

    public init() {
        self.init(x: 0.0, y: 0.0, z: 0.0)
    }

    public init(v: Vector3, w: Float = 1.0) {
        self.init(x: v.x, y: v.y, z: v.z, w: w)
    }

    public init(x: Float, y: Float, z: Float, w: Float = 1.0) {
        data = [x, y, z, w]
    }

    // MARK: SequenceType-ish

    public static var count: Int {
        return 4
    }

    public subscript(idx: Int) -> Float {
        get {
            return data[idx]
        }
        set(value) {
            data[idx] = value
        }
    }

    // MARK: Element access

    public var x: Float {
        return data[0]
    }

    public var y: Float {
        return data[1]
    }

    public var z: Float {
        return data[2]
    }
    
    public var w: Float {
        return data[3]
    }
}

extension Vector4: CustomStringConvertible {
    public var description: String {
        return "<\(x), \(y), \(z), \(w)>"
    }
}

// MARK: - Operators

extension Vector {
    public func dot(rhs: Self) -> Float {
        var sum: Float = 0.0
        for i in 0..<Self.count {
            sum += self[i] * rhs[i]
        }
        return sum
    }
}

extension Vector3 {
    public func cross(rhs: Vector3) -> Vector3 {
        return Vector3(x: data[1] * rhs.data[2] - data[2] * rhs.data[1],
                       y: data[2] * rhs.data[0] - data[0] * rhs.data[2],
                       z: data[0] * rhs.data[1] - data[1] * rhs.data[0])
    }
}

// MARK: Addition

public prefix func -<T: Vector>(v: T) -> T {
    var out = v
    for i in 0..<T.count {
        out[i] -= -out[i]
    }
    return out
}

public func +=<T: Vector>(inout lhs: T, rhs: T) {
    for i in 0..<T.count {
        lhs[i] += rhs[i]
    }
}

public func +<T: Vector>(lhs: T, rhs: T) -> T {
    var out = lhs
    out += rhs
    return out
}

public func -=<T: Vector>(inout lhs: T, rhs: T) {
    for i in 0..<T.count {
        lhs[i] -= rhs[i]
    }
}

public func -<T: Vector>(lhs: T, rhs: T) -> T {
    var out = lhs
    out -= rhs
    return out
}

// MARK: Multiplication

public func *=<T: Vector>(inout lhs: T, rhs: Float) {
    for i in 0..<T.count {
        lhs[i] *= rhs
    }
}

public func *<T: Vector>(lhs: Float, rhs: T) -> T {
    var out = rhs
    out *= lhs
    return out
}

public func *<T: Vector>(lhs: T, rhs: Float) -> T {
    return rhs * lhs
}

public func /=<T: Vector>(inout lhs: T, rhs: Float) {
    lhs *= (1.0 / rhs)
}

public func /<T: Vector>(lhs: T, rhs: Float) -> T {
    return lhs * (1.0 / rhs)
}

infix operator ∙ { associativity left precedence 150 }
public func ∙<T: Vector>(lhs: T, rhs: T) -> Float {
    return lhs.dot(rhs)
}

infix operator ×= { associativity left precedence 151 }
public func ×=(inout lhs: Vector3, rhs: Vector3) {
    lhs = lhs.cross(rhs)
}

infix operator × { associativity left precedence 151 }
public func ×(lhs: Vector3, rhs: Vector3) -> Vector3 {
    return lhs.cross(rhs)
}

// MARK: Equality

public func ==<T: Vector>(lhs: T, rhs: T) -> Bool {
    for i in 0..<T.count {
        if lhs[i] != rhs[i] {
            return false
        }
    }
    return true
}

public func ==~<T: Vector>(lhs: T, rhs: T) -> Bool {
    for i in 0..<T.count {
        if lhs[i] !==~ rhs[i] {
            return false
        }
    }
    return true
}

public func ==~<T: Vector>(lhs: T?, rhs: T?) -> Bool {
    if let lhs = lhs, rhs = rhs {
        return lhs ==~ rhs
    }
    return false
}