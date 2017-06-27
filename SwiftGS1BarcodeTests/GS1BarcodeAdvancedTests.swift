//
//  GS1BarcodeAdvancedTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 27.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest

@testable import SwiftGS1Barcode

class GS1BarcodeAdvancedTests: XCTestCase {
    
    func testParseLater(){
        let gs1BarcodeText = "01101234670417283002\u{1D}1721103110S123456"
        let barcode = GS1Barcode()
        barcode.raw = gs1BarcodeText
        _ = barcode.parse()
        
        XCTAssert(barcode.validate())
    }
    
    func testAddApplicationIdentifier(){
        let gs1BarcodeText = "90HelloWorld\u{1D}01101234670417283002\u{1D}1721103110S123456"
        let barcode = GS1Barcode()
        barcode.applicationIdentifiers["custom1"] = GS1ApplicationIdentifier("90", length: 30, type: .String, dynamicLength: true)
        barcode.raw = gs1BarcodeText
        _ = barcode.parse()
        print(barcode.applicationIdentifiers["custom1"]!.stringValue!)
        
        XCTAssert(barcode.validate())
        XCTAssertEqual(barcode.applicationIdentifiers["custom1"]!.stringValue, "HelloWorld")

    }
    
    func testCustomApplicationIdentifier(){
     let barcode = GS1Barcode(raw: "90HelloWorld\u{1D}91WorldHello\u{1D}01101234670417283002\u{1D}1721103110S123456", customApplicationIdentifiers: [
        "custom1": GS1ApplicationIdentifier("90", length: 30, type: .String, dynamicLength: true),
        "custom2": GS1ApplicationIdentifier("91", length: 30, type: .String, dynamicLength: true)
        ])
        
        XCTAssert(barcode.validate())
        XCTAssertEqual(barcode.applicationIdentifiers["custom1"]!.stringValue, "HelloWorld")
        XCTAssertEqual(barcode.applicationIdentifiers["custom2"]!.stringValue, "WorldHello")
    }
    
}
