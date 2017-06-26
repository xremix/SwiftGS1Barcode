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
    
    // TODO Write test for the Main Nodes as well
    
    
    // Experimental Support
    func testserialShippingContainerCodeNode(){
        //var serialShippingContainerCodeNode = GS1Node("00", length: 18, type: .String)
        let barcode = GS1Barcode(raw: "002123456789012345678901234567890")
        XCTAssertNotNil(barcode.serialShippingContainerCode)
        XCTAssertEqual(barcode.serialShippingContainerCode, "212345678901234567")
    }
    func testserialShippingContainerCodeNodeExtended(){
        //var serialShippingContainerCodeNode = GS1Node("00", length: 18, type: .String)
        let barcode = GS1Barcode(raw: "30888888888002123456789012345678901234567890")
        XCTAssertNotNil(barcode.serialShippingContainerCode)
        XCTAssertEqual(barcode.serialShippingContainerCode, "212345678901234567")
    }
    
    
    func testgtinOfContainedTradeItemsNode(){
        //var gtinOfContainedTradeItemsNode = GS1Node("02", length: 14, type: .String)
        let barcode = GS1Barcode(raw: "022123456789012345678901234567890")
        XCTAssertNotNil(barcode.gtinOfContainedTradeItems)
        XCTAssertEqual(barcode.gtinOfContainedTradeItems, "21234567890123")
    }
    func testgtinOfContainedTradeItemsNodeExtended(){
        //var gtinOfContainedTradeItemsNode = GS1Node("02", length: 14, type: .String)
        let barcode = GS1Barcode(raw: "30888888888022123456789012345678901234567890")
        XCTAssertNotNil(barcode.gtinOfContainedTradeItems)
        XCTAssertEqual(barcode.gtinOfContainedTradeItems, "21234567890123")
    }
    
    
    func testproductionDateNode(){
        //var productionDateNode = GS1Node(dateIdentifier: "11")
        let barcode = GS1Barcode(raw: "11210110")
        XCTAssertNotNil(barcode.productionDate)
        XCTAssertEqual(barcode.productionDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    func testproductionDateNodeExtended(){
        //var productionDateNode = GS1Node(dateIdentifier: "11")
        let barcode = GS1Barcode(raw: "3088888888811210110")
        XCTAssertNotNil(barcode.productionDate)
        XCTAssertEqual(barcode.productionDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testdueDateNode(){
        //var dueDateNode = GS1Node(dateIdentifier: "12")
        let barcode = GS1Barcode(raw: "12210110")
        XCTAssertNotNil(barcode.dueDate)
        XCTAssertEqual(barcode.dueDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    func testdueDateNodeExtended(){
        //var dueDateNode = GS1Node(dateIdentifier: "12")
        let barcode = GS1Barcode(raw: "3088888888812210110")
        XCTAssertNotNil(barcode.dueDate)
        XCTAssertEqual(barcode.dueDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testpackagingDateNode(){
        //var packagingDateNode = GS1Node(dateIdentifier: "13")
        let barcode = GS1Barcode(raw: "13210110")
        XCTAssertNotNil(barcode.packagingDate)
        XCTAssertEqual(barcode.packagingDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    func testpackagingDateNodeExtended(){
        //var packagingDateNode = GS1Node(dateIdentifier: "13")
        let barcode = GS1Barcode(raw: "3088888888813210110")
        XCTAssertNotNil(barcode.packagingDate)
        XCTAssertEqual(barcode.packagingDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testbestBeforeDateNode(){
        //var bestBeforeDateNode = GS1Node(dateIdentifier: "15")
        let barcode = GS1Barcode(raw: "15210110")
        XCTAssertNotNil(barcode.bestBeforeDate)
        XCTAssertEqual(barcode.bestBeforeDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    func testbestBeforeDateNodeExtended(){
        //var bestBeforeDateNode = GS1Node(dateIdentifier: "15")
        let barcode = GS1Barcode(raw: "3088888888815210110")
        XCTAssertNotNil(barcode.bestBeforeDate)
        XCTAssertEqual(barcode.bestBeforeDate, NSDate.from(year: 2021, month: 1, day: 10))
    }
    
    
    func testproductVariantNode(){
        //var productVariantNode = GS1Node("20", length: 2, type: .String)
        let barcode = GS1Barcode(raw: "2023456789012345678901234567890")
        XCTAssertNotNil(barcode.productVariant)
        XCTAssertEqual(barcode.productVariant, "23")
    }
    func testproductVariantNodeExtended(){
        //var productVariantNode = GS1Node("20", length: 2, type: .String)
        let barcode = GS1Barcode(raw: "308888888882023456789012345678901234567890")
        XCTAssertNotNil(barcode.productVariant)
        XCTAssertEqual(barcode.productVariant, "23")
    }
    
    
    func testsecondaryDataFieldsNode(){
        //var secondaryDataFieldsNode = GS1Node("22", length:29, type: .String, dynamicLength:true)
        let barcode = GS1Barcode(raw: "22123456789012345678901234567890")
        XCTAssertNotNil(barcode.secondaryDataFields)
        XCTAssertEqual(barcode.secondaryDataFields, "12345678901234567890123456789")
    }
    func testsecondaryDataFieldsNodeExtended(){
        //var secondaryDataFieldsNode = GS1Node("22", length:29, type: .String, dynamicLength:true)
        let barcode = GS1Barcode(raw: "3088888888822123456789012345678901234567890")
        XCTAssertNotNil(barcode.secondaryDataFields)
        XCTAssertEqual(barcode.secondaryDataFields, "12345678901234567890123456789")
    }
    
    
    func testnumberOfUnitsContainedNode(){
        //var numberOfUnitsContainedNode = GS1Node("37", length:8, type: .String, dynamicLength:true)
        let barcode = GS1Barcode(raw: "37123456789012345678901234567890")
        XCTAssertNotNil(barcode.numberOfUnitsContained)
        XCTAssertEqual(barcode.numberOfUnitsContained, "12345678")
    }
    func testnumberOfUnitsContainedNodeExtended(){
        //var numberOfUnitsContainedNode = GS1Node("37", length:8, type: .String, dynamicLength:true)
        let barcode = GS1Barcode(raw: "3088888888837123456789012345678901234567890")
        XCTAssertNotNil(barcode.numberOfUnitsContained)
        XCTAssertEqual(barcode.numberOfUnitsContained, "12345678")
    }}
