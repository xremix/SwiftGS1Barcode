//
//  GS1ApplicationIdentifierTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest

@testable import SwiftGS1Barcode
class GS1ApplicationIdentifierTests: XCTestCase {
    
    func testInitIdMaxLength() {
        let node = GS1ApplicationIdentifier("id", length: 1)
        XCTAssertEqual(node.identifier, "id")
        XCTAssertEqual(node.maxLength, 1)
        XCTAssertEqual(node.type, nil)
    }
    
    func testInitIdMaxLengthType() {
        let node = GS1ApplicationIdentifier("id", length: 1, type: .Numeric)
        XCTAssertEqual(node.identifier, "id")
        XCTAssertEqual(node.maxLength, 1)
        XCTAssertEqual(node.type, .Numeric)
    }
    
    func testInitIdMaxLengthTypeDynamicLength() {
        let node = GS1ApplicationIdentifier("id", length: 1, type: .Numeric, dynamicLength: true)
        XCTAssertEqual(node.identifier, "id")
        XCTAssertEqual(node.maxLength, 1)
        XCTAssertEqual(node.type, .Numeric)
        XCTAssertEqual(node.dynamicLength, true)
    }
}
