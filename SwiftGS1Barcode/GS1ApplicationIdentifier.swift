//
//  GS1ApplicationIdentifier.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

enum GS1ApplicationIdentifierType: String{
    case Date
    case String
    case Int
    var description: String{
        return self.rawValue
    }
}

public class GS1ApplicationIdentifier: NSObject{
    var identifier: String
    var maxLength: Int
    var dynamicLength: Bool = false
    
    var type: GS1ApplicationIdentifierType?
    
    var originalValue: String?
    var dateValue: NSDate?
    var intValue: Int?
    
    var stringValue: String?
    
    init(_ identifier: String, length: Int){
        self.identifier = identifier
        self.maxLength = length
    }
    convenience init(_ identifier: String, length: Int, type: GS1ApplicationIdentifierType){
        self.init(identifier, length: length)
        self.type = type
    }
    convenience init(_ identifier: String, length: Int, type: GS1ApplicationIdentifierType, dynamicLength: Bool){
        self.init(identifier, length: length, type: type)
        self.dynamicLength = dynamicLength
    }
    convenience init(dateIdentifier identifier: String){
        self.init(identifier, length: 6, type: .Date)
    }
}
