//
//  DateTests.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import XCTest
@testable import SwiftGS1Barcode

class DateTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    // Date Tests
    func testFrom() {
        let date = Date.from(year: 2017, month: 12, day: 24)
        
        XCTAssert(NSCalendar.current.component(.year, from: date as Date) == 2017)
        XCTAssert(NSCalendar.current.component(.month, from: date as Date) == 12)
        XCTAssert(NSCalendar.current.component(.day, from: date as Date) == 24)
    }
}
