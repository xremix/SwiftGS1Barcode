//
//  StringExtension.swift
//  SwiftGS1Barcode
//
//  Created by Toni Hoffmann on 26.06.17.
//  Copyright © 2017 Toni Hoffmann. All rights reserved.
//

import UIKit

extension String{
    func substring(_ from: Int, length: Int)->String{
        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(start, offsetBy: length)
        let range = start..<end
        
        
        return self.substring(with: range)  // play
    }
    func substring(_ from: Int, to: Int)->String{
        return self.substring(from, length: to-from)
    }
    func substring(from: Int)->String{
        return self.substring(from, length: self.length - from)
    }
    
    func substring(to: Int)->String{
        return self.substring(0, length: to)
    }
    func substring(to: String)->String{
        if let index =  self.index(of: to){
            return self.substring(to:index)
        }
        return self
    }
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    func startsWith(_ subString: String)->Bool{
        return self.hasPrefix(subString)
    }
    var length: Int{
        get{
            return self.characters.count
        }
    }
}
