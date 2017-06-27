//
//  GS1BarcodeNodeTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest
@testable import SwiftGS1Barcode


class GS1BarcodeNodeTests: XCTestCase {
    
    // Main AI Tests
    func testgtinIndicatorDigit(){
        // ("01", length: 1, type: .Int),
        let barcode = GS1Barcode(raw: "01123456789012345")
        XCTAssertNotNil(barcode.gtinIndicatorDigit)
        XCTAssertEqual(barcode.gtinIndicatorDigit, 1)
    }
    func testgtin(){
        // ("01", length: 14, type: .String),
        let barcode = GS1Barcode(raw: "01123456789012345")
        XCTAssertNotNil(barcode.gtin)
        XCTAssertEqual(barcode.gtin, "12345678901234")
    }
    func testlotNumberShort(){
        // ("10", length: 20, type: .String, dynamicLength: true),
        let barcode = GS1Barcode(raw: "101")
        XCTAssertNotNil(barcode.lotNumber)
        XCTAssertEqual(barcode.lotNumber, "1")
    }
    func testlotNumberEmpty(){
        // ("10", length: 20, type: .String, dynamicLength: true),
        let barcode = GS1Barcode(raw: "10\u{1D}678901234567890")
        XCTAssertNotNil(barcode.lotNumber)
        XCTAssertEqual(barcode.lotNumber, "")
    }
    func testlotNumberMiddle(){
        // ("10", length: 20, type: .String, dynamicLength: true),
        let barcode = GS1Barcode(raw: "1012345\u{1D}678901234567890")
        XCTAssertNotNil(barcode.lotNumber)
        XCTAssertEqual(barcode.lotNumber, "12345")
    }
    func testlotNumberFull(){
        // ("10", length: 20, type: .String, dynamicLength: true),
        let barcode = GS1Barcode(raw: "1012345678901234567890")
        XCTAssertNotNil(barcode.lotNumber)
        XCTAssertEqual(barcode.lotNumber, "12345678901234567890")
    }
    func testlotNumberLarge(){
        // ("10", length: 20, type: .String, dynamicLength: true),
        let barcode = GS1Barcode(raw: "1012345678901234567890123")
        XCTAssertNotNil(barcode.lotNumber)
        XCTAssertEqual(barcode.lotNumber, "12345678901234567890")
    }
    func testexpirationDate(){
        // (dateIdentifier: "17"),
        let barcode = GS1Barcode(raw: "17210110")
        XCTAssertNotNil(barcode.expirationDate)
        XCTAssertEqual(barcode.expirationDate,  NSDate.from(year: 2021, month: 1, day: 10))
    }
    func testserialNumber(){
        // ("21", length: 20, type: .String, dynamicLength: true),
        let barcode = GS1Barcode(raw: "21")
        XCTAssertNotNil(barcode.serialNumber)
        XCTAssertEqual(barcode.serialNumber, "")
    }
    func testamount(){
        // ("30", length: 8, type: .Int, dynamicLength: true),
        let barcode = GS1Barcode(raw: "3010")
        XCTAssertNotNil(barcode.amount)
        XCTAssertEqual(barcode.amount, 10)
    }
    func testamountMiddle(){
        // ("30", length: 8, type: .Int, dynamicLength: true),
        let barcode = GS1Barcode(raw: "301010\u{1D}")
        XCTAssertNotNil(barcode.amount)
        XCTAssertEqual(barcode.amount, 1010)
    }
    func testamountFull(){
        // ("30", length: 8, type: .Int, dynamicLength: true),
        let barcode = GS1Barcode(raw: "3012345678")
        XCTAssertNotNil(barcode.amount)
        XCTAssertEqual(barcode.amount, 12345678)
    }
    
