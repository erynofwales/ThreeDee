//
//  Matrices.swift
//  Game
//
//  Created by Eryn Wells on 2015-10-24.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

/** A square matrix. */
public protocol Matrix {
    /** The identity matrix. */
    static var identity: Self { get }

    /** Number of elements in the underlying container. */
    static var count: Int { get }

    /**
     * Number of elements in a single row or column of the matrix. Since
     * matrices are always square, this applies to row and column.
     */
    static var dimension: Int { get }

    /** Initialize a Matrix filled with zeroes. */
    init()

    /** 
     * Initialize a Matrix with a given array of values. The number of values
     * must match the count of the array; otherwise, a MatrixError.InvalidSize
     * error is thrown.
     */
    init(values: [Float]) throws

    /** The underlying data array. */
    var data: [Float] { get }

    /** 
     * Element access
     * @{
     */
    subscript(idx: Int) -> Float { get set }
    subscript(row: Int, col: Int) -> Float { get set }
    /** @} */
}

extension Matrix {
    public static var count: Int {
        return dimension * dimension
    }
}

public enum MatrixError: ErrorType {
    case InvalidSize(given: Int, expected: Int)
}

// MARK: - Matrices

public struct Matrix4: Matrix {
    public static var identity: Matrix4 = {
        var matrix = Matrix4()
        for i in 0..<Matrix4.dimension {
            matrix[i,i] = 1.0
        }
        return matrix
    }()

    public private(set) var data: [Float]

    public init() {
        data = [Float](count: Matrix4.count, repeatedValue: Float(0))
    }

    public init(values: [Float]) throws {
        guard values.count == Matrix4.count else {
            throw MatrixError.InvalidSize(given: values.count, expected: Matrix4.count)
        }
        data = values
    }


    public static var dimension: Int {
        return 4
    }

    public subscript(idx: Int) -> Float {
        get {
            return data[idx]
        }
        mutating set(value) {
            data[idx] = value
        }
    }

    public subscript(row: Int, col: Int) -> Float {
        get {
            return data[indexFromCoordinates(row, col)]
        }
        mutating set(value) {
            data[indexFromCoordinates(row, col)] = value
        }
    }

    /** Convert a (row, col) pair into an index into the data array. */
    private func indexFromCoordinates(row: Int, _ col: Int) -> Int {
        return row * Matrix4.dimension + col
    }
}

public struct Matrix3: Matrix {
    public static var identity: Matrix3 = {
        var matrix = Matrix3()
        for i in 0..<Matrix3.dimension {
            matrix[i,i] = 1.0
        }
        return matrix
    }()

    public private(set) var data: [Float]

    public init() {
        data = [Float](count: Matrix3.count, repeatedValue: Float(0))
    }

    public init(values: [Float]) throws {
        guard values.count == Matrix3.count else {
            throw MatrixError.InvalidSize(given: values.count, expected: Matrix3.count)
        }
        data = values
    }

    public static var dimension: Int {
        return 3
    }

    public subscript(idx: Int) -> Float {
        get {
            return data[idx]
        }
        mutating set(value) {
            data[idx] = value
        }
    }

    public subscript(row: Int, col: Int) -> Float {
        get {
            return data[indexFromCoordinates(row, col)]
        }
        mutating set(value) {
            data[indexFromCoordinates(row, col)] = value
        }
    }

    /** Convert a (row, col) pair into an index into the data array. */
    private func indexFromCoordinates(row: Int, _ col: Int) -> Int {
        return row * Matrix3.dimension + col
    }
}

// MARK: - Operators

public prefix func -<T: Matrix>(m: T) -> T {
    var out = m
    for i in 0..<T.count {
        out[i] -= -out[i]
    }
    return out
}

// MARK: Matrix-Scalar Multiplication

public func *=<T: Matrix>(inout lhs: T, rhs: Float) {
    for i in 0..<T.count {
        lhs[i] *= rhs
    }
}

public func *<T: Matrix>(lhs: T, rhs: Float) -> T {
    var out = lhs
    out *= rhs
    return out
}

public func *<T: Matrix>(lhs: Float, rhs: T) -> T {
    return rhs * lhs
}

public func /=<T: Matrix>(inout lhs: T, rhs: Float) {
    lhs *= (1.0 / rhs)
}

public func /<T: Matrix>(lhs: T, rhs: Float) -> T {
    var out = lhs
    out /= rhs
    return out
}

// MARK: Matrix addition

public func +=<T: Matrix>(inout lhs: T, rhs: T) {
    for i in 0..<T.dimension {
        lhs[i] += rhs[i]
    }
}

public func +<T: Matrix>(lhs: T, rhs: T) -> T {
    var out = lhs
    out += rhs
    return out
}

public func -=<T: Matrix>(inout lhs: T, rhs: T) {
    for i in 0..<T.dimension {
        lhs[i] -= rhs[i]
    }
}

public func -<T: Matrix>(lhs: T, rhs: T) -> T {
    var out = lhs
    out -= rhs
    return out
}

// MARK: Matrix-Matrix multiplication

public func *=<T: Matrix>(inout lhs: T, rhs: T) {
    for i in 0..<T.dimension {
        for j in 0..<T.dimension {
            // Each cell is Sigma(k=0, M)(lhs[ik] * rhs[kj]
            for k in 0..<T.dimension {
                lhs[i,j] += lhs[i,k] * rhs[k,j]
            }
        }
    }
}

public func *<T: Matrix>(lhs: T, rhs: T) -> T {
    var out = lhs
    out *= rhs
    return out
}

// MARK: Matrix-Vector multiplication

public func *(lhs: Matrix4, rhs: Vector4) -> Vector4 {
    var out = Vector4()
    for i in 0..<Matrix4.dimension {
        for j in 0..<Matrix4.dimension {
            out[i] += lhs[i] * rhs[j]
        }
    }
    return out
}

public func *(lhs: Matrix3, rhs: Vector3) -> Vector3 {
    var out = Vector3()
    for i in 0..<Matrix3.dimension {
        for j in 0..<Matrix3.dimension {
            out[i] += lhs[i] * rhs[j]
        }
    }
    return out
}