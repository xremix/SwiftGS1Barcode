//
//  StringTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest
@testable import SwiftGS1Barcode

class StringTests: XCTestCase {
    var testString: String = ""
    override func setUp() {
        super.setUp()
        testString = "Hallo Welt"
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLength(){
        XCTAssertEqual(testString.length, 10)
    }
    
    func testSubstringFromLength() {
        XCTAssertEqual(testString.substring(0, length: 5), "Hallo")
        XCTAssertEqual(testString.substring(1, length: 5), "allo ")
    }
    func testSubstringFromTo() {
        XCTAssertEqual(testString.substring(0, to: 5), "Hallo")
        XCTAssertEqual(testString.substring(1, to: 5), "allo")
    }
    func testSubstringFrom() {
        XCTAssertEqual(testString.substring(from: 0), "Hallo Welt")
        XCTAssertEqual(testString.substring(from: 1), "allo Welt")
    }
    func testSubstringTo() {
        XCTAssertEqual(testString.substring(from: 0), testString)
        XCTAssertEqual(testString.substring(from: 6), "Welt")
        XCTAssertEqual(testString.substring(from: testString.length), "")
    }
    func testSubstringToString() {
        XCTAssertEqual(testString.substring(to: "Welt"), "Hallo ")
        XCTAssertEqual(testString.substring(to: "Hallo Welt"), "")
    }
    func testStartsWith(){
        XCTAssert(testString.startsWith("Hallo"))
        XCTAssert(!testString.startsWith("Welt"))
    }
    
    func testIndexOfOptions(){
        //        testString.index(of: "Welt", options: co)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            _ = self.testString.substring(0, to: 5)
        }
    }
}
