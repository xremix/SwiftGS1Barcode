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
        "serialShippingContainerCode": GS1ApplicationIdentifier("00", length: 18, type: .AlphaNumeric),
        "gtin": GS1ApplicationIdentifier("01", length: 14, type: .AlphaNumeric),
        // TODO Get rid of the gtinIndicatorDigit? This isn't an official AI
        "gtinIndicatorDigit": GS1ApplicationIdentifier("01", length: 1, type: .Numeric),
        "gtinOfContainedTradeItems": GS1ApplicationIdentifier("02", length: 14, type: .AlphaNumeric),
        "lotNumber": GS1ApplicationIdentifier("10", length: 20, type: .AlphaNumeric, dynamicLength: true),
        "productionDate": GS1ApplicationIdentifier(dateIdentifier: "11"),
        "dueDate": GS1ApplicationIdentifier(dateIdentifier: "12"),
        "packagingDate": GS1ApplicationIdentifier(dateIdentifier: "13"),
        "bestBeforeDate": GS1ApplicationIdentifier(dateIdentifier: "15"),
        "expirationDate": GS1ApplicationIdentifier(dateIdentifier: "17"),
        "productVariant": GS1ApplicationIdentifier("20", length: 2, type: .AlphaNumeric),
        "serialNumber": GS1ApplicationIdentifier("21", length: 20, type: .AlphaNumeric, dynamicLength: true),
        "secondaryDataFields": GS1ApplicationIdentifier("22", length:29, type: .AlphaNumeric, dynamicLength:true),
        "countOfItems": GS1ApplicationIdentifier("30", length: 8, type: .Numeric, dynamicLength: true),
        "numberOfUnitsContained": GS1ApplicationIdentifier("37", length:8, type: .AlphaNumeric, dynamicLength:true),
        // Experimental Support
        "lotNumberN": GS1ApplicationIdentifier("23n", length:19, type: .AlphaNumeric, dynamicLength:true), // TODO add friendly property
        "additionalProductIdentification": GS1ApplicationIdentifier("240", length:30, type: .AlphaNumeric, dynamicLength:true), // TODO add friendly property
        "customerPartNumber": GS1ApplicationIdentifier("241", length:30, type: .AlphaNumeric, dynamicLength:true), // TODO add friendly property
        "madeToOrderVariationNumber": GS1ApplicationIdentifier("242", length:6, type: .AlphaNumeric, dynamicLength:true), // TODO add friendly property
        "secondarySerialNumber": GS1ApplicationIdentifier("250", length:30, type: .AlphaNumeric, dynamicLength:true), // TODO add friendly property
        "referenceToSourceEntity": GS1ApplicationIdentifier("251", length:30, type: .AlphaNumeric, dynamicLength:true), // TODO add friendly property
        "productWeightInKgNoDecimal": GS1ApplicationIdentifier("3100", length: 6, type: .Numeric),// TODO add friendly property
        "productWeightInKgOnceDecimal": GS1ApplicationIdentifier("3101", length: 6, type: .Numeric),// TODO add friendly property
        "productWeightInKgTwoDecimal": GS1ApplicationIdentifier("3102", length: 6, type: .Numeric),// TODO add friendly property
    ]
    
    // Mapping for User Friendly Usage
    public var gtin: String?{ get {return applicationIdentifiers["gtin"]!.stringValue} }
    public var lotNumber: String?{ get {return applicationIdentifiers["lotNumber"]!.stringValue} }
    public var expirationDate: NSDate?{ get {return applicationIdentifiers["expirationDate"]!.dateValue} }
    public var serialNumber: String?{ get {return applicationIdentifiers["serialNumber"]!.stringValue} }
    public var countOfItems: Int?{ get {return applicationIdentifiers["countOfItems"]!.intValue} }
    public var gtinIndicatorDigit: Int? {get {return applicationIdentifiers["gtinIndicatorDigit"]!.intValue}}
    // TODO Order could be changed to fit dictionary above
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
        // Setting Original Data
        self.raw = raw
        // Parsing Barcode
        _ = parse()
    }
    required public init(raw: String, customApplicationIdentifiers: [String: GS1ApplicationIdentifier]) {
        super.init()
        // Setting Original Data
        self.raw = raw
        
        // Adding Custom Application Identifiers
        for ai in customApplicationIdentifiers{
            self.applicationIdentifiers[ai.key] = ai.value
        }
        // Parsing Barcode
        _ = parse()
    }
    
    // Validating if the barcode got parsed correctly
    public func validate() -> Bool {
        return lastParseSuccessfull && raw != "" && raw != nil
    }
    
    private func parseApplicationIdentifier(_ ai: GS1ApplicationIdentifier, data: inout String)->Bool{
        if(data.startsWith(ai.identifier)){
            let pai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: data)
            //            ai = GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: data)
            // Fixes issue where two AIs have the same identifier (TODO: should maybe get rid of gtinIndicatorDigit)
            if  pai.identifier == "01"{
                let digit = GS1BarcodeParser.parseGS1ApplicationIdentifier(self.applicationIdentifiers["gtinIndicatorDigit"]!, data: data)
                applicationIdentifiers["gtinIndicatorDigit"] = digit
            }
            data =  GS1BarcodeParser.reduce(data: data, by: ai)!
            
            return true
        }
        return false
    }
    
    public func parse() ->Bool{
        self.lastParseSuccessfull = false
        var data = raw
        
        if data != nil{
            while data!.characters.count > 0 {
                // Removing Group Seperator from the beginning of the string
                if(data!.startsWith("\u{1D}")){
                    data = data!.substring(from: 1)
                }
                
                // Checking the AIs by it's identifier and passing it to the Barcode Parser to get the value and cut the data
                var foundOne = false
                for (key, applicationIdentifier) in applicationIdentifiers {
                    // Exclude the gtinIndicatorDigit, because it get's added later for the gtin identifier
                    if key != "gtinIndicatorDigit"{
                        // If could parse ai, continue and do the loop once again
                        if(parseApplicationIdentifier(applicationIdentifier, data: &data!)){
                            foundOne = true
                            continue
                        }
                    }
                }
                // If no ai was found return false and keep the lastParseSuccessfull to false -> This will make validate() fail as well
                if !foundOne{
                    print("GS1Barcode Warning: Do not know identifier and cannot parse rest of the Barcode. Canceling barcode parsing")
                    return false
                }
            }
        }
        self.lastParseSuccessfull = true
        return true
    }
}
