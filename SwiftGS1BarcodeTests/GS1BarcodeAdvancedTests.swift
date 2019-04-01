//
//  GS1BarcodeAdvancedTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 27.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest


@testable import SwiftGS1Barcode

class GS1BarcodeAdvancedTests: GS1BarcodeParserXCTestCase {
    
    // Parse Tests
    func testParseLater(){
        let gs1BarcodeText = "01101234670417283002\u{1D}1721103110S123456"
        let barcode = GS1Barcode()
        barcode.raw = gs1BarcodeText
        do{
            _ = try barcode.parse()
        }catch{
            XCTFail("Catch")
        }
        XCTAssert(barcode.validate())
    }
    
    func testParseLaterWithNilBarcode(){
        let barcode = GS1Barcode()
        do{
            _ = try barcode.parse()
        }catch{
            XCTFail("Catch")
        }
        XCTAssertFalse(barcode.validate())
    }
    
    func testParseLaterWithBarcodeButThrowsError(){
        let barcode = GS1Barcode(raw: "abc")
        do{
            _ = try barcode.parse()
            XCTFail("Catch")
        }catch let error as GS1BarcodeErrors.ParseError{
            XCTAssertEqual(error.localizedDescription, GS1BarcodeErrors.ParseError.didNotFoundApplicationIdentifier.localizedDescription)
        }catch{
            XCTFail("Catch")
        }
        XCTAssertFalse(barcode.validate())
    }
    
    // Tests Try Parse
    func testTryParseLaterWithNilBarcode(){
        let barcode = GS1Barcode()
        XCTAssert(barcode.tryParse())
        XCTAssertFalse(barcode.validate())
    }
    
    func testTryParseLaterWithBarcode(){
        let barcode = GS1Barcode(raw: "01101234670417283002\u{1D}1721103110S123456")
        XCTAssert(barcode.tryParse())
        XCTAssert(barcode.validate())
    }
    
    func testTryParseLaterWithBarcodeButThrowsError(){
        let barcode = GS1Barcode(raw: "abc")
        XCTAssertFalse(barcode.tryParse())
        XCTAssertFalse(barcode.validate())
    }
    
    // Tests Add Application Identifier
    func testAddApplicationIdentifier(){
        let gs1BarcodeText = "90HelloWorld\u{1D}01101234670417283002\u{1D}1721103110S123456"
        let barcode = GS1Barcode()
        barcode.applicationIdentifiers["custom1"] = GS1ApplicationIdentifier("90", length: 30, type: .AlphaNumeric, dynamicLength: true)
        barcode.raw = gs1BarcodeText
        do{
            _ = try barcode.parse()
        }catch{
            XCTFail("Catch")
        }
        print(barcode.applicationIdentifiers["custom1"]!.stringValue!)
        
        XCTAssert(barcode.validate())
        XCTAssertEqual(barcode.applicationIdentifiers["custom1"]!.stringValue, "HelloWorld")
        
    }
    
    func testCustomApplicationIdentifier(){
        let barcode = GS1Barcode(raw: "90HelloWorld\u{1D}91WorldHello\u{1D}01101234670417283002\u{1D}1721103110S123456", customApplicationIdentifiers: [
            "custom1": GS1ApplicationIdentifier("90", length: 30, type: .AlphaNumeric, dynamicLength: true),
            "custom2": GS1ApplicationIdentifier("91", length: 30, type: .AlphaNumeric, dynamicLength: true)
            ])
        XCTAssertNotNil(barcode.applicationIdentifiers["custom1"])
        XCTAssertNotNil(barcode.applicationIdentifiers["custom2"])
        
        
        XCTAssert(barcode.validate())
        XCTAssertEqual(barcode.applicationIdentifiers["custom1"]!.stringValue, "HelloWorld")
        XCTAssertEqual(barcode.applicationIdentifiers["custom2"]!.stringValue, "WorldHello")
    }    
}
