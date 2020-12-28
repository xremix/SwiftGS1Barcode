//
//  GS1ApplicationIdentifierTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest

@testable import SwiftGS1Barcode
class GS1ApplicationIdentifierTests: GS1BarcodeParserXCTestCase {
    // Tests Max Length
    func testInitIdMaxLength() {
        let ai = GS1ApplicationIdentifier("id", length: 1)
        XCTAssertEqual(ai.identifier, "id")
        XCTAssertEqual(ai.maxLength, 1)
        XCTAssertEqual(ai.type, nil)
    }
    
    func testInitIdMaxLengthType() {
        let ai = GS1ApplicationIdentifier("id", length: 1, type: .Numeric)
        XCTAssertEqual(ai.identifier, "id")
        XCTAssertEqual(ai.maxLength, 1)
        XCTAssertEqual(ai.type, .Numeric)
    }
    
    func testInitIdMaxLengthTypeDynamicLength() {
        let ai = GS1ApplicationIdentifier("id", length: 1, type: .Numeric, dynamicLength: true)
        XCTAssertEqual(ai.identifier, "id")
        XCTAssertEqual(ai.maxLength, 1)
        XCTAssertEqual(ai.type, .Numeric)
        XCTAssertEqual(ai.dynamicLength, true)
    }
    func testReadableValue() {
        let ai = GS1ApplicationIdentifier("id", length: 1, type: .NumericDouble, dynamicLength: true)
        ai.doubleValue = 0.1
        XCTAssertEqual(ai.readableValue, "0.1")
    }
}
