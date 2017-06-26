//
//  GS1Barcode.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

// Struct used in the GS1 Barcode Class
// TODO think about getting rid of this and use a key value pair

public class GS1Barcode: NSObject, Barcode {
    public var raw: String?
    private var parseSuccessFull: Bool = false
    //    var nodes = GS1Nodes()
    var nodeDictionary = [
        // ATTENTION! NEVER CHANGE THE ORDER
        "gtinIndicatorDigit": GS1Node("01", length: 1, type: .Int),
        "gtin": GS1Node("01", length: 14, type: .String),
        "lotNumber": GS1Node("10", length: 20, type: .String, dynamicLength: true),
        "expirationDate": GS1Node(dateIdentifier: "17"),
        "serialNumber": GS1Node("21", length: 20, type: .String, dynamicLength: true),
        "amount": GS1Node("30", length: 8, type: .Int, dynamicLength: true),
        // Experimental Support
        "productionDate": GS1Node(dateIdentifier: "11"),
        "dueDate": GS1Node(dateIdentifier: "12"),
        "packagingDate": GS1Node(dateIdentifier: "13"),
        "bestBeforeDate": GS1Node(dateIdentifier: "15"),
        "productVariant": GS1Node("20", length: 2, type: .String),
        "secondaryDataFields": GS1Node("22", length:29, type: .String, dynamicLength:true),
        "numberOfUnitsContained": GS1Node("37", length:8, type: .String, dynamicLength:true),
        
        "serialShippingContainerCode": GS1Node("00", length: 18, type: .String),
        "gtinOfContainedTradeItems": GS1Node("02", length: 14, type: .String),
        
        ]
    // Mapping for User Friendly Usage
    public var gtin: String?{ get {return nodeDictionary["gtin"]!.stringValue} }
    public var lotNumber: String?{ get {return nodeDictionary["lotNumber"]!.stringValue} }
    public var expirationDate: NSDate?{ get {return nodeDictionary["expirationDate"]!.dateValue} }
    public var serialNumber: String?{ get {return nodeDictionary["serialNumber"]!.stringValue} }
    public var amount: Int?{ get {return nodeDictionary["amount"]!.intValue} }
    public var gtinIndicatorDigit: Int? {get {return nodeDictionary["gtinIndicatorDigit"]!.intValue}}
    
    // Experimental Support
    public var serialShippingContainerCode: String? {get{return nodeDictionary["serialShippingContainerCode"]!.stringValue}}
    public var gtinOfContainedTradeItems: String? {get{return nodeDictionary["gtinOfContainedTradeItems"]!.stringValue}}
    public var productionDate: NSDate? {get{return nodeDictionary["productionDate"]!.dateValue}}
    public var dueDate: NSDate? {get{return nodeDictionary["dueDate"]!.dateValue}}
    public var packagingDate: NSDate? {get{return nodeDictionary["packagingDate"]!.dateValue}}
    public var bestBeforeDate: NSDate? {get{return nodeDictionary["bestBeforeDate"]!.dateValue}}
    public var productVariant: String? {get{return nodeDictionary["productVariant"]!.stringValue}}
    public var secondaryDataFields: String? {get{return nodeDictionary["secondaryDataFields"]!.stringValue}}
    public var numberOfUnitsContained: String? {get{return nodeDictionary["numberOfUnitsContained"]!.stringValue}}
    
    
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
            if  node.identifier != "gtinIndicatorDigit"{
                data =  GS1BarcodeParser.reduce(data: data, by: node)!
            }
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
                
                // Checking the nodes by it's identifier and passing it to the Barcode Parser to get the value and cut the data
                
                var foundOne = false
//                if(data!.startsWith(nodeDictionary["gtin"]!.identifier)){
//                    nodeDictionary["gtin"]! = GS1BarcodeParser.parseGS1Node(node: nodeDictionary["gtin"]!, data: data!)
//                    nodeDictionary["gtinIndicatorDigit"]! = GS1BarcodeParser.parseGS1Node(node: nodeDictionary["gtinIndicatorDigit"]!, data: data!)
//                    data =  GS1BarcodeParser.reduce(data: data, by: nodeDictionary["gtin"]!)
//                    foundOne = true
//                }else{
                    for nodeKey in nodeDictionary.keys{
//                        if nodeKey != "gtin" && nodeKey != "gtinIndicatorDigit"{
                            if(parseNode(node: &nodeDictionary[nodeKey]!, data: &data!)){
                                foundOne = true
                                continue
                            }
//                        }
                    }
//                }
                
                
                if !foundOne{
                    print("Do not know identifier. Canceling Parsing")
                    return false
                }
            }
        }
        self.parseSuccessFull = true
        return true
    }
}
