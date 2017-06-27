//
//  GS1Barcode.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

public class GS1Barcode: NSObject, Barcode {
    // RAW Data of the barcode in a string
    public var raw: String?
    // Stores if the last parsing was successfull
    private var lastParseSuccessfull: Bool = false
    
    // Dictionary containing all supported application identifiers
    public var applicationIdentifiers = [
        "gtinIndicatorDigit": GS1ApplicationIdentifier("01", length: 1, type: .Int),
        "gtin": GS1ApplicationIdentifier("01", length: 14, type: .String),
        "lotNumber": GS1ApplicationIdentifier("10", length: 20, type: .String, dynamicLength: true),
        "expirationDate": GS1ApplicationIdentifier(dateIdentifier: "17"),
        "serialNumber": GS1ApplicationIdentifier("21", length: 20, type: .String, dynamicLength: true),
        "amount": GS1ApplicationIdentifier("30", length: 8, type: .Int, dynamicLength: true),
        // Experimental Support
        "serialShippingContainerCode": GS1ApplicationIdentifier("00", length: 18, type: .String),
        "gtinOfContainedTradeItems": GS1ApplicationIdentifier("02", length: 14, type: .String),
        "productionDate": GS1ApplicationIdentifier(dateIdentifier: "11"),
        "dueDate": GS1ApplicationIdentifier(dateIdentifier: "12"),
        "packagingDate": GS1ApplicationIdentifier(dateIdentifier: "13"),
        "bestBeforeDate": GS1ApplicationIdentifier(dateIdentifier: "15"),
        "productVariant": GS1ApplicationIdentifier("20", length: 2, type: .String),
        "secondaryDataFields": GS1ApplicationIdentifier("22", length:29, type: .String, dynamicLength:true),
        "numberOfUnitsContained": GS1ApplicationIdentifier("37", length:8, type: .String, dynamicLength:true),
        
        ]
    
    // Mapping for User Friendly Usage
    public var gtin: String?{ get {return applicationIdentifiers["gtin"]!.stringValue} }
    public var lotNumber: String?{ get {return applicationIdentifiers["lotNumber"]!.stringValue} }
    public var expirationDate: NSDate?{ get {return applicationIdentifiers["expirationDate"]!.dateValue} }
    public var serialNumber: String?{ get {return applicationIdentifiers["serialNumber"]!.stringValue} }
    public var amount: Int?{ get {return applicationIdentifiers["amount"]!.intValue} }
    public var gtinIndicatorDigit: Int? {get {return applicationIdentifiers["gtinIndicatorDigit"]!.intValue}}
    // Experimental Support
    public var serialShippingContainerCode: String? {get{return applicationIdentifiers["serialShippingContainerCode"]!.stringValue}}
    public var gtinOfContainedTradeItems: String? {get{return applicationIdentifiers["gtinOfContainedTradeItems"]!.stringValue}}
    public var productionDate: NSDate? {get{return applicationIdentifiers["productionDate"]!.dateValue}}
    public var dueDate: NSDate? {get{return applicationIdentifiers["dueDate"]!.dateValue}}
    public var packagingDate: NSDate? {get{return applicationIdentifiers["packagingDate"]!.dateValue}}
    public var bestBeforeDate: NSDate? {get{return applicationIdentifiers["bestBeforeDate"]!.dateValue}}
    public var productVariant: String? {get{return applicationIdentifiers["productVariant"]!.stringValue}}
    public var secondaryDataFields: String? {get{return applicationIdentifiers["secondaryDataFields"]!.stringValue}}
    public var numberOfUnitsContained: String? {get{return applicationIdentifiers["numberOfUnitsContained"]!.stringValue}}
    
    
    required override public init() {
        super.init()
    }
    
    // Init barcode with string and parse it
    required public init(raw: String) {
        super.init()
        self.raw = raw
        _ = parse()
    }
    
    // Validating if the barcode got parsed correctly
    func validate() -> Bool {
        return lastParseSuccessfull && raw != "" && raw != nil
    }
    
    func parseNode(node: inout GS1ApplicationIdentifier, data: inout String)->Bool{
        if(data.startsWith(node.identifier)){
            node = GS1BarcodeParser.parseGS1ApplicationIdentifier(node: node, data: data)
            // Fixes issue where two nodes have the same identifier
            if  node.identifier == "01"{
                applicationIdentifiers["gtinIndicatorDigit"] = GS1BarcodeParser.parseGS1ApplicationIdentifier(node:  applicationIdentifiers["gtinIndicatorDigit"]!, data: data)
            }
            data =  GS1BarcodeParser.reduce(data: data, by: node)!
            
            return true
        }
        return false
    }
    
    func parse() ->Bool{
        self.lastParseSuccessfull = false
        var data = raw
        
        if data != nil{
            while data!.characters.count > 0 {
                // Removing Group Seperator from the beginning of the string
                if(data!.startsWith("\u{1D}")){
                    data = data!.substring(from: 1)
                }
                
                // Checking the nodes by it's identifier and passing it to the Barcode Parser to get the value and cut the data
                var foundOne = false
                for nodeKey in applicationIdentifiers.keys{
                    // Exclude the gtinIndicatorDigit, because it get's added later for the gtin identifier
                    if nodeKey != "gtinIndicatorDigit"{
                        // If could parse node, continue and do the loop once again
                        if(parseNode(node: &applicationIdentifiers[nodeKey]!, data: &data!)){
                            foundOne = true
                            continue
                        }
                    }
                }
                // If no node was found return false and keep the lastParseSuccessfull to false
                if !foundOne{
                    print("Do not know identifier. Canceling Parsing")
                    return false
                }
            }
        }
        self.lastParseSuccessfull = true
        return true
    }
}
