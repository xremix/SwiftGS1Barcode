//
//  DateExtension.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import Foundation

extension Date{
    /** Wrapper function to create a date based on a year, month and day */
    static func from(year: Int?, month: Int?, day: Int?)->Date{
        // Setting paramters to component
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        // Create date from components
        let userCalendar = NSCalendar.current
        let someDateTime = userCalendar.date(from: dateComponents)
        // Return Date
        return someDateTime! as Date
    }
}
