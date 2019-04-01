//
//  GS1ApplicationIdentifierTypeTests.swift
//  SwiftGS1BarcodeTests
//
//  Created by Toni Hoffmann on 14.05.18.
//  Copyright © 2018 Toni Hoffmann. All rights reserved.
//

import XCTest
@testable import SwiftGS1Barcode

class GS1ApplicationIdentifierTypeTests: XCTestCase {
    func testAlphaNumericType(){
        let type = GS1ApplicationIdentifierType.AlphaNumeric
        XCTAssertEqual(type.description, "AlphaNumeric")
    }
    func testNumericType(){
        let type = GS1ApplicationIdentifierType.Numeric
        XCTAssertEqual(type.description, "Numeric")
    }
    func testNumericDoubleType(){
        let type = GS1ApplicationIdentifierType.NumericDouble
        XCTAssertEqual(type.description, "NumericDouble")
    }
    func testDateType(){
        let type = GS1ApplicationIdentifierType.Date
        XCTAssertEqual(type.description, "Date")
    }
}
