# SwiftGS1Barcode
A GS1 Barcode Library and Parser written in Swift

[![Language](https://img.shields.io/badge/language-swift%203-1b7cb9.svg)](https://img.shields.io/badge/language-swift%203-1b7cb9.svg)
[![iOS](https://img.shields.io/badge/iOS-9.0%2B-1b7cb9.svg)](https://img.shields.io/badge/iOS-9.0%2B-1b7cb9.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/xremix/SwiftGS1Barcode/master/LICENSE)

## Usage
Parsing is as simple as
```
let gs1Barcode = "01101234670417283002\u{1D}1721103110S123456"
let barcode = GS1Barcode(raw: gs1Barcode)

print(barcode.gtin)
print(barcode.amount)
print(barcode.expirationDate)
print(barcode.lotNumber)
```

### Available Properties
Currently only the following properties are available and do get parsed

- `GTIN`
- `lotNumber`
- `expirationDate`
- `serialNumber`
- `amount`

Other properties can be extended pretty easily. *You* can contribute yourself, or open an [issue](https://github.com/xremix/SwiftGS1Barcode/issues/new).


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
* Don't forget to add the framework in your application target *


## Deployment Steps
- Run Unit Tests
- Update Version in `Project Settings` and `Pod Specs`
- Push Code to Git
- Create Release on Git
- `pod lib lint`
- `pod trunk push SwiftGS1Barcode.podspec`

## Resources
A couple of resources, used for this project.

#### GS1 parsing
https://www.activebarcode.de/codes/ean128_ucc128_ai.html
https://www.gs1.at/fileadmin/user_upload/Liste_GS1_Austria_Application_Identifier.pdf

#### CocoaPod
https://www.appcoda.com/cocoapods-making-guide/
