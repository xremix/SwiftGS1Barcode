//
//  GS1BarcodeErrors.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 06.03.18.
//  Copyright © 2018 Toni Hoffmann. All rights reserved.
//

import Foundation

class GS1BarcodeErrors: NSObject {
    /** Error cases for Barcode Parser */
    public enum ParseError: Error {
        case dataDoesNotStartWithAIIdentifier(data: String)
        case emptyData
        // GS1 Barcode
        case didNotFoundApplicationIdentifier
    }
    public enum ValidationError: Error{
        case parseUnsucessfull
        case barcodeNil
        case barcodeEmpty
        case unallowedCharacter
    }
}
