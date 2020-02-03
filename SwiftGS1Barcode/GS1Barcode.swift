//
//  GS1Barcode.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

public class GS1Barcode: NSObject, Barcode {
    /** RAW Data of the barcode in a string */
    public var raw: String?
    /** Stores if the last parsing was successfull */
    private var lastParseSuccessfull: Bool = false
    
    /** Dictionary containing all supported application identifiers */
    public var applicationIdentifiers = [
        "serialShippingContainerCode": GS1ApplicationIdentifier("00", length: 18, type: .AlphaNumeric),
        "gtin": GS1ApplicationIdentifier("01", length: 14, type: .AlphaNumeric),
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
        "productWeightInKg": GS1ApplicationIdentifier("310", length: 6, type: .NumericDouble),
        // Experimental Support
        // TODO add friendly property for the following properties, once they leave experimental support
        "lotNumberN": GS1ApplicationIdentifier("23n", length:19, type: .AlphaNumeric, dynamicLength:true),
        "additionalProductIdentification": GS1ApplicationIdentifier("240", length:30, type: .AlphaNumeric, dynamicLength:true),
        "customerPartNumber": GS1ApplicationIdentifier("241", length:30, type: .AlphaNumeric, dynamicLength:true),
        "madeToOrderVariationNumber": GS1ApplicationIdentifier("242", length:6, type: .AlphaNumeric, dynamicLength:true),
        "secondarySerialNumber": GS1ApplicationIdentifier("250", length:30, type: .AlphaNumeric, dynamicLength:true),
        "referenceToSourceEntity": GS1ApplicationIdentifier("251", length:30, type: .AlphaNumeric, dynamicLength:true),
    ]
    
    /** Mapping for User Friendly Usage */
    public var serialShippingContainerCode: String? {get{return applicationIdentifiers["serialShippingContainerCode"]!.stringValue}}
    public var gtin: String?{ get {return applicationIdentifiers["gtin"]!.stringValue} }
    public var gtinOfContainedTradeItems: String? {get{return applicationIdentifiers["gtinOfContainedTradeItems"]!.stringValue}}
    public var lotNumber: String?{ get {return applicationIdentifiers["lotNumber"]!.stringValue} }
    public var productionDate: Date? {get{return applicationIdentifiers["productionDate"]!.dateValue}}
    public var dueDate: Date? {get{return applicationIdentifiers["dueDate"]!.dateValue}}
    public var packagingDate: Date? {get{return applicationIdentifiers["packagingDate"]!.dateValue}}
    public var bestBeforeDate: Date? {get{return applicationIdentifiers["bestBeforeDate"]!.dateValue}}
    public var expirationDate: Date?{ get {return applicationIdentifiers["expirationDate"]!.dateValue} }
    public var productVariant: String? {get{return applicationIdentifiers["productVariant"]!.stringValue}}
    public var serialNumber: String?{ get {return applicationIdentifiers["serialNumber"]!.stringValue} }
    public var secondaryDataFields: String? {get{return applicationIdentifiers["secondaryDataFields"]!.stringValue}}
    public var countOfItems: Int?{ get {return applicationIdentifiers["countOfItems"]!.intValue} }
    public var numberOfUnitsContained: String? {get{return applicationIdentifiers["numberOfUnitsContained"]!.stringValue}}
    public var productWeightInKg: Double? {get{return applicationIdentifiers["productWeightInKg"]!.doubleValue}}
    
    
    required override public init() {
        super.init()
    }
    
    /** Init barcode with string and parse it */
    required public init(raw: String) {
        super.init()
        // Setting Original Data
        self.raw = raw
        // Parsing Barcode
        try? parse()
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
        try? parse()
    }
    
    /** Validating if the barcode got parsed correctly **/
    public func validate() -> Bool {
        return lastParseSuccessfull && raw != "" && raw != nil
    }
    
    private func parseApplicationIdentifier(_ ai: GS1ApplicationIdentifier, data: inout String) throws{
        if(data.startsWith(ai.identifier)){
            // This can throw an error! Make sure data setting is like expected
            do{
                try GS1BarcodeParser.parseGS1ApplicationIdentifier(ai, data: data)
                data =  GS1BarcodeParser.reduce(data: data, by: ai)!
            }catch let error{
                // Pass error to calling function
                throw error
            }
        }else{
            print("The data didn't start with the expected Application Identifier \(ai.identifier)")
        }
    }
    
    @available(*, deprecated, message: "Please use the function parse() to parse a barcode")
    /** Temporary function, to allow a smooth transition of the legacy parse function */
    public func tryParse() -> Bool{
        do{
            try parse()
            return true
        }catch{
            return false
        }
        
    }
    
    public func parse() throws{
        self.lastParseSuccessfull = false
        var data = raw
        
        if data != nil{
            while data!.count > 0 {
                // Removing Group Seperator from the beginning of the string
                if(data!.startsWith("\u{1D}")){
                    data = data!.substring(from: 1)
                }
                
                // Checking the AIs by it's identifier and passing it to the Barcode Parser to get the value and cut the data
                var foundOne = false
                for (_, applicationIdentifier) in applicationIdentifiers {
                    // Exclude the gtinIndicatorDigit, because it get's added later for the gtin identifier
                    // If could parse ai, continue and do the loop once again
                    // Keep syntax like that! foundOne should and continue should only be set if no error was thrown
                    do{
                        if(data!.startsWith(applicationIdentifier.identifier)){
                            try parseApplicationIdentifier(applicationIdentifier, data: &data!)
                            foundOne = true
                            continue
                        }
                        
                    }catch{
                        foundOne = false
                    }
                }
                // If no ai was found return false and keep the lastParseSuccessfull to false -> This will make validate() fail as well
                if !foundOne{
                    throw GS1BarcodeErrors.ParseError.didNotFoundApplicationIdentifier
                }
            }
        }
        self.lastParseSuccessfull = true
    }
}
