//
//  GS1BarcodeTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest

@testable import SwiftGS1Barcode
class GS1BarcodeTests: GS1BarcodeParserXCTestCase {
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
        XCTAssert(try barcode.validate())
        
        XCTAssertNotNil(barcode.gtin)
        XCTAssertEqual(barcode.gtin, "00123467021013")
        XCTAssertNil(barcode.lotNumber)
        XCTAssertNotNil(barcode.countOfItems)
        XCTAssertNotNil(barcode.serialNumber)
        
        XCTAssertEqual(barcode.countOfItems, 1)
        XCTAssertEqual(barcode.gtin, "00123467021013")
        XCTAssertEqual(barcode.serialNumber, "10066600")
    }
    
    func testEmptyBarcode(){
        barcode = GS1Barcode(raw: "")
        
        XCTAssertNil(barcode.gtin)
        XCTAssertNil(barcode.lotNumber)
        XCTAssertNil(barcode.expirationDate)
        XCTAssertNil(barcode.serialNumber)
        XCTAssertNil(barcode.countOfItems)
        XCTAssertEqual(barcode.raw, "")
        XCTAssertThrowsError(try !barcode.validate()){ error in
            XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.barcodeEmpty)
        }
    }
    
    func testGTIN() {
        XCTAssertNotNil(barcode.gtin)
        XCTAssertNotEqual(barcode.gtin, "")
        XCTAssertEqual(barcode.gtin, "10123467042022")
    }
    
    func testLot(){
        XCTAssertNotNil(barcode.lotNumber)
        XCTAssertEqual(barcode.lotNumber, "10022247")
    }
    
    func testSerial(){
        XCTAssertNil(barcode.serialNumber)
    }
    
    func testQuantity(){
        XCTAssertNotNil(barcode.countOfItems)
        XCTAssertEqual(barcode.countOfItems, 5)
    }
    
    func testExpirationDate(){
        XCTAssertNotNil(barcode.applicationIdentifiers["expirationDate"]!.rawValue)
        XCTAssertNotNil(barcode.expirationDate)
        XCTAssertEqual(barcode.expirationDate, Date.from(year: 2021, month: 1, day: 31))
    }
    
    func testGETINEmptyBarcode(){
        barcode = GS1Barcode(raw: "")
        XCTAssertNil(barcode.gtin)
    }
    
    func testValidate(){
        XCTAssert(try barcode.validate())
    }
    
    func testValidateNewBarcode(){
        let barcode = GS1Barcode()
        XCTAssertThrowsError(try barcode.validate()){ error in
            XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.barcodeNil)
        }
    }
    func testValidateEmptyBarcode(){
        let barcode = GS1Barcode(raw: "")
        XCTAssertThrowsError(try barcode.validate()){ error in
            XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.barcodeEmpty)
        }
    }
    
    func testPerformanceOfBarcodeParsing(){
        measure {
            for _ in 0...500{
                _ = GS1Barcode(raw: "01101234670420223005\u{1d}172101311010022247")
            }
        }
    }
}
