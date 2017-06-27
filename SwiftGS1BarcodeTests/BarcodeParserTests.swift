//
//  BarcodeParserTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest
@testable import SwiftGS1Barcode

class BarcodeParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGtinPraser(){
        var node = GS1ApplicationIdentifier("01", length:14, type: .AlphaNumeric)
        //        var node = GS1ApplicationIdentifier(identifier: "01", type: .FixedLengthBased, fixedValue: 14)
        node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: "010012349993333001")
        XCTAssertEqual(node.stringValue, "00123499933330")
    }
    func testDatePraser(){
        var node = GS1ApplicationIdentifier("17", length:6, type: .Date)
        //        var node = GS1ApplicationIdentifier(identifier: "01", type: .Date)
        node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: "17210228")
        XCTAssertEqual(node.dateValue, NSDate.from(year: 2021, month: 2, day: 28)) // 17
    }
    func testAlphaNumericFixedLength(){
        var node =  GS1ApplicationIdentifier("10", length: 10, type: .AlphaNumeric, dynamicLength: false)
        node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: "1012345678901")
        XCTAssertEqual(node.originalValue, "1234567890")
        XCTAssertEqual(node.stringValue, "1234567890")
        XCTAssertEqual(node.dateValue, nil)
        XCTAssertEqual(node.intValue, nil)
    }
    func testAlphaNumericFixedLengthTooSmall(){
        var node =  GS1ApplicationIdentifier("10", length: 10, type: .AlphaNumeric, dynamicLength: false)
        node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: "1012")
        XCTAssertEqual(node.originalValue, "12")
        XCTAssertEqual(node.stringValue, "12")
        XCTAssertEqual(node.dateValue, nil)
        XCTAssertEqual(node.intValue, nil)
    }
    func testAlphaNumericFixedLengthEmpty(){
        var node =  GS1ApplicationIdentifier("10", length: 10, type: .AlphaNumeric, dynamicLength: false)
        node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: "10")
        XCTAssertEqual(node.originalValue, "")
        XCTAssertEqual(node.stringValue, "")
        XCTAssertEqual(node.dateValue, nil)
        XCTAssertEqual(node.intValue, nil)
    }
    func testAlphaNumericDymamicLength(){
        var node =  GS1ApplicationIdentifier("10", length: 5, type: .AlphaNumeric, dynamicLength: true)
        node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: "101234\u{1D}1")
        XCTAssertEqual(node.originalValue, "1234")
        XCTAssertEqual(node.stringValue, "1234")
        XCTAssertEqual(node.dateValue, nil)
        XCTAssertEqual(node.intValue, nil)
    }
    func testAlphaNumericDymamicLengthMaxLength(){
        var node =  GS1ApplicationIdentifier("10", length: 5, type: .AlphaNumeric, dynamicLength: true)
        node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: "1012345\u{1D}1")
        XCTAssertEqual(node.originalValue, "12345")
        XCTAssertEqual(node.stringValue, "12345")
        XCTAssertEqual(node.dateValue, nil)
        XCTAssertEqual(node.intValue, nil)
    }
    func testAlphaNumericDymamicLengthTooLarge(){
        var node =  GS1ApplicationIdentifier("10", length: 5, type: .AlphaNumeric, dynamicLength: true)
        node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: "10123456\u{1D}1")
        XCTAssertEqual(node.originalValue, "12345")
        XCTAssertEqual(node.stringValue, "12345")
        XCTAssertEqual(node.dateValue, nil)
        XCTAssertEqual(node.intValue, nil)
    }
    func testGroupSeperatorBasedInt(){
        var node =  GS1ApplicationIdentifier("30", length: 99, type: .Numeric, dynamicLength: true)
        node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: "3001\u{1D}12341234")
        XCTAssertEqual(node.originalValue, "01")
        XCTAssertEqual(node.intValue, 1)
        XCTAssertEqual(node.dateValue, nil)
    }
    func testGroupSeperatorBased(){
        var node = GS1ApplicationIdentifier("30", length: 8, type: .AlphaNumeric, dynamicLength: true)
        node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: "3001\u{1D}12341234")
        XCTAssertEqual(node.originalValue, "01")
        XCTAssertEqual(node.stringValue, "01")
        XCTAssertEqual(node.intValue, nil)
        XCTAssertEqual(node.dateValue, nil)
    }
    func testGroupSeperatorBasedEndOfString(){
        var node = GS1ApplicationIdentifier("30", length: 8, type: .AlphaNumeric, dynamicLength: true)
        node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: "3001")
        XCTAssertEqual(node.originalValue, "01")
        XCTAssertEqual(node.stringValue, "01")
        XCTAssertEqual(node.intValue, nil)
        XCTAssertEqual(node.dateValue, nil)
    }
}
