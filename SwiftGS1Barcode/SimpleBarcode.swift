//
//  SimpleBarcode.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

/** Sample class for a Barcode **/
class SimpleBarcode: NSObject, Barcode {
    var raw: String?
    required override init() {
        super.init()
    }
    required init(raw: String) {
        self.raw = raw
    }
    func validate() -> Bool {
        return raw != nil && raw! != ""
    }
    func parse()->Bool {
        return validate()
    }
    
}
