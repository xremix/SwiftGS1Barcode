# SwiftGS1Barcode
A GS1 Barcode Library and Parser written in Swift

[![Language](https://img.shields.io/badge/language-swift%203-1b7cb9.svg)](https://img.shields.io/badge/language-swift%203-1b7cb9.svg)
[![iOS](https://img.shields.io/badge/iOS-9.0%2B-1b7cb9.svg)](https://img.shields.io/badge/iOS-9.0%2B-1b7cb9.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/xremix/SwiftGS1Barcode/master/LICENSE)

This project is mostly a wraper around the complex logic of parsing GS1 Barcode Strings.

## Usage
Parsing is as simple as

```Swift
let gs1Barcode = "01101234670417283002\u{1D}1721103110S123456"
let barcode = GS1Barcode(raw: gs1Barcode)

print(barcode.gtin) // 10123467041728
print(barcode.amount) // 2
print(barcode.expirationDate) // 31.10.2021
print(barcode.lotNumber) // S123456
```

To seperate the parsing from initializing I'd recommend a code like
```Swift
let gs1BarcodeText = "01101234670417283002\u{1D}1721103110S123456"
let barcode = GS1Barcode()
barcode.raw = gs1BarcodeText
_ = barcode.parse()
```

### Available Properties
**!Attention!** Currently only the following properties are available and do get parsed


| Application Identifier | ID           |
| ------------------ |:-------------:|
| gtin               | 01  |
| gtinIndicatorDigit | 01  |
| lotNumber (batchNumber) | 10  |
| expirationDate     | 17  |
| serialNumber       | 21  |
| amount (quantity)  | 30  |
| productionDate     | 11  |
| dueDate            | 12  |
| packagingDate      | 13  |
| bestBeforeDate     | 15  |
| productVariant     | 20  |
| secondaryDataFields | 22  |
| numberOfUnitsContained | 37  |
| serialShippingContainerCode |  00 |
| gtinOfContainedTradeItems | 02  |

Other properties can be extended pretty easily. **You** can contribute yourself, or open an [issue](https://github.com/xremix/SwiftGS1Barcode/issues/new) if there is something missing for you.

## Installation
### CocoaPods
You can install the library to you project using [CocoaPods](https://cocoapods.org). Add the following code to your `Podfile`:
```
pod 'SwiftGS1Barcode'
```
Alternative you can also add the direct Github URL: 
```
pod 'SwiftGS1Barcode', :git => 'https://github.com/xremix/SwiftGS1Barcode', :branch => 'master'
```

### Manually
You can add the project as a git `submodule`. Simply drag the `SwiftGS1Barcode.xcodeproj` file into your Xcode project.  
**Don't forget to add the framework in your application target**


## Deployment Steps
- Run Unit Tests
- Lint Podfile using `pod lib lint`
- Update Version in `Project Settings` and `Pod Specs`
- Push Code to Git
- Create Release on Git
- Push code to CocoaPods using `pod trunk push SwiftGS1Barcode.podspec`

## Resources
A couple of resources, used for this project.

#### GS1 parsing
https://www.activebarcode.de/codes/ean128_ucc128_ai.html
https://www.gs1.at/fileadmin/user_upload/Liste_GS1_Austria_Application_Identifier.pdf

#### CocoaPod
https://www.appcoda.com/cocoapods-making-guide/


![Analytics](https://ga-beacon.appspot.com/UA-40522413-9/SwiftGS1Barcode/readme?pixel)
