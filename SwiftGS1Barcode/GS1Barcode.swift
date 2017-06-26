//
//  GS1Barcode.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

class GS1Barcode: NSObject {
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
