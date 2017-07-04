//
//  BarcodeParserTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest

@testable import SwiftGS1Barcode

class BarcodeParserTests: GS1BarcodeParserXCTestCase {
    
    override func setUp() {
        super.setUp()
        GS1BarcodeParser.debugOutput = false
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGtinPraser(){
        var ai = GS1ApplicationIdentifier("01", length:14, type: .AlphaNumeric)
        //        var ai = GS1ApplicationIdentifier(identifier: "01", type: .FixedLengthBased, fixedValue: 14)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "010012349993333001")
        XCTAssertEqual(ai.stringValue, "00123499933330")
    }
    func testDatePraser(){
        var ai = GS1ApplicationIdentifier("17", length:6, type: .Date)
        //        var ai = GS1ApplicationIdentifier(identifier: "01", type: .Date)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "17210228")
        XCTAssertEqual(ai.dateValue, NSDate.from(year: 2021, month: 2, day: 28)) // 17
    }
    func testDatePraserNotEnoughData(){
        var ai = GS1ApplicationIdentifier("17", length:6, type: .Date)
        //        var ai = GS1ApplicationIdentifier(identifier: "01", type: .Date)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "172102")
        XCTAssertNil(ai.dateValue)
        XCTAssertEqual(ai.stringValue, nil)
        XCTAssertEqual(ai.rawValue, "2102")
    }
    func testAlphaNumericFixedLength(){
        var ai =  GS1ApplicationIdentifier("10", length: 10, type: .AlphaNumeric, dynamicLength: false)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "1012345678901")
        XCTAssertEqual(ai.rawValue, "1234567890")
        XCTAssertEqual(ai.stringValue, "1234567890")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testAlphaNumericFixedLengthTooSmall(){
        var ai =  GS1ApplicationIdentifier("10", length: 10, type: .AlphaNumeric, dynamicLength: false)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "1012")
        XCTAssertEqual(ai.rawValue, "12")
        XCTAssertEqual(ai.stringValue, "12")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testAlphaNumericFixedLengthEmpty(){
        var ai =  GS1ApplicationIdentifier("10", length: 10, type: .AlphaNumeric, dynamicLength: false)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "10")
        XCTAssertEqual(ai.rawValue, "")
        XCTAssertEqual(ai.stringValue, "")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testAlphaNumericDymamicLength(){
        var ai =  GS1ApplicationIdentifier("10", length: 5, type: .AlphaNumeric, dynamicLength: true)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "101234\u{1D}1")
        XCTAssertEqual(ai.rawValue, "1234")
        XCTAssertEqual(ai.stringValue, "1234")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testAlphaNumericDymamicLengthMaxLength(){
        var ai =  GS1ApplicationIdentifier("10", length: 5, type: .AlphaNumeric, dynamicLength: true)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "1012345\u{1D}1")
        XCTAssertEqual(ai.rawValue, "12345")
        XCTAssertEqual(ai.stringValue, "12345")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testAlphaNumericDymamicLengthTooLarge(){
        var ai =  GS1ApplicationIdentifier("10", length: 5, type: .AlphaNumeric, dynamicLength: true)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "10123456\u{1D}1")
        XCTAssertEqual(ai.rawValue, "12345")
        XCTAssertEqual(ai.stringValue, "12345")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testGroupSeperatorBasedInt(){
        var ai =  GS1ApplicationIdentifier("30", length: 99, type: .Numeric, dynamicLength: true)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "3001\u{1D}12341234")
        XCTAssertEqual(ai.rawValue, "01")
        XCTAssertEqual(ai.intValue, 1)
        XCTAssertEqual(ai.dateValue, nil)
    }
    func testNumeric(){
        var ai =  GS1ApplicationIdentifier("30", length: 2, type: .Numeric, dynamicLength: false)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "3001\u{1D}12341234")
        XCTAssertEqual(ai.rawValue, "01")
        XCTAssertEqual(ai.intValue, 1)
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.stringValue, nil)
    }
    func testNumericWithWrongChars(){
        var ai =  GS1ApplicationIdentifier("30", length: 2, type: .Numeric, dynamicLength: false)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "30ab")
        XCTAssertEqual(ai.rawValue, "ab")
        XCTAssertEqual(ai.intValue, nil)
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.stringValue, nil)
    }
    func testGroupSeperatorBased(){
        var ai = GS1ApplicationIdentifier("30", length: 8, type: .AlphaNumeric, dynamicLength: true)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "3001\u{1D}12341234")
        XCTAssertEqual(ai.rawValue, "01")
        XCTAssertEqual(ai.stringValue, "01")
        XCTAssertEqual(ai.intValue, nil)
        XCTAssertEqual(ai.dateValue, nil)
    }
    func testGroupSeperatorBasedEndOfString(){
        var ai = GS1ApplicationIdentifier("30", length: 8, type: .AlphaNumeric, dynamicLength: true)
        ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "3001")
        XCTAssertEqual(ai.rawValue, "01")
        XCTAssertEqual(ai.stringValue, "01")
        XCTAssertEqual(ai.intValue, nil)
        XCTAssertEqual(ai.dateValue, nil)
    }
}
