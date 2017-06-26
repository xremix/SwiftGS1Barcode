//
//  GS1Barcode.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

// Struct used in the GS1 Barcode Class
struct GS1Nodes{
    var gtinNode = GS1Node("01", length: 14, type: .String)
    var gtinIndicatorDigitNode = GS1Node("01", length: 1, type: .Int)
    var lotNumberNode = GS1Node("10", length: 20, type: .String, dynamicLength: true)
    var expirationDateNode = GS1Node("17", length: 6, type: .Date)
    var serialNumberNode = GS1Node("21", length: 20, type: .String, dynamicLength: true)
    var amountNode = GS1Node("30", length: 8, type: .Int, dynamicLength: true)
}

public class GS1Barcode: NSObject, Barcode {
    public var raw: String?
    private var parseSuccessFull: Bool = false
    var nodes = GS1Nodes()
    
    // Mapping for User Friendly Usage
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
    
    // Validating if the barcode got parsed correctly
    func validate() -> Bool {
        return parseSuccessFull && raw != "" && raw != nil
    }
    
    func parse() ->Bool{
        self.parseSuccessFull = false
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
        self.parseSuccessFull = true
        return true
    }
}
