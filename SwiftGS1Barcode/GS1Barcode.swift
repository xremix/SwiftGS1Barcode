//
//  GS1Barcode.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit


enum GS1Type: String{
    case Date
    case String
    case Int
    var description: String{
        return self.rawValue
    }
}

class GS1Node: NSObject{
    var identifier: String
    var maxLength: Int
    var dynamicLength: Bool = false
    
    var type: GS1Type?
    
    var originalValue: String?
    var dateValue: NSDate?
    var intValue: Int?
    
    var stringValue: String?
    
    init(_ identifier: String, length: Int){
        self.identifier = identifier
        self.maxLength = length
    }
    convenience init(_ identifier: String, length: Int, type: GS1Type){
        self.init(identifier, length: length)
        self.type = type
    }
    convenience init(_ identifier: String, length: Int, type: GS1Type, dynamicLength: Bool){
        self.init(identifier, length: length, type: type)
        self.dynamicLength = dynamicLength
    }
}



struct GS1Nodes{
    var gtinNode = GS1Node("01", length: 14, type: .String)
    var gtinIndicatorDigitNode = GS1Node("10", length: 1, type: .String)
    var lotNumberNode = GS1Node("01", length: 20, type: .String, dynamicLength: true)
    var expirationDateNode = GS1Node("17", length: 6, type: .Date)
    var serialNumberNode = GS1Node("20", length: 20, type: .String, dynamicLength: true)
    var amountNode = GS1Node("30", length: 8, type: .Int, dynamicLength: true)
    //    var gtinNode = GS1Node(identifier: "01", type: .FixedLengthBased, fixedValue: 14)
    //    var gtinIndicatorDigitNode = GS1Node(identifier: "01", type: .FixedLengthBasedInt, fixedValue: 1)
    //    // TODO should have maximum of 20
    //    var lotNumberNode = GS1Node(identifier: "10", type: .GroupSeperatorBased)
    //    var expirationDateNode = GS1Node(identifier: "17", type: .Date)
    //    // TODO should have maximum of 20
    //    var serialNumberNode = GS1Node(identifier: "21", type: .GroupSeperatorBased)
    //    // TODO should have maximum of 8 characters
    //    var amountNode = GS1Node(identifier: "30", type: .GroupSeperatorBasedInt)
}

public class GS1Barcode: NSObject, Barcode {
    public var raw: String?
    var nodes = GS1Nodes()
    
    public var gtin: String?{ get {return nodes.gtinNode.stringValue} }
    public var lotNumber: String?{ get {return nodes.lotNumberNode.stringValue} }
    public var expirationDate: NSDate?{ get {return nodes.expirationDateNode.dateValue} }
    public var serialNumber: String?{ get {return nodes.serialNumberNode.stringValue} }
    public var amount: Int?{ get {return nodes.amountNode.intValue} }
    public var gtinIndicatorDigit: Int? {get {return nodes.gtinIndicatorDigitNode.intValue}}
    
    required override public init() {
        super.init()
    }
    required public init(raw: String) {
        super.init()
        self.raw = raw
        _ = parse()
    }
    
    func validate() -> Bool {
        return gtin != nil
    }
    
    func parse() ->Bool{
        var data = raw
        
        if data != nil{
            while data!.characters.count > 0 {
                if(data!.startsWith("\u{1D}")){
                    data = data!.substring(from: 1)
                }
                
                                if(data!.startsWith(nodes.gtinNode.identifier)){
                                    nodes.gtinNode = GS1BarcodeParser.parseGS1Node(node: nodes.gtinNode, data: data!)
                                    nodes.gtinIndicatorDigitNode = GS1BarcodeParser.parseGS1Node(node: nodes.gtinIndicatorDigitNode, data: data!)
                                    data =  GS1BarcodeParser.reduce(data: data, by: nodes.gtinNode)
                                }else if(data!.startsWith(nodes.lotNumberNode.identifier)){
                                    nodes.lotNumberNode = GS1BarcodeParser.parseGS1Node(node: nodes.lotNumberNode, data: data!)
                                    data =  GS1BarcodeParser.reduce(data: data, by: nodes.lotNumberNode)
                                }else if(data!.startsWith(nodes.expirationDateNode.identifier)){
                                    nodes.expirationDateNode = GS1BarcodeParser.parseGS1Node(node: nodes.expirationDateNode, data: data!)
                                    data =  GS1BarcodeParser.reduce(data: data, by: nodes.expirationDateNode)
                                }else if(data!.startsWith(nodes.serialNumberNode.identifier)){
                                    nodes.serialNumberNode = GS1BarcodeParser.parseGS1Node(node: nodes.serialNumberNode, data: data!)
                                    data =  GS1BarcodeParser.reduce(data: data, by: nodes.serialNumberNode)
                                }else if(data!.startsWith(nodes.amountNode.identifier)){
                                    nodes.amountNode = GS1BarcodeParser.parseGS1Node(node: nodes.amountNode, data: data!)
                                    data =  GS1BarcodeParser.reduce(data: data, by: nodes.amountNode)
                                }else{
                                    print("Do not know identifier. Canceling Parsing")
                                    return false
                                }
            }
        }
        return true
    }
}
