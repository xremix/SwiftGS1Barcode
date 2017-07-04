//
//  BarcodeParser.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

public class GS1BarcodeParser: NSObject {
    static var debugOutput = false
    static func reduce(data: String?, by ai: GS1ApplicationIdentifier)->String?{
        if data == nil{
            return data
        }
        
        var length = (ai.rawValue?.length ?? 0) + (ai.identifier.length)
        if ai.dynamicLength && data!.length > length{
            length += 1
        }
        return data!.substring(from: length)
    }
    static func parseGS1ApplicationIdentifier(_ ai: GS1ApplicationIdentifier, data: String)->GS1ApplicationIdentifier{
        if debugOutput{
            print("Parsing application identifier with identifier \(ai.identifier) of type \(String(describing: ai.type?.description))")
        }
        
        if !data.startsWith(ai.identifier){
            if debugOutput{
                print("Passed invalid Application Identifier with wrong identifier")
            }
            return ai
        }
        
        // Get Pure Data by removing the identifier
        var aiData = data
        aiData = aiData.substring(from: ai.identifier.length)
        
        
        // Cut data by Group Seperator, if dynamic length item and has a GS.
        if ai.dynamicLength && aiData.index(of: "\u{1D}") != nil {
            let toi = aiData.index(of: "\u{1D}")
            let to = aiData.distance(from: aiData.startIndex, to: toi ?? aiData.startIndex)
            
            aiData = aiData.substring(to: to)
        }
        // Cut to Max Length, if aiData still longer after the previous cutting.
        if aiData.length > ai.maxLength{
            aiData = aiData.substring(to: ai.maxLength)
        }
        
        // Set original value to the value of the content
        ai.rawValue = aiData
        
        // Parsing aiData, based on the ai Type
        if ai.type == GS1ApplicationIdentifierType.Date{ // Check if type is a date type and if there are 6 more chars available
            // Parsing the next 6 chars to a NSDate
            // TODO consider supporting multiple lengths here?!
            if aiData.length >= 6{
                ai.dateValue = NSDate.from(
                    year: Int("20" + aiData.substring(to: 2)),
                    month: Int(aiData.substring(2, length: 2)),
                    day: Int(aiData.substring(4, length: 2))
                )
            }
        }else if(ai.type == GS1ApplicationIdentifierType.Numeric){ // Parsing value to Integer
            ai.intValue = Int(aiData)
        }else{ // Taking the data left and just putting it into the string value. Expecting that type is not Date and no Numeric. If it is date but not enough chars there, it would still put the content into the string
            ai.stringValue = aiData
        }
        return ai
    }
}
