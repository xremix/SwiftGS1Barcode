//
//  GS1BarcodeApplicationIdentifierTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest

@testable import SwiftGS1Barcode
class GS1BarcodeApplicationIdentifierTests: GS1BarcodeParserXCTestCase {
    
    // Main AI Tests
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
        XCTAssertEqual(barcode.expirationDate,  Date.from(year: 2021, month: 1, day: 10))
    }
    func testserialNumber(){
        // ("21", length: 20, type: .String, dynamicLength: true),
        let barcode = GS1Barcode(raw: "21")
        XCTAssertNotNil(barcode.serialNumber)
        XCTAssertEqual(barcode.serialNumber, "")
    }
    func testcountOfItems(){
        // ("30", length: 8, type: .Int, dynamicLength: true),
        let barcode = GS1Barcode(raw: "3010")
        XCTAssertNotNil(barcode.countOfItems)
        XCTAssertEqual(barcode.countOfItems, 10)
    }
    func testcountOfItemsMiddle(){
        // ("30", length: 8, type: .Int, dynamicLength: true),
        let barcode = GS1Barcode(raw: "301010\u{1D}")
        XCTAssertNotNil(barcode.countOfItems)
        XCTAssertEqual(barcode.countOfItems, 1010)
    }
    func testcountOfItemsFull(){
        // ("30", length: 8, type: .Int, dynamicLength: true),
        let barcode = GS1Barcode(raw: "3012345678")
        XCTAssertNotNil(barcode.countOfItems)
        XCTAssertEqual(barcode.countOfItems, 12345678)
    }
    
    // Advanced AIs
    func testserialShippingContainerCodeAI(){
        // serialShippingContainerCode (00), Length:  18,
        let barcode = GS1Barcode(raw: "002123456789012345678901234567890")
        XCTAssertNotNil(barcode.serialShippingContainerCode)
        XCTAssertEqual(barcode.serialShippingContainerCode, "212345678901234567")
    }
    func testserialShippingContainerCodeAIExtended(){
        // serialShippingContainerCode (00), Length:  18,
        let barcode = GS1Barcode(raw: "30888888888002123456789012345678901234567890")
        XCTAssertNotNil(barcode.serialShippingContainerCode)
        XCTAssertEqual(barcode.serialShippingContainerCode, "212345678901234567")
    }
    
    
    func testgtinOfContainedTradeItemsAI(){
        // gtinOfContainedTradeItems (02), Length:  14,
        let barcode = GS1Barcode(raw: "022123456789012345678901234567890")
        XCTAssertNotNil(barcode.gtinOfContainedTradeItems)
        XCTAssertEqual(barcode.gtinOfContainedTradeItems, "21234567890123")
    }
    func testgtinOfContainedTradeItemsAIExtended(){
        // gtinOfContainedTradeItems (02), Length:  14,
        let barcode = GS1Barcode(raw: "30888888888022123456789012345678901234567890")
        XCTAssertNotNil(barcode.gtinOfContainedTradeItems)
        XCTAssertEqual(barcode.gtinOfContainedTradeItems, "21234567890123")
    }
    
    
    func testproductionDateAI(){
        // productionDate dateIdentifier
        let barcode = GS1Barcode(raw: "11210110")
        XCTAssertNotNil(barcode.productionDate)
        XCTAssertEqual(barcode.productionDate, Date.from(year: 2021, month: 1, day: 10))
    }
    func testproductionDateAIExtended(){
        // productionDate dateIdentifier
        let barcode = GS1Barcode(raw: "3088888888811210110")
        XCTAssertNotNil(barcode.productionDate)
        XCTAssertEqual(barcode.productionDate, Date.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testdueDateAI(){
        // dueDate dateIdentifier
        let barcode = GS1Barcode(raw: "12210110")
        XCTAssertNotNil(barcode.dueDate)
        XCTAssertEqual(barcode.dueDate, Date.from(year: 2021, month: 1, day: 10))
    }
    func testdueDateAIExtended(){
        // dueDate dateIdentifier
        let barcode = GS1Barcode(raw: "3088888888812210110")
        XCTAssertNotNil(barcode.dueDate)
        XCTAssertEqual(barcode.dueDate, Date.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testpackagingDateAI(){
        // packagingDate dateIdentifier
        let barcode = GS1Barcode(raw: "13210110")
        XCTAssertNotNil(barcode.packagingDate)
        XCTAssertEqual(barcode.packagingDate, Date.from(year: 2021, month: 1, day: 10))
    }
    func testpackagingDateAIExtended(){
        // packagingDate dateIdentifier
        let barcode = GS1Barcode(raw: "3088888888813210110")
        XCTAssertNotNil(barcode.packagingDate)
        XCTAssertEqual(barcode.packagingDate, Date.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testbestBeforeDateAI(){
        // bestBeforeDate dateIdentifier
        let barcode = GS1Barcode(raw: "15210110")
        XCTAssertNotNil(barcode.bestBeforeDate)
        XCTAssertEqual(barcode.bestBeforeDate, Date.from(year: 2021, month: 1, day: 10))
    }
    func testbestBeforeDateAIExtended(){
        // bestBeforeDate dateIdentifier
        let barcode = GS1Barcode(raw: "3088888888815210110")
        XCTAssertNotNil(barcode.bestBeforeDate)
        XCTAssertEqual(barcode.bestBeforeDate, Date.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testproductVariantAI(){
        // productVariant (20), Length:  2,
        let barcode = GS1Barcode(raw: "2023456789012345678901234567890")
        XCTAssertNotNil(barcode.productVariant)
        XCTAssertEqual(barcode.productVariant, "23")
    }
    func testproductVariantAIExtended(){
        // productVariant (20), Length:  2,
        let barcode = GS1Barcode(raw: "308888888882023456789012345678901234567890")
        XCTAssertNotNil(barcode.productVariant)
        XCTAssertEqual(barcode.productVariant, "23")
    }
    
    
    func testsecondaryDataFieldsAI(){
        // secondaryDataFields (22), Length: 29, Dynamic Length
        let barcode = GS1Barcode(raw: "22123456789012345678901234567890")
        XCTAssertNotNil(barcode.secondaryDataFields)
        XCTAssertEqual(barcode.secondaryDataFields, "12345678901234567890123456789")
    }
    func testsecondaryDataFieldsAIExtended(){
        // secondaryDataFields (22), Length: 29, Dynamic Length
        let barcode = GS1Barcode(raw: "3088888888822123456789012345678901234567890")
        XCTAssertNotNil(barcode.secondaryDataFields)
        XCTAssertEqual(barcode.secondaryDataFields, "12345678901234567890123456789")
    }
    
    
    func testnumberOfUnitsContainedAI(){
        // numberOfUnitsContained (37), Length: 8, Dynamic Length
        let barcode = GS1Barcode(raw: "37123456789012345678901234567890")
        XCTAssertNotNil(barcode.numberOfUnitsContained)
        XCTAssertEqual(barcode.numberOfUnitsContained, "12345678")
    }
    func testnumberOfUnitsContainedAIExtended(){
        // numberOfUnitsContained (37), Length: 8, Dynamic Length
        let barcode = GS1Barcode(raw: "3088888888837123456789012345678901234567890")
        XCTAssertNotNil(barcode.numberOfUnitsContained)
        XCTAssertEqual(barcode.numberOfUnitsContained, "12345678")
    }
    
    func testLotNumberN(){
        // numberOfUnitsContained (37), Length: 8, Dynamic Length
        let barcode = GS1Barcode(raw: "23n12345678901234567890")
        XCTAssertNotNil(barcode.applicationIdentifiers["lotNumberN"]?.stringValue)
        XCTAssertEqual(barcode.applicationIdentifiers["lotNumberN"]?.stringValue, "1234567890123456789")
    }
    
    
}
