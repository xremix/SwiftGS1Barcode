//
//  BarcodeParser.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

public class GS1BarcodeParser: NSObject {
    public enum ParseError: Error {
        case dataDoesNotStartWithAIIdentifier
    }
    
    /**
     Set to true to prints debug information to console
     */
    static var printDebugOutput = false
    /**
     Takes a data String,removed the GS1 Value and AI and returns the modified String
     - returns:
     Modified String without the AI and it's value
     */
    static func reduce(data: String?, by ai: GS1ApplicationIdentifier)->String?{
        if data == nil{
            return data
        }

        var length = (ai.rawValue?.count ?? 0) + (ai.identifier.count)
        if ai.dynamicLength && data!.count > length{
            length += 1
        }
        return data!.substring(from: length)
    }
    /**
     Parses the data, based on the ai's  identifier
     */
    static func parseGS1ApplicationIdentifier(_ ai: GS1ApplicationIdentifier, data: String) throws{
        if printDebugOutput{
            print("Parsing application identifier with identifier \(ai.identifier) of type \(String(describing: ai.type?.description))")
        }
        
        if !data.startsWith(ai.identifier){
            throw ParseError.dataDoesNotStartWithAIIdentifier
        }
        
        // Get Pure Data by removing the identifier
        var aiData = data
        aiData = aiData.substring(from: ai.identifier.count)
        
        
        // Cut data by Group Seperator, if dynamic length item and has a GS.
        if ai.dynamicLength && aiData.index(of: "\u{1D}") != nil {
            let toi = aiData.index(of: "\u{1D}")
            let to = aiData.distance(from: aiData.startIndex, to: toi ?? aiData.startIndex)
            
            aiData = aiData.substring(to: to)
        }
        // Cut to Max Length, if aiData still longer after the previous cutting.
        if aiData.count > ai.maxLength{
            aiData = aiData.substring(to: ai.maxLength)
        }
        
        // Set original value to the value of the content
        ai.rawValue = aiData
        
        // Parsing aiData, based on the ai Type
        if ai.type == GS1ApplicationIdentifierType.Date{ // Check if type is a date type and if there are 6 more chars available
            // Parsing the next 6 chars to a Date
            if aiData.count >= 6{
                ai.dateValue = Date.from(
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
    }
}
