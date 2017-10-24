//
//  GS1BarcodeSampleTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 11.07.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest
@testable import SwiftGS1Barcode

class GS1BarcodeSampleTests: XCTestCase {
    
    func testSample1(){
        // 01 17 10 21
        let barcode = GS1Barcode(raw: "01006141410073491714123110A1234B\u{1D}211234")
        XCTAssertEqual(barcode.gtin, "00614141007349")
        XCTAssertEqual(barcode.expirationDate, NSDate.from(year: 2014, month: 12, day: 31))
        XCTAssertEqual(barcode.lotNumber, "A1234B")
        XCTAssertEqual(barcode.serialNumber, "1234")
        
    }
    func testSample2(){
        // 01 11 10 21
        let barcode = GS1Barcode(raw: "0112345678900101\u{1D}110809061002\u{1D}21027-32")
        XCTAssertEqual(barcode.gtin, "12345678900101")
        XCTAssertEqual(barcode.productionDate, NSDate.from(year: 2008, month: 09, day: 06))
        XCTAssertEqual(barcode.lotNumber, "02")
        XCTAssertEqual(barcode.serialNumber, "027-32")
        XCTAssert(barcode.validate())
        
    }
    func testSample3(){
        // 01 3101 10
        let barcode = GS1Barcode(raw: "0197350053850012310100005010897A174")
        XCTAssertEqual(barcode.gtin, "97350053850012")
        XCTAssertEqual(barcode.lotNumber, "897A174")
        XCTAssert(barcode.validate())
        
    }
    
}
