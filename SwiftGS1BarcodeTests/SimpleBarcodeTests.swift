//
//  SimpleBarcodeTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest
@testable import SwiftGS1Barcode

class SimpleBarcodeTests: XCTestCase {
    var simpleBarcode: SimpleBarcode?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRaw(){
        simpleBarcode = SimpleBarcode(raw: "0120012345678909")
        XCTAssertEqual(simpleBarcode!.raw, "0120012345678909")
    }
    
    func testEmptyBarcode(){
        simpleBarcode = SimpleBarcode(raw: "")
        XCTAssertEqual(simpleBarcode!.raw, "")
        XCTAssert(!simpleBarcode!.validate())
    }
    
    func testValidate() {
        simpleBarcode = SimpleBarcode(raw: "0120012345678909")
        XCTAssert(simpleBarcode!.validate())
        simpleBarcode?.raw = ""
        XCTAssert(!simpleBarcode!.validate())
        simpleBarcode?.raw = nil
        XCTAssert(!simpleBarcode!.validate())
    }
}
