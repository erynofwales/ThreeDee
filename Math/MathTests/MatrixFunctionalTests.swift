//
//  MatrixFunctionalTests.swift
//  Math
//
//  Created by Eryn Wells on 11/6/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import Foundation
import XCTest
@testable import Math

func assertVectorAlmostEqual<T: Vector>(@autoclosure lhs: () -> T?, @autoclosure _ rhs: () -> T?, message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
    let lhsValue = lhs()
    let rhsValue = rhs()
    let msg = message != "" ? message : "expected \(lhsValue), got \(rhsValue)"
    XCTAssert(lhsValue ==~ rhsValue, msg, file: file, line: line)
}

class MatrixVectorTests: XCTestCase {
    func testThatMultiplyingIdentityByAVectorGivesTheVector() {
        let v = Matrix4.identity * Vector4(x: 1, y: 2, z: 3)
        assertVectorAlmostEqual(v, Vector4(x: 1, y: 2, z: 3))
    }

    func testThatMultiplyingTranslationByAVectorGivesTranslatedVector() {
        let v = Matrix4(translationWithX: 1, y: 1, z: 1) * Vector4(x: 2, y: 2, z: 2)
        assertVectorAlmostEqual(v, Vector4(x: 3, y: 3, z: 3))
    }
}