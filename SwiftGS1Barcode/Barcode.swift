//
//  Barcode.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

protocol Barcode {
    // Properties
    var raw: String? {get set}
    
    // Initializers
    init()
    init(raw: String)
    
    // Functions
    func validate() -> Bool
    func parse() -> Bool
    
    // Static Functions
    //    static func tryParse(raw: String) -> Bool
    //    static func parse(raw:String ) ->Barcode
    
}
