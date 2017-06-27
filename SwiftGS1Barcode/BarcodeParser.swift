//
//  BarcodeParser.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

public class GS1BarcodeParser: NSObject {
    static func reduce(data: String?, by node: GS1ApplicationIdentifier)->String?{
        if data == nil{
            return data
        }
        // TODO this should also include the maxlength of the identifier
        var length = (node.originalValue?.length ?? 0) + (node.identifier.length)
        if node.dynamicLength && data!.length > length{
            length += 1
        }
        return data!.substring(from: length)
    }
    static func parseGS1ApplicationIdentifier(node: GS1ApplicationIdentifier, data: String)->GS1ApplicationIdentifier{
        print("Parsing node with identifier \(node.identifier) of type \(String(describing: node.type?.description))")
        
        if !data.startsWith(node.identifier){
            print("Passed invalid Node with wrong node identifier")
            return node
        }
        
        // Get Pure Data by removing the identifier
        var nodeData = data
        nodeData = nodeData.substring(from: node.identifier.length)
        
        
        // Cut data by Group Seperator, if dynamic length item and has a GS.
        if node.dynamicLength && nodeData.index(of: "\u{1D}") != nil {
            let toi = nodeData.index(of: "\u{1D}")
            let to = nodeData.distance(from: nodeData.startIndex, to: toi ?? nodeData.startIndex)
            
            nodeData = nodeData.substring(to: to)
        }
        // Cut to Max Length
        if nodeData.length > node.maxLength{
            nodeData = nodeData.substring(to: node.maxLength)
        }
        
        // Set original value to the value of the content
        node.originalValue = nodeData
        
        // Parsing nodeData, based on the node Type
        if node.type == GS1ApplicationIdentifierType.Date && nodeData.length >= 6{ // Parsing 6 Chars to date
            
            node.dateValue = NSDate.from(
                year: Int("20" + nodeData.substring(to: 2)),
                month: Int(nodeData.substring(2, length: 2)),
                day: Int(nodeData.substring(4, length: 2))
            )
        }else if(node.type == GS1ApplicationIdentifierType.Numeric){ // Parsing value to Integer
            node.intValue = Int(nodeData)
        }else{ // Taking the data left and just putting it into the string value
            node.stringValue = nodeData
        }
        return node
    }
}
