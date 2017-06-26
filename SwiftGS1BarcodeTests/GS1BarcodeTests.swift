//
//  GS1BarcodeTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest
@testable import SwiftGS1Barcode

class BarcodeTests: XCTestCase {
    var barcode: GS1Barcode!
    override func setUp() {
        super.setUp()
        // Should parse 01, 30, 17, 10, is a LOT, no Serial
        let gs1Barcode = "01101234670420223005\u{1d}172101311010022247"
        barcode = GS1Barcode(raw: gs1Barcode)
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
    
    
    
    func testGTIN() {
        XCTAssertNotNil(barcode.gtin)
        XCTAssertNotEqual(barcode.gtin, "")
        XCTAssertEqual(barcode.gtin, "10123467042022")
    }
    
    //    func testGETINIndicator(){
    //        XCTAssertNotNil(barcode.GETINIndicatorDigit)
    //        XCTAssertEqual(barcode.GETINIndicatorDigit, 1)
    //    }
    
    func testLot(){
        //        XCTAssertTrue(barcode.isLot!)
        XCTAssertNotNil(barcode.lotNumber)
        XCTAssertEqual(barcode.lotNumber, "10022247")
    }
    func testSerial(){
        XCTAssertNil(barcode.serialNumber)
    }
    
    func testQuantity(){
        XCTAssertNotNil(barcode.amount)
        XCTAssertEqual(barcode.amount, 5)
        //        XCTAssertTrue(barcode.hasQuantityTag!)
    }
    
    func testExpirationDate(){
        XCTAssertNotNil(barcode.nodes.expirationDateNode.rawValue)
        XCTAssertNotNil(barcode.expirationDate)
        XCTAssertEqual(barcode.expirationDate, NSDate.from(year: 2021, month: 1, day: 31))
    }
    
    //    func testValidation(){
    //        XCTAssertTrue(barcode.validateGS1QuantityRule())
    //    }
}
