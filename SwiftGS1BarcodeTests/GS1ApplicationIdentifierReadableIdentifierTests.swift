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
    
    func testReadableAI90() {
        // Test AI 90 readable identifier
        let barcode = GS1Barcode(raw: "90CustomTradingPartnerData")
        XCTAssertEqual(barcode.informationMutuallyAgreed, "CustomTradingPartnerData")
        XCTAssertEqual(barcode.filledApplicationIdentifiers.filter{ barcode.applicationIdentifiers[$0.key]?.identifier == "90"}.first!.value.readableIdentifier, "Information Mutually Agreed")
    }

    func testReadableNewCommonIdentifiers(){
        let identifiers = [
            "16": "Sell By Date",
            "311": "Length in Meters",
            "312": "Width in Meters",
            "313": "Height in Meters",
            "314": "Area in Square Meters",
            "315": "Net Volume in Liters",
            "316": "Net Volume in Cubic Meters",
            "320": "Net Weight in Pounds",
            "340": "Gross Weight in Pounds",
            "390": "Amount Payable",
            "391": "Amount Payable and ISO Currency",
            "394": "Percentage Discount",
            "401": "Consignment Number",
            "402": "Shipment Identification Number",
            "403": "Routing Code",
            "410": "Ship To Location GLN",
            "411": "Bill To GLN",
            "412": "Purchase From GLN",
            "413": "Ship For Location GLN",
            "414": "Physical Location GLN",
            "415": "Pay To GLN",
            "416": "Production or Service Location GLN",
            "417": "Party GLN",
            "420": "Ship To Postal Code",
            "421": "Ship To Postal Code with Country",
            "423": "Countries of Initial Processing",
            "424": "Country of Processing",
            "425": "Countries of Disassembly",
            "426": "Country of Full Processing",
            "427": "Origin Subdivision",
            "7003": "Expiration Date and Time",
            "710": "NHRN PZN",
            "711": "NHRN CIP",
            "712": "NHRN CN",
            "713": "NHRN DRN",
            "715": "NHRN NDC",
            "716": "NHRN AIC",
            "717": "NHRN SRN"
        ]

        for (identifier, expectedName) in identifiers {
            let ai = GS1ApplicationIdentifier(identifier, length: 1)
            XCTAssertEqual(ai.readableIdentifierLocalizationKey, expectedName, "Unexpected name for AI \(identifier)")
        }
    }
    
}
