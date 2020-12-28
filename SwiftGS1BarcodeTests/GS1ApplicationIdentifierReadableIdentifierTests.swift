//
//  GS1ApplicationIdentifierReadableIdentifierTests.swift
//  SwiftGS1BarcodeTests
//
//  Created by Toni Hoffmann on 28.12.20.
//  Copyright © 2020 Toni Hoffmann. All rights reserved.
//


import XCTest
@testable import SwiftGS1Barcode

class GS1ApplicationIdentifierReadableIdentifierTests: XCTestCase {
    func testReadable(){
        // 01 3101 10
        // 01 97350053850012 310 1 000050 10 897A174
        let barcode = GS1Barcode(raw: "0197350053850012310100005010897A174")
        XCTAssertEqual(barcode.gtin, "97350053850012")
        XCTAssertEqual(barcode.lotNumber, "897A174")
        XCTAssert(try barcode.validate())

        XCTAssertEqual(barcode.filledApplicationIdentifiers.filter{ barcode.applicationIdentifiers[$0.key]?.identifier == "01"}.first!.value.readableIdentifier, "GTIN")
        XCTAssertEqual(barcode.filledApplicationIdentifiers.filter{ barcode.applicationIdentifiers[$0.key]?.identifier == "10"}.first!.value.readableIdentifier, "Lot Number")
        XCTAssertEqual(barcode.filledApplicationIdentifiers.filter{ barcode.applicationIdentifiers[$0.key]?.identifier == "310"}.first!.value.readableIdentifier, "Product Weight in KG")
    }
    
}
