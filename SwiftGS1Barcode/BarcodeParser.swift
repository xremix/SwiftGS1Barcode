//
//  BarcodeParser.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

class GS1BarcodeParser: NSObject {
    static func reduce(data: String?, by node: GS1Node)->String?{
        if data == nil{
            return data
        }
        
        var length = (node.value?.length ?? 0) + (node.identifier.length)
        if (node.type == .GroupSeperatorBased || node.type == .GroupSeperatorBasedInt) && length < data!.length{
            length += 1
        }
        return data!.substring(from: length)
    }
    static func parseGS1Node(node: GS1Node, data: String)->GS1Node{
        print("Parsing node of type \(node.type.description) with identifier \(node.identifier)")
        switch node.type {
        case .GTIN:
            node.value = data.substring(node.identifier.length, length: node.type.fixedValueLength!)
            //            GETINIndicatorDigit
            break
        case .GroupSeperatorBased, .GroupSeperatorBasedInt:
            if !data.contains("\u{1D}") {
                node.value =  data.substring(from: node.identifier.length)
            }else{
                let toi = data.index(of: "\u{1D}")
                let to = data.distance(from: data.startIndex, to: toi ?? data.startIndex)
                
                node.value = data.substring(node.identifier.length, to: to)
            }
            if node.type == .GroupSeperatorBasedInt{
                node.rawValue = Int(node.value!)
            }
            
        case .Date:
            node.rawValue = NSDate.from(
                year: Int("20" + data.substring(2, length: 2)),
                month: Int(data.substring(4, length: 2)),
                day: Int(data.substring(6, length: 2))
            )
            node.value = data.substring(2, length: 6)
        }
        if node.rawValue == nil{
            node.rawValue = node.value
        }
        return node
    }
}
