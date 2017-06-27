//
//  GS1ApplicationIdentifier.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

public enum GS1ApplicationIdentifierType: String{
    case Date
    case AlphaNumeric
    case Numeric
    var description: String{
        return self.rawValue
    }
    public init(){self.init()}
}

public class GS1ApplicationIdentifier: NSObject{
    public var identifier: String
    public var maxLength: Int
    public var dynamicLength: Bool = false
    
    public var type: GS1ApplicationIdentifierType?
    
    public var originalValue: String?
    public var dateValue: NSDate?
    public var intValue: Int?
    public var stringValue: String?
    
    public init(_ identifier: String, length: Int){
        self.identifier = identifier
        self.maxLength = length
    }
    public convenience init(_ identifier: String, length: Int, type: GS1ApplicationIdentifierType){
        self.init(identifier, length: length)
        self.type = type
    }
    public convenience init(_ identifier: String, length: Int, type: GS1ApplicationIdentifierType, dynamicLength: Bool){
        self.init(identifier, length: length, type: type)
        self.dynamicLength = dynamicLength
    }
    public convenience init(dateIdentifier identifier: String){
        self.init(identifier, length: 6, type: .Date)
    }
}
