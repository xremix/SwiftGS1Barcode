//
//  DateExtension.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

extension NSDate{
    static func from(year: Int?, month: Int?, day: Int?)->NSDate{
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        // Create date from components
        let userCalendar = NSCalendar.current
        let someDateTime = userCalendar.date(from: dateComponents)
        return someDateTime! as NSDate
        
    }
}
