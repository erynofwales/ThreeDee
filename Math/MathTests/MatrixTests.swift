//
//  MathTests.swift
//  MathTests
//
//  Created by Eryn Wells on 10/28/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import XCTest
@testable import Math

// MARK: - Matrix4

class Matrix4Tests: XCTestCase {
    func testThatItHasProperDimension() {
        XCTAssertEqual(Matrix4.dimension, 4)
    }

    func testThatItHasProperCount() {
        XCTAssertEqual(Matrix4.count, 16)
        XCTAssertEqual(Matrix4().data.count, Matrix4.count)
    }

    func testThatInitThrowsForInvalidSizeOfValuesArray() {
        do {
            let m = try Matrix4(values: [])
            -m
            XCTFail()
        } catch MatrixError.InvalidSize(let given, let expected) {
            XCTAssertEqual(given, 0)
            XCTAssertEqual(expected, Matrix4.count)
        } catch {
            XCTFail()
        }
    }
}

class Matrix4SubscriptTests: XCTestCase {
    let values: [Float] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    var m = Matrix4()

    override func setUp() {
        do {
            m = try Matrix4(values: values)
        } catch {
            XCTFail()
        }
    }

    func testThatSingleSubscriptWorks() {
        for i in 0..<Matrix4.count {
            XCTAssertEqual(m[i], m.data[i])
        }
    }

    func testThatRowColumnSubscriptWorks() {
        var value: Int = 0
        for i in 0..<Matrix4.dimension {
            for j in 0..<Matrix4.dimension {
                XCTAssertEqual(m[i,j], values[value++])
            }
        }
    }

    func testThatSingleSubscriptAssignmentWorks() {
        m[6] = 42.0
        XCTAssertEqual(m[6], 42.0)
    }

    func testThatRowColumnSubscriptAssignmentWorks() {
        m[1,2] = 42.0
        XCTAssertEqual(m[1,2], 42.0)
    }
}

class Matrix4OperatorTests: XCTestCase {
    var m = Matrix4()
    let mValues: [Float] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    var n = Matrix4()
    let nValues: [Float] = [2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32]

    override func setUp() {
        do {
            m = try Matrix4(values: mValues)
            n = try Matrix4(values: nValues)
        } catch {
            XCTFail()
        }
    }

    func testThatMatrixNegationWorks() {
        for el in zip((-m).data, m.data) {
            XCTAssertEqual(el.0, -el.1)
        }
    }

    func testThatScalarMultiplicationWorks() {
        for el in zip((3 * m).data, m.data) {
            XCTAssertEqual(el.0, 3 * el.1)
        }
    }

    func testThatBinaryMatrixMultiplicationWorks() {
        /* 
         * Wolfram Alpha gave me the answer to this multiplication with the 4
         * factored out. Instead of doing the math by hand, I just mapped (*4)
         * over the array. :3
         */
        XCTAssertEqual((m * n).data, [31,34,37,40,87,98,109,120,143,162,181,200,199,226,253,280].map { $0 * 4 })
    }

    func testThatBinaryMatrixMultiplicationEqualsWorks() {
        m *= n
        /*
         * Wolfram Alpha gave me the answer to this multiplication with the 4
         * factored out. Instead of doing the math by hand, I just mapped (*4)
         * over the array. :3
         */
        XCTAssertEqual(m.data, [31,34,37,40,87,98,109,120,143,162,181,200,199,226,253,280].map { $0 * 4 })
    }
}

// MARK: - Matrix3

class Matrix3Tests: XCTestCase {
    func testThatItHasProperDimension() {
        XCTAssertEqual(Matrix3.dimension, 3)
    }

    func testThatItHasProperCount() {
        XCTAssertEqual(Matrix3.count, 9)
        XCTAssertEqual(Matrix3().data.count, Matrix3.count)
    }
}

class Matrix3SubscriptTests: XCTestCase {
    var values: [Float] = [0,1,2,3,4,5,6,7,8]
    var m = Matrix3()

    override func setUp() {
        do {
            m = try Matrix3(values: values)
        } catch {
            XCTFail()
        }
    }

    func testThatSingleSubscriptWorks() {
        for i in 0..<Matrix3.count {
            XCTAssertEqual(m[i], m.data[i])
        }
    }

    func testThatRowColumnSubscriptWorks() {
        var value: Int = 0
        for i in 0..<Matrix3.dimension {
            for j in 0..<Matrix3.dimension {
                XCTAssertEqual(m[i,j], values[value++])
            }
        }
    }

    func testThatSingleSubscriptAssignmentWorks() {
        m[6] = 42.0
        XCTAssertEqual(m[6], 42.0)
    }

    func testThatRowColumnSubscriptAssignmentWorks() {
        m[1,2] = 42.0
        XCTAssertEqual(m[1,2], 42.0)
    }
}
