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