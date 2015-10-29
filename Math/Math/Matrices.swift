//
//  Matrices.swift
//  Game
//
//  Created by Eryn Wells on 2015-10-24.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

/** A square matrix. */
protocol Matrix {
    typealias ElementType

    static func dimension() -> Int
    static func size() -> Int

    init()
    init?(values: [ElementType])

    subscript(idx: Int) -> ElementType { get set }
    subscript(row: Int, col: Int) -> ElementType { get set }
}

/** A vector. */
protocol Vector {
    init()

    /** Number of elements in the vector. */
    var count: Int { get }
    /** Element access by index. */
    subscript(idx: Int) -> Float { get set }

    /** Length of the vector. */
    var length2: Float { get }
    /** Length-squared of the vector. */
    var length: Float { get }
}

// MARK: - Matrices

public struct Matrix4<T: FloatingPointType>: Matrix {
    static func dimension() -> Int {
        return 4
    }

    static func size() -> Int {
        return dimension() * dimension()
    }

    public private(set) var data: [T]

    public init() {
        data = [T](count: Matrix4.size(), repeatedValue: T(0))
    }

    public init?(values: [T]) {
        guard values.count == Matrix4.size() else { return nil }
        data = values
    }

    public subscript(idx: Int) -> T {
        get {
            return data[idx]
        }
        set(value) {
            data[idx] = value
        }
    }

    public subscript(row: Int, col: Int) -> T {
        get {
            return data[indexFromCoordinates(row, col)]
        }
        set(value) {
            data[indexFromCoordinates(row, col)] = value
        }
    }

    /** Convert a (row, col) pair into an index into the data array. */
    private func indexFromCoordinates(row: Int, _ col: Int) -> Int {
        return row * Matrix4.dimension() + col
    }
}


struct Matrix3 {
    static let Rows = 3
    static let Cols = 3
    static let Size = Matrix3.Rows * Matrix3.Cols
}

// MARK: Vectors

public struct Vector4<T: FloatingPointType> {
    static func size() -> Int {
        return 4
    }

    public private(set) var data: [T]

    init() {
        self.init(x: T(0), y: T(0), z: T(0), w: T(0))
    }

    init(x: T, y: T, z: T, w: T = T(1)) {
        data = [x, y, z, w]
    }

    subscript(idx: Int) -> T {
        get {
            return data[idx]
        }
        set(value) {
            data[idx] = value
        }
    }
}


public struct Vector3: Vector {
    private var data: [Float]

    init() {
        self.init(x: 0.0, y: 0.0, z: 0.0)
    }

    init(x: Float, y: Float, z: Float) {
        data = [x, y, z]
    }

    var length: Float {
        return sqrtf(length2)
    }

    var length2: Float {
        return data.reduce(0.0) { $0 + $1 * $1 }
    }

    // MARK: Sequence-ish

    var count: Int {
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
}

// MARK: - Matrix-Scalar Multiplication


//func *<T: FloatingPointType>(matrix: Matrix4<T>, scalar: T) -> Matrix4<T> {
//    var out: Matrix4<T>
//    for i in 0..<out.data.count {
//        out[i] = matrix.data[i] * scalar
//    }
//    return out
//}

// MARK: - Matrix-Vector Multiplication

//func *<T: FloatingPointType>(matrix: Matrix4<T>, vector: Vector4<T>) -> Vector4<T> {
//    return Vector4<T>()
//}