//
//  BarcodeParser.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

public class GS1BarcodeParser: NSObject {
    static func reduce(data: String?, by node: GS1Node)->String?{
        if data == nil{
            return data
        }
        
        var length = (node.originalValue?.length ?? 0) + (node.identifier.length)
        if node.dynamicLength && data!.length > length{
            length += 1
        }
        return data!.substring(from: length)
    }
    static func parseGS1Node(node: GS1Node, data: String)->GS1Node{
        print("Parsing node with identifier \(node.identifier) of type \(String(describing: node.type?.description))")
        
        // Get Pure Data by removing the identifier
        var nodeData = data
        nodeData = nodeData.substring(from: node.identifier.length)
        
        
        // Cut to Group Seperator
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
        
        if node.type == GS1Type.Date{
            
            node.dateValue = NSDate.from(
                year: Int("20" + nodeData.substring(to: 2)),
                month: Int(nodeData.substring(2, length: 2)),
                day: Int(nodeData.substring(4, length: 2))
            )
        }else if(node.type == GS1Type.Int){
            node.intValue = Int(nodeData)
        }else{
            node.stringValue = nodeData
        }
        return node
    }
}
