//
//  GS1BarcodeTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest
@testable import SwiftGS1Barcode

class GS1BarcodeTests: XCTestCase {
    var barcode: GS1Barcode!
    override func setUp() {
        super.setUp()
        // Should parse 01, 30, 17, 10, is a LOT, no Serial
        barcode = GS1Barcode(raw: "01101234670420223005\u{1d}172101311010022247")
    }
    
    override func tearDown() {
        super.tearDown()
        barcode = nil
    }
    
    func testExample() {
        let barcode = GS1Barcode(raw: "01001234670210133001\u{1D}2110066600")
        XCTAssert(barcode.validate())
        
        XCTAssertNotNil(barcode.gtin)
        XCTAssertEqual(barcode.gtin, "00123467021013")
        XCTAssertNil(barcode.lotNumber)
        XCTAssertNotNil(barcode.amount)
        XCTAssertNotNil(barcode.serialNumber)
        
        XCTAssertEqual(barcode.amount, 1)
        XCTAssertEqual(barcode.gtin, "00123467021013")
        XCTAssertEqual(barcode.serialNumber, "10066600")
    }
    
    func testEmptyBarcode(){
        barcode = GS1Barcode(raw: "")
        
        XCTAssertNil(barcode.gtin)
        XCTAssertNil(barcode.lotNumber)
        XCTAssertNil(barcode.expirationDate)
        XCTAssertNil(barcode.serialNumber)
        XCTAssertNil(barcode.amount)
        XCTAssertNil(barcode.gtinIndicatorDigit)
        XCTAssertEqual(barcode.raw, "")
        XCTAssert(!barcode.validate())
    }
    
    func testGTIN() {
        XCTAssertNotNil(barcode.gtin)
        XCTAssertNotEqual(barcode.gtin, "")
        XCTAssertEqual(barcode.gtin, "10123467042022")
    }
    
    func testGETINIndicator(){
        XCTAssertNotNil(barcode.gtinIndicatorDigit)
        XCTAssertEqual(barcode.gtinIndicatorDigit, 1)
    }
    
    func testLot(){
        XCTAssertNotNil(barcode.lotNumber)
        XCTAssertEqual(barcode.lotNumber, "10022247")
    }
    
    func testSerial(){
        XCTAssertNil(barcode.serialNumber)
    }
    
    func testQuantity(){
        XCTAssertNotNil(barcode.amount)
        XCTAssertEqual(barcode.amount, 5)
    }
    
    func testExpirationDate(){
        XCTAssertNotNil(barcode.applicationIdentifiers["expirationDate"]!.originalValue)
        XCTAssertNotNil(barcode.expirationDate)
        XCTAssertEqual(barcode.expirationDate, NSDate.from(year: 2021, month: 1, day: 31))
    }
    
    func testGETINIndicatorDifferentValue(){
        barcode = GS1Barcode(raw: "01201234670420223005\u{1d}172101311010022247")
        XCTAssertNotNil(barcode.gtinIndicatorDigit)
        XCTAssertEqual(barcode.gtinIndicatorDigit, 2)
    }
    func testGETINIndicatorEmpty(){
        barcode = GS1Barcode(raw: "01001234670420223005\u{1d}172101311010022247")
        XCTAssertNotNil(barcode.gtinIndicatorDigit)
        XCTAssertEqual(barcode.gtinIndicatorDigit, 0)
    }
    func testGETINIndicatorEmptyBarcode(){
        barcode = GS1Barcode(raw: "")
        XCTAssertNil(barcode.gtinIndicatorDigit)
    }
    
    func testValidate(){
        XCTAssert(barcode.validate())
    }
    
    func testValidateNewBarcode(){
        let b = GS1Barcode()
        XCTAssertFalse(b.validate())
    }
    func testValidateEmptyBarcode(){
        let b = GS1Barcode(raw: "")
        XCTAssertFalse(b.validate())
    }
    
    func testPerformance(){
        
        measure {
            for _ in 0...500{
                _ = GS1Barcode(raw: "01101234670420223005\u{1d}172101311010022247")
            }
        }
    }
}
