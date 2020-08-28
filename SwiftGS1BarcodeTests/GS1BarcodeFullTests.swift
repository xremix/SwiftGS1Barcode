//
//  GS1BarcodeSampleTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 11.07.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest
@testable import SwiftGS1Barcode

class GS1BarcodeFullTests: XCTestCase {

    func testFullSample1(){
        // 01 17 10 21
        let barcode = GS1Barcode(raw: "01006141410073491714123110A1234B\u{1D}211234")
        XCTAssertEqual(barcode.gtin, "00614141007349")
        XCTAssertEqual(barcode.expirationDate, Date.from(year: 2014, month: 12, day: 31))
        XCTAssertEqual(barcode.lotNumber, "A1234B")
        XCTAssertEqual(barcode.serialNumber, "1234")

    }
    func testFullSample2(){
        // 01 11 10 21
        let barcode = GS1Barcode(raw: "0112345678900101\u{1D}110809061002\u{1D}21027-32")
        XCTAssertEqual(barcode.gtin, "12345678900101")
        XCTAssertEqual(barcode.productionDate, Date.from(year: 2008, month: 09, day: 06))
        XCTAssertEqual(barcode.lotNumber, "02")
        XCTAssertEqual(barcode.serialNumber, "027-32")
    
        XCTAssert(try barcode.validate())

    }
    func testFullSample3(){
        // 01 3101 10
        // 01 97350053850012 310 1 000050 10 897A174
        let barcode = GS1Barcode(raw: "0197350053850012310100005010897A174")
        XCTAssertEqual(barcode.gtin, "97350053850012")
        XCTAssertEqual(barcode.lotNumber, "897A174")
        XCTAssert(try barcode.validate())
    }

    func testFullSample4() {
        // 01 17 10 30
        //    01 00123456789123 17 230331 10 123456789 30 01
        let gs1Barcode = "01001234567891231723033110123456789\u{1D}3001"
        let barcode = GS1Barcode(raw: gs1Barcode)
        XCTAssertNotNil(barcode.gtin) // 01
        XCTAssertNotNil(barcode.countOfItems) // 30
        XCTAssertNotNil(barcode.expirationDate) // 17
        XCTAssertNotNil(barcode.lotNumber) // 10

        XCTAssertEqual(barcode.gtin, "00123456789123")
        XCTAssertEqual(barcode.expirationDate, Date.from(year: 2023, month: 3, day: 31))
        XCTAssertEqual(barcode.lotNumber, "123456789")
        XCTAssertEqual(barcode.countOfItems, 1)
    }
}
