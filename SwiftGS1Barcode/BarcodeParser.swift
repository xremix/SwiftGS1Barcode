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
        if node.dynamicLength{
            length += 1
        }
        return data!.substring(from: length)
    }
    static func parseGS1Node(node: GS1Node, data: String)->GS1Node{
//        print("Parsing node of type \(node.type.description) with identifier \(node.identifier)")
        
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
//        switch node.type {
//        case GS1Type.Date:
//            node.dateValue = NSDate.from(
//                year: Int("20" + nodeData.substring(to: 2)),
//                month: Int(nodeData.substring(2, length: 2)),
//                day: Int(nodeData.substring(4, length: 2))
//            )
//        default:
//            node.stringValue = nodeData
//        }
        
        
        
//        switch node.type {
//        case .GroupSeperatorBased, .GroupSeperatorBasedInt:
//            if !data.contains("\u{1D}") {
//                node.value =  data.substring(from: node.identifier.length)
//            }else{
//                let toi = data.index(of: "\u{1D}")
//                let to = data.distance(from: data.startIndex, to: toi ?? data.startIndex)
//                
//                node.value = data.substring(node.identifier.length, to: to)
//            }
//            if node.type == .GroupSeperatorBasedInt{
//                node.rawValue = Int(node.value!)
//            }
//        case .Date:
//            node.rawValue = NSDate.from(
//                year: Int("20" + data.substring(2, length: 2)),
//                month: Int(data.substring(4, length: 2)),
//                day: Int(data.substring(6, length: 2))
//            )
//            node.value = data.substring(2, length: 6)
//        default:
//            // GTIN, GTINIndicatorDigit, etc.
//            if node.fixedValueLength != nil{
//                node.value = data.substring(node.identifier.length, length: node.fixedValueLength!)
//                if node.type == .FixedLengthBasedInt && node.value != nil{
//                    node.rawValue = Int(node.value!)
//                }
//            }else{
//                // TODO throw error here?
//                node.value = data.substring(from: node.identifier.length)
//            }
//            
//        }
//        if node.rawValue == nil{
//            node.rawValue = node.value
//        }
        return node
    }
}
