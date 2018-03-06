//
//  GS1ApplicationIdentifier.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

public enum GS1ApplicationIdentifierType: String{
    case AlphaNumeric
    case Numeric
    case NumericDouble // TODO document this in the readme
    case Date
    var description: String{
        return self.rawValue
    }
    public init(){self.init()}
}

public class GS1ApplicationIdentifier: NSObject{
    /** Barcode Parser will search for this identifier and will */
    public var identifier: String
    /** Maximum length. The value can be smaller if there are not enough characters available or if dynamic length is active (and a GS character is available) */
    public var maxLength: Int
    /** Seperates by the next GS-character */
    public var dynamicLength: Bool = false
    
    public var type: GS1ApplicationIdentifierType?
    
    /** The original data from the AI. This will always been set to the content that was trying to be parsed. If Date / Int parsing failed it will still pout the content in there */
    public var rawValue: String?
    /** This will be set by the Barcode parser, if type is Date */
    public var dateValue: Date?
    /** This will be set by the Barcode parser, if type is Numeric */
    public var intValue: Int?
    /** This will be set by the Barcode parser, if type is NumericDouble */
    public var doubleValue: Double?
    /** This will be set by the Barcode parser, if type is AlphaNumeric */
    public var stringValue: String?
    
    public var decimalPlaces: Int?
    
    /** Initiates a GS1 AI with a maximum length */
    public init(_ identifier: String, length: Int){
        self.identifier = identifier
        self.maxLength = length
    }
    
    /** Initiates a GS1 AI with a maximum length and a type */
    public convenience init(_ identifier: String, length: Int, type: GS1ApplicationIdentifierType){
        self.init(identifier, length: length)
        self.type = type
    }
    
    /** Initiates a GS1 AI with a maximum length and dynamic length and a type. The dynamic length is always stronger than the maximum length */
    public convenience init(_ identifier: String, length: Int, type: GS1ApplicationIdentifierType, dynamicLength: Bool){
        self.init(identifier, length: length, type: type)
        self.dynamicLength = dynamicLength
    }
    
    /** Initiates a GS1 AI of type date */
    public convenience init(dateIdentifier identifier: String){
        // Defaults the max length to 6 and sets default type to Date
        self.init(identifier, length: 6, type: .Date)
    }
}
