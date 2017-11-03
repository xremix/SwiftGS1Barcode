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
        testString = "Hello World"
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLength(){
        XCTAssertEqual(testString.count, 11)
    }
    
    func testSubstringFromLength() {
        XCTAssertEqual(testString.substring(0, length: 5), "Hello")
        XCTAssertEqual(testString.substring(1, length: 5), "ello ")
        XCTAssertEqual(testString, "Hello World") // Test Integration
    }
    func testSubstringFromTo() {
        XCTAssertEqual(testString.substring(0, to: 5), "Hello")
        XCTAssertEqual(testString.substring(1, to: 5), "ello")
        XCTAssertEqual(testString, "Hello World") // Test Integration
    }
    func testSubstringFrom() {
        XCTAssertEqual(testString.substring(from: 0), "Hello World")
        XCTAssertEqual(testString.substring(from: 1), "ello World")
        XCTAssertEqual(testString, "Hello World") // Test Integration
    }
    func testSubstringTo() {
        XCTAssertEqual(testString.substring(from: 0), testString)
        XCTAssertEqual(testString.substring(from: 6), "World")
        XCTAssertEqual(testString.substring(from: testString.count), "")
        XCTAssertEqual(testString, "Hello World") // Test Integration
    }

    func testStartsWith(){
        XCTAssert(testString.startsWith("Hello"))
        XCTAssert(!testString.startsWith("World"))
        XCTAssertEqual(testString, "Hello World") // Test Integration
    }
    
    // Tests for Index Of
    func testIndexOf(){
        XCTAssertEqual(testString.index(of: "H"), testString.startIndex)
    }
    func testIndexOfLongString(){
        XCTAssertEqual(testString.index(of: "Hello"), testString.startIndex)
    }
    func testIndexOfWrongString(){
        XCTAssertEqual(testString.index(of: "x"), nil)
    }
    func testIndexOfEndString(){
        XCTAssertEqual(testString.index(of: "World"), testString.index(testString.startIndex, offsetBy: 6))
    }
    func testIndexOfLowerCaseChar(){
        XCTAssertEqual(testString.index(of: "h"), nil)
    }
    func testIndexOfLowerCaseString(){
        XCTAssertEqual(testString.index(of: "hello"), nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            _ = self.testString.substring(0, to: 5)
        }
    }
}
