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
    var expirationDateNode = GS1Node(dateIdentifier: "17")
    var serialNumberNode = GS1Node("21", length: 20, type: .String, dynamicLength: true)
    var amountNode = GS1Node("30", length: 8, type: .Int, dynamicLength: true)
    
    // Experimental Support
    //    var serialShippingContainerCodeNode = GS1Node("0", length: 18, type: .String)
    //    var gtinOfContainedTradeItemsNode = GS1Node("2", length: 14, type: .String)
    var productionDateNode = GS1Node(dateIdentifier: "11")
    var dueDateNode = GS1Node(dateIdentifier: "12")
    var packagingDateNode = GS1Node(dateIdentifier: "13")
    var bestBeforeDateNode = GS1Node(dateIdentifier: "15")
    var productVariantNode = GS1Node("20", length: 2, type: .String)
    var secondaryDataFieldsNode = GS1Node("22", length:29, type: .String, dynamicLength:true)
    var numberOfUnitsContainedNode = GS1Node("37", length:8, type: .String, dynamicLength:true)
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
    
    // Experimental Support
    public var productionDate: NSDate? {get{return nodes.productionDateNode.dateValue}}
    public var dueDate: NSDate? {get{return nodes.dueDateNode.dateValue}}
    public var packagingDate: NSDate? {get{return nodes.packagingDateNode.dateValue}}
    public var bestBeforeDate: NSDate? {get{return nodes.bestBeforeDateNode.dateValue}}
    public var productVariant: String? {get{return nodes.productVariantNode.stringValue}}
    public var secondaryDataFields: String? {get{return nodes.secondaryDataFieldsNode.stringValue}}
    public var numberOfUnitsContained: String? {get{return nodes.numberOfUnitsContainedNode.stringValue}}
    
    // Super Experimental Support
    //    public var serialShippingContainerCode: String? {get{return nodes.serialShippingContainerCodeNode.stringValue}}
    //    public var gtinOfContainedTradeItems: String? {get{return nodes.gtinOfContainedTradeItemsNode.stringValue}}
    
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
    
    func parseNode(node: inout GS1Node, data: inout String)->Bool{
        if(data.startsWith(node.identifier)){
            node = GS1BarcodeParser.parseGS1Node(node: node, data: data)
            data =  GS1BarcodeParser.reduce(data: data, by: node)!
            return true
        }
        return false
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
                }
                else if(parseNode(node: &nodes.lotNumberNode, data: &data!)){}
                else if parseNode(node: &nodes.expirationDateNode, data: &data!){}
                else if parseNode(node: &nodes.serialNumberNode, data: &data!){}
                else if parseNode(node: &nodes.amountNode, data: &data!){}
                    // Experimental Support
                else if(parseNode(node: &nodes.productionDateNode, data: &data!)){}
                else if(parseNode(node: &nodes.dueDateNode, data: &data!)){}
                else if(parseNode(node: &nodes.packagingDateNode, data: &data!)){}
                else if(parseNode(node: &nodes.bestBeforeDateNode, data: &data!)){}
                else if(parseNode(node: &nodes.productVariantNode, data: &data!)){}
                else if(parseNode(node: &nodes.secondaryDataFieldsNode, data: &data!)){}
                else if(parseNode(node: &nodes.numberOfUnitsContainedNode, data: &data!)){}
                    // Supper Experimental Support
                    //                else if(parseNode(node: &nodes.serialShippingContainerCodeNode, data: &data!)){}
                    //                else if(parseNode(node: &nodes.gtinOfContainedTradeItemsNode, data: &data!)){}
                else{
                    print("Do not know identifier. Canceling Parsing")
                    return false
                }
            }
        }
        self.parseSuccessFull = true
        return true
    }
}
