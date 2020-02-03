# SwiftGS1Barcode
A GS1 Barcode Library and Parser written in Swift

[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/SwiftGS1Barcode/badge.png)](https://cocoadocs.org/docsets/SwiftGS1Barcode)
[![Language](https://img.shields.io/badge/language-swift%205-1b7cb9.svg)](https://img.shields.io/badge/language-swift%205-1b7cb9.svg)
[![iOS](https://img.shields.io/badge/iOS-8.0%2B-1b7cb9.svg)](https://img.shields.io/badge/iOS-9.0%2B-1b7cb9.svg)
[![Code Coverage](https://img.shields.io/badge/Code%20Coverage-97%25-green.svg)](https://img.shields.io/badge/Code%20Coverage-97%25-green.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/xremix/SwiftGS1Barcode/master/LICENSE)
[![Build Status](https://travis-ci.org/xremix/SwiftGS1Barcode.svg?branch=master)](https://travis-ci.org/xremix/SwiftGS1Barcode)

A Library to parse GS1 Barcode strings into a object and allows an easy access to the properties that a GS1 Barcode can have.  
Supported is a large set of common Application Identifiers (GS1 Barcodes), but it can be easily extended on the fly to support any identifier needed.

**Contributions are most welcome.**

You can also find this project on [CocoaPods](https://cocoapods.org/pods/SwiftGS1Barcode)

## Getting started
Parsing is as simple as

```Swift
import SwiftGS1Barcode
// ...
let gs1Barcode = "01101234670417283002\u{1D}1721103110S123456"
let barcode = GS1Barcode(raw: gs1Barcode)

print(barcode.gtin) // 10123467041728
print(barcode.countOfItems) // 2
print(barcode.expirationDate) // 31.10.2021
print(barcode.lotNumber) // S123456
```
#### Advanced Usage

To seperate the parsing from initializing I'd recommend a code like

```Swift
import SwiftGS1Barcode
// ...
let gs1BarcodeText = "01101234670417283002\u{1D}1721103110S123456"
let barcode = GS1Barcode()
barcode.raw = gs1BarcodeText
_ = barcode.parse()
```

To parse **custom Application Identifiers** use the following code

```Swift
import SwiftGS1Barcode
// ...
let gs1BarcodeText = "90HelloWorld\u{1D}01101234670417283002\u{1D}1721103110S123456"
let barcode = GS1Barcode()
barcode.applicationIdentifiers["custom1"] = GS1ApplicationIdentifier("90", length: 30, type: .String, dynamicLength: true)
barcode.raw = gs1BarcodeText
_ = barcode.parse()
print(barcode.applicationIdentifiers["custom1"]!.stringValue)
```
To see some samples, of how to set up Application Identifiers check out the [GS1Barcode Class](https://github.com/xremix/SwiftGS1Barcode/blob/master/SwiftGS1Barcode/GS1Barcode.swift#L19)

### Available Properties
The following properties are currently supported:


| ID | Application Identifier | Experimental Support |
|----|:-------------:|:-------------:|
| 00 | serialShippingContainerCode |          |
| 01 | gtin               |          |
| 02 | gtinOfContainedTradeItems |          |
| 10 | lotNumber (batchNumber) |          |
| 11 | productionDate     |          |
| 12 | dueDate            |          |
| 13 | packagingDate      |          |
| 15 | bestBeforeDate     |          |
| 17 | expirationDate     |          |
| 20 | productVariant     |          |
| 21 | serialNumber       |          |
| 22 | secondaryDataFields |          |
| 30 | countOfItems  |          |
| 37 | numberOfUnitsContained |          |
| 310 | productWeightInKG |          |
| 23n | lotNumberN | Yes |
| 240 | additionalProductIdentification | Yes |
| 241 | customerPartNumber | Yes |
| 242 | madeToOrderVariationNumber | Yes |
| 250 | secondarySerialNumber | Yes |
| 251 | referenceToSourceEntity | Yes |

*Experimental Support means that these are getting parsed, but there are no getter for this. You can get the value by calling e.g.* `myGs1Barcode.applicationIdentifiers["additionalProductIdentification"]`. *Also the implementation can change if any issues come up with the parsing.*

You can add custom application identifiers by adding them to the key / value dictionary:
```Swift
let barcode = GS1Barcode()
barcode.applicationIdentifiers["custom1"] = GS1ApplicationIdentifier("90", length: 30, type: .String, dynamicLength: true)
```
They'll automatically get parsed by the `parse()` function.  
**You can also simply contribute by yourself and add them to the `GS1BarcodeParser.swift` class**, or open an [issue](https://github.com/xremix/SwiftGS1Barcode/issues/new) if there is something missing for you.

## Installation
### CocoaPods
You can install [the library](https://cocoapods.org/pods/SwiftGS1Barcode) to your project by using [CocoaPods](https://cocoapods.org). Add the following code to your `Podfile`:
```
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
	pod 'SwiftGS1Barcode'
end
```
Alternative you can also add the direct Github source (or a different branch):
```
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
	pod 'SwiftGS1Barcode', :git => 'https://github.com/xremix/SwiftGS1Barcode', :branch => 'master'
end
```

### Manually
You can add the project as a git `submodule`. Simply drag the `SwiftGS1Barcode.xcodeproj` file into your Xcode project.  
**Don't forget to add the framework in your application target**

## Resources
A couple of resources, used for this project.

#### GS1 parsing
https://www.gs1.org/docs/barcodes/GS1_General_Specifications.pdf
https://www.activebarcode.de/codes/ean128_ucc128_ai.html
https://www.gs1.at/fileadmin/user_upload/Liste_GS1_Austria_Application_Identifier.pdf

#### CocoaPod
https://www.appcoda.com/cocoapods-making-guide/


![Analytics](https://ga-beacon.appspot.com/UA-40522413-9/SwiftGS1Barcode/readme?pixel)