    // Advanced AIs
    func testserialShippingContainerCodeNode(){
        // serialShippingContainerCode (00), Length:  18,
        let barcode = GS1Barcode(raw: "002123456789012345678901234567890")
        XCTAssertNotNil(barcode.serialShippingContainerCode)
        XCTAssertEqual(barcode.serialShippingContainerCode, "212345678901234567")
    }
    func testserialShippingContainerCodeNodeExtended(){
        // serialShippingContainerCode (00), Length:  18,
        let barcode = GS1Barcode(raw: "30888888888002123456789012345678901234567890")
        XCTAssertNotNil(barcode.serialShippingContainerCode)
        XCTAssertEqual(barcode.serialShippingContainerCode, "212345678901234567")
    }
    
    
    func testgtinOfContainedTradeItemsNode(){
        // gtinOfContainedTradeItems (02), Length:  14,
        let barcode = GS1Barcode(raw: "022123456789012345678901234567890")
        XCTAssertNotNil(barcode.gtinOfContainedTradeItems)
        XCTAssertEqual(barcode.gtinOfContainedTradeItems, "21234567890123")
    }
    func testgtinOfContainedTradeItemsNodeExtended(){
        // gtinOfContainedTradeItems (02), Length:  14,
        let barcode = GS1Barcode(raw: "30888888888022123456789012345678901234567890")
        XCTAssertNotNil(barcode.gtinOfContainedTradeItems)
        XCTAssertEqual(barcode.gtinOfContainedTradeItems, "21234567890123")
    }
    
    
    func testproductionDateNode(){
        // productionDate dateIdentifier
        let barcode = GS1Barcode(raw: "11210110")
        XCTAssertNotNil(barcode.productionDate)
        XCTAssertEqual(barcode.productionDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    func testproductionDateNodeExtended(){
        // productionDate dateIdentifier
        let barcode = GS1Barcode(raw: "3088888888811210110")
        XCTAssertNotNil(barcode.productionDate)
        XCTAssertEqual(barcode.productionDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testdueDateNode(){
        // dueDate dateIdentifier
        let barcode = GS1Barcode(raw: "12210110")
        XCTAssertNotNil(barcode.dueDate)
        XCTAssertEqual(barcode.dueDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    func testdueDateNodeExtended(){
        // dueDate dateIdentifier
        let barcode = GS1Barcode(raw: "3088888888812210110")
        XCTAssertNotNil(barcode.dueDate)
        XCTAssertEqual(barcode.dueDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testpackagingDateNode(){
        // packagingDate dateIdentifier
        let barcode = GS1Barcode(raw: "13210110")
        XCTAssertNotNil(barcode.packagingDate)
        XCTAssertEqual(barcode.packagingDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    func testpackagingDateNodeExtended(){
        // packagingDate dateIdentifier
        let barcode = GS1Barcode(raw: "3088888888813210110")
        XCTAssertNotNil(barcode.packagingDate)
        XCTAssertEqual(barcode.packagingDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testbestBeforeDateNode(){
        // bestBeforeDate dateIdentifier
        let barcode = GS1Barcode(raw: "15210110")
        XCTAssertNotNil(barcode.bestBeforeDate)
        XCTAssertEqual(barcode.bestBeforeDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    func testbestBeforeDateNodeExtended(){
        // bestBeforeDate dateIdentifier
        let barcode = GS1Barcode(raw: "3088888888815210110")
        XCTAssertNotNil(barcode.bestBeforeDate)
        XCTAssertEqual(barcode.bestBeforeDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testproductVariantNode(){
        // productVariant (20), Length:  2,
        let barcode = GS1Barcode(raw: "2023456789012345678901234567890")
        XCTAssertNotNil(barcode.productVariant)
        XCTAssertEqual(barcode.productVariant, "23")
    }
    func testproductVariantNodeExtended(){
        // productVariant (20), Length:  2,
        let barcode = GS1Barcode(raw: "308888888882023456789012345678901234567890")
        XCTAssertNotNil(barcode.productVariant)
        XCTAssertEqual(barcode.productVariant, "23")
    }
    
    
    func testsecondaryDataFieldsNode(){
        // secondaryDataFields (22), Length: 29, Dynamic Length
        let barcode = GS1Barcode(raw: "22123456789012345678901234567890")
        XCTAssertNotNil(barcode.secondaryDataFields)
        XCTAssertEqual(barcode.secondaryDataFields, "12345678901234567890123456789")
    }
    func testsecondaryDataFieldsNodeExtended(){
        // secondaryDataFields (22), Length: 29, Dynamic Length
        let barcode = GS1Barcode(raw: "3088888888822123456789012345678901234567890")
        XCTAssertNotNil(barcode.secondaryDataFields)
        XCTAssertEqual(barcode.secondaryDataFields, "12345678901234567890123456789")
    }
    
    
    func testnumberOfUnitsContainedNode(){
        // numberOfUnitsContained (37), Length: 8, Dynamic Length
        let barcode = GS1Barcode(raw: "37123456789012345678901234567890")
        XCTAssertNotNil(barcode.numberOfUnitsContained)
        XCTAssertEqual(barcode.numberOfUnitsContained, "12345678")
    }
    func testnumberOfUnitsContainedNodeExtended(){
        // numberOfUnitsContained (37), Length: 8, Dynamic Length
        let barcode = GS1Barcode(raw: "3088888888837123456789012345678901234567890")
        XCTAssertNotNil(barcode.numberOfUnitsContained)
        XCTAssertEqual(barcode.numberOfUnitsContained, "12345678")
    }
}
