# Deployment Steps

The following steps need to be done to deploy the Library to `Github` and `Cocoapods`:

- Run Unit Tests
- Lint Podfile using `pod lib lint`
- Update Version in `Project Settings` and `Pod Specs`
- Push Code to Git
- Create Release on Git
  - `git tag -a 0.5.4 -m "0.5.4"`
  - `git push origin 0.5.4`
- Push code to CocoaPods using `pod trunk push SwiftGS1Barcode.podspec`
