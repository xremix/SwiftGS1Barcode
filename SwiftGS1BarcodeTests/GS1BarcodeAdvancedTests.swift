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
        XCTAssert(try barcode.validate())
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
        XCTAssertThrowsError(try barcode.validate()){ error in
            XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.unallowedCharacter)
        }
    }
    
    // Tests Try Parse
    func testTryParseLaterWithNilBarcode(){
        let barcode = GS1Barcode()
        XCTAssert(barcode.tryParse())
         XCTAssertThrowsError(try barcode.validate()){ error in
                   XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.barcodeNil)
               }
    }
    
    func testTryParseLaterWithBarcode(){
        let barcode = GS1Barcode(raw: "01101234670417283002\u{1D}1721103110S123456")
        XCTAssert(barcode.tryParse())
        XCTAssert(try barcode.validate())
    }
    
    func testTryParseLaterWithBarcodeButThrowsError(){
        let barcode = GS1Barcode(raw: "abc")
        XCTAssertFalse(barcode.tryParse())
         XCTAssertThrowsError(try barcode.validate()){ error in
                   XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.unallowedCharacter)
               }
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
        
        XCTAssert(try barcode.validate())
        XCTAssertEqual(barcode.applicationIdentifiers["custom1"]!.stringValue, "HelloWorld")
        
    }
    
    func testCustomApplicationIdentifier(){
        let barcode = GS1Barcode(raw: "90HelloWorld\u{1D}91WorldHello\u{1D}01101234670417283002\u{1D}1721103110S123456", customApplicationIdentifiers: [
            "custom1": GS1ApplicationIdentifier("90", length: 30, type: .AlphaNumeric, dynamicLength: true),
            "custom2": GS1ApplicationIdentifier("91", length: 30, type: .AlphaNumeric, dynamicLength: true)
            ])
        XCTAssertNotNil(barcode.applicationIdentifiers["custom1"])
        XCTAssertNotNil(barcode.applicationIdentifiers["custom2"])
        
        
        XCTAssert(try barcode.validate())
        XCTAssertEqual(barcode.applicationIdentifiers["custom1"]!.stringValue, "HelloWorld")
        XCTAssertEqual(barcode.applicationIdentifiers["custom2"]!.stringValue, "WorldHello")
    }    
    
    func testUserExample(){
        // (01)03608419025705(21)000000961845
        let barcode = GS1Barcode(raw: "010360841902570521000000961845")
        
        XCTAssert(try barcode.validate())
        XCTAssertEqual(barcode.gtin, "03608419025705")
        XCTAssertEqual(barcode.serialNumber, "000000961845")
    }
    
    func testValidationWithDigits(){
        let barcode = GS1Barcode(raw: "010360841902570521000000961845")
        XCTAssert(try barcode.validate())
    }
    
    func testValidationWithDigitsWords(){
        let barcode = GS1Barcode(raw: "011aB234670417283002")
        XCTAssert(try barcode.validate())
    }
    
    func testValidationWithSeperators(){
        let barcode = GS1Barcode(raw: "01101234670417283002\u{1D}1721103110S123456")
        XCTAssert(try barcode.validate())
    }
    
    func testValidationWithDash(){
        let barcode = GS1Barcode(raw: "0112345678900101\u{1D}110809061002\u{1D}21027-32")
        XCTAssert(try barcode.validate())
    }
    
    func testValidationFailCharAtBegin(){
        let barcode = GS1Barcode(raw: "a0112345678900101\u{1D}110809061002\u{1D}21027-32")
        XCTAssertThrowsError(try barcode.validate()){ error in
            XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.unallowedCharacter)
        }
    }
    
    func testValidationFailNil(){
        var barcode = GS1Barcode()
        XCTAssertThrowsError(try barcode.validate()){ error in
            XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.barcodeNil)
        }
        
        // Second test
        barcode = GS1Barcode(raw: "")
        barcode.raw = nil
        XCTAssertThrowsError(try barcode.validate()){ error in
            XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.barcodeNil)
        }
    }
    
    func testValidationFailEmpty(){
        let barcode = GS1Barcode(raw: "")
        XCTAssertThrowsError(try barcode.validate()){ error in
            XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.barcodeEmpty)
        }
    }
    
    func testValidationFailUnallowedCharacter(){
        let barcode = GS1Barcode(raw: "01$2345678900101\u{1D}110809061002\u{1D}21027-32")
        XCTAssertThrowsError(try barcode.validate()){ error in
            XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.unallowedCharacter)
        }
    }
    
    func testValidationWithParseUnsuccessful(){
        let barcode = GS1Barcode(raw: "12345678903495876548390958748930598")
        XCTAssertThrowsError(try barcode.validate()){ error in
            XCTAssertEqual(error as! GS1BarcodeErrors.ValidationError, GS1BarcodeErrors.ValidationError.parseUnsucessfull)
        }
    }
}
