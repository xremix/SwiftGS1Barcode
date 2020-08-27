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
        GS1BarcodeParser.printDebugOutput = false
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDebugOutput(){
        GS1BarcodeParser.printDebugOutput = true
        let ai = GS1ApplicationIdentifier("01", length:14, type: .AlphaNumeric)
        //        let ai = GS1ApplicationIdentifier(identifier: "01", type: .FixedLengthBased, fixedValue: 14)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "010012349993333001")
        }catch{}
        GS1BarcodeParser.printDebugOutput = false
        XCTAssertEqual(ai.stringValue, "00123499933330")
    }
    
    func testGtinPraser(){
        let ai = GS1ApplicationIdentifier("01", length:14, type: .AlphaNumeric)
        //        let ai = GS1ApplicationIdentifier(identifier: "01", type: .FixedLengthBased, fixedValue: 14)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "010012349993333001")
        }catch{}
        XCTAssertEqual(ai.stringValue, "00123499933330")
    }
    
    func testDatePraser(){
        let ai = GS1ApplicationIdentifier("17", length:6, type: .Date)
        //        let ai = GS1ApplicationIdentifier(identifier: "01", type: .Date)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "17210228")
        }catch{}
        XCTAssertEqual(ai.dateValue, Date.from(year: 2021, month: 2, day: 28)) // 17
    }
    
    func testDatePraserNotEnoughData(){
        let ai = GS1ApplicationIdentifier("17", length:6, type: .Date)
        //        let ai = GS1ApplicationIdentifier(identifier: "01", type: .Date)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "172102")
        }catch{}
        XCTAssertNil(ai.dateValue)
        XCTAssertEqual(ai.stringValue, nil)
        XCTAssertEqual(ai.rawValue, "2102")
    }
    
    func testAlphaNumericFixedLength(){
        let ai = GS1ApplicationIdentifier("10", length: 10, type: .AlphaNumeric, dynamicLength: false)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "1012345678901")
        }catch{}
        XCTAssertEqual(ai.rawValue, "1234567890")
        XCTAssertEqual(ai.stringValue, "1234567890")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testAlphaNumericFixedLengthTooSmall(){
        let ai = GS1ApplicationIdentifier("10", length: 10, type: .AlphaNumeric, dynamicLength: false)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "1012")
        }catch{}
        XCTAssertEqual(ai.rawValue, "12")
        XCTAssertEqual(ai.stringValue, "12")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testAlphaNumericFixedLengthEmpty(){
        let ai = GS1ApplicationIdentifier("10", length: 10, type: .AlphaNumeric, dynamicLength: false)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "10")
        }catch{}
        XCTAssertEqual(ai.rawValue, "")
        XCTAssertEqual(ai.stringValue, "")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testAlphaNumericDymamicLength(){
        let ai = GS1ApplicationIdentifier("10", length: 5, type: .AlphaNumeric, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "101234\u{1D}1")
        }catch{}
        XCTAssertEqual(ai.rawValue, "1234")
        XCTAssertEqual(ai.stringValue, "1234")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testAlphaNumericDymamicLengthMaxLength(){
        let ai = GS1ApplicationIdentifier("10", length: 5, type: .AlphaNumeric, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "1012345\u{1D}1")
        }catch{}
        XCTAssertEqual(ai.rawValue, "12345")
        XCTAssertEqual(ai.stringValue, "12345")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testAlphaNumericDymamicLengthTooLarge(){
        let ai = GS1ApplicationIdentifier("10", length: 5, type: .AlphaNumeric, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "10123456\u{1D}1")
        }catch{}
        XCTAssertEqual(ai.rawValue, "12345")
        XCTAssertEqual(ai.stringValue, "12345")
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.intValue, nil)
    }
    func testGroupSeperatorBasedInt(){
        let ai = GS1ApplicationIdentifier("30", length: 99, type: .Numeric, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "3001\u{1D}12341234")
        }catch{}
        XCTAssertEqual(ai.rawValue, "01")
        XCTAssertEqual(ai.intValue, 1)
        XCTAssertEqual(ai.dateValue, nil)
    }
    func testNumeric(){
        let ai = GS1ApplicationIdentifier("30", length: 2, type: .Numeric, dynamicLength: false)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "3001\u{1D}12341234")
        }catch{}
        XCTAssertEqual(ai.rawValue, "01")
        XCTAssertEqual(ai.intValue, 1)
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.stringValue, nil)
    }
    func testNumericWithWrongChars(){
        let ai = GS1ApplicationIdentifier("30", length: 2, type: .Numeric, dynamicLength: false)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "30ab")
        }catch{}
        XCTAssertEqual(ai.rawValue, "ab")
        XCTAssertEqual(ai.intValue, nil)
        XCTAssertEqual(ai.dateValue, nil)
        XCTAssertEqual(ai.stringValue, nil)
    }
    func testGroupSeperatorBased(){
        let ai = GS1ApplicationIdentifier("30", length: 8, type: .AlphaNumeric, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "3001\u{1D}12341234")
        }catch{}
        XCTAssertEqual(ai.rawValue, "01")
        XCTAssertEqual(ai.stringValue, "01")
        XCTAssertEqual(ai.intValue, nil)
        XCTAssertEqual(ai.dateValue, nil)
    }
    func testGroupSeperatorBasedEndOfString(){
        let ai = GS1ApplicationIdentifier("30", length: 8, type: .AlphaNumeric, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "3001")
        }catch{}
        XCTAssertEqual(ai.rawValue, "01")
        XCTAssertEqual(ai.stringValue, "01")
        XCTAssertEqual(ai.intValue, nil)
        XCTAssertEqual(ai.dateValue, nil)
    }
    
    
    /* ************ Numeric Double tests ************ */
    
    func testNumericDoubleValue(){
        let ai = GS1ApplicationIdentifier("310", length: 8, type: .NumericDouble, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "3101123")
        }catch{}
        XCTAssertEqual(ai.rawValue, "123")
        XCTAssertEqual(ai.doubleValue, 12.3)
        
        XCTAssertEqual(ai.stringValue, nil)
        XCTAssertEqual(ai.intValue, nil)
        XCTAssertEqual(ai.dateValue, nil)
    }
    func testNumericDoubleValue2(){
        let ai = GS1ApplicationIdentifier("310", length: 8, type: .NumericDouble, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "3102123")
        }catch{}
        XCTAssertEqual(ai.rawValue, "123")
        XCTAssertEqual(ai.doubleValue, 1.23)
        
        XCTAssertEqual(ai.stringValue, nil)
        XCTAssertEqual(ai.intValue, nil)
        XCTAssertEqual(ai.dateValue, nil)
    }
    func testNumericDoubleValue3(){
        let ai = GS1ApplicationIdentifier("310", length: 8, type: .NumericDouble, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "3103123")
        }catch{}
        XCTAssertEqual(ai.rawValue, "123")
        XCTAssertEqual(ai.doubleValue, 0.123)
        
        XCTAssertEqual(ai.stringValue, nil)
        XCTAssertEqual(ai.intValue, nil)
        XCTAssertEqual(ai.dateValue, nil)
    }
    
    func testNumericDoubleValue1(){
        let ai = GS1ApplicationIdentifier("310", length: 8, type: .NumericDouble, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "31011234")
        }catch{}
        XCTAssertEqual(ai.rawValue, "1234")
        XCTAssertEqual(ai.doubleValue, 123.4)
        XCTAssertEqual(ai.stringValue, nil)
        XCTAssertEqual(ai.intValue, nil)
        XCTAssertEqual(ai.dateValue, nil)
    }
    
    /* ************ Fail tests ************ */
    
    func testDataWrongStart(){
        let ai = GS1ApplicationIdentifier("30", length: 8, type: .AlphaNumeric, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "0000")
        }catch let e as GS1BarcodeErrors.ParseError{
            switch e {
            case .dataDoesNotStartWithAIIdentifier( _):
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }catch{XCTAssert(false)}
    }
    
    func testEmptyData(){
        let ai = GS1ApplicationIdentifier("30", length: 8, type: .AlphaNumeric, dynamicLength: true)
        do{
            try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: "")
        }catch let e as GS1BarcodeErrors.ParseError{
            switch e {
            case .emptyData:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }catch{XCTAssert(false)}
    }
}

