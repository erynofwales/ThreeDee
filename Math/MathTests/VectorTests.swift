//
//  VectorTests.swift
//  Math
//
//  Created by Eryn Wells on 11/12/15.
//  Copyright © 2015 Eryn Wells. All rights reserved.
//

import XCTest
@testable import Math

class VectorTests: XCTestCase {
    func testThatLengthOfAUnitVectorIsSane() {
        XCTAssertEqualWithAccuracy(Vector3(x: 1, y: 0, z: 0).length, 1.0, accuracy: Float.Epsilon)
    }

    func testThatTheLength2OfAVectorIsSane() {
        XCTAssertEqualWithAccuracy(Vector3(x: 2, y: 0, z: 0).length2, 4.0, accuracy: Float.Epsilon)
    }

    func testThatANormalizedVectorHasLength1() {
        XCTAssertEqualWithAccuracy(Vector3(x: 1, y: 2, z: 3).normalized.length, 1.0, accuracy: 1e-6)
    }
}