// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftGS1Barcode",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "SwiftGS1Barcode",
            targets: ["SwiftGS1Barcode"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftGS1Barcode",
            dependencies: [],
            path: "SwiftGS1Barcode",
            exclude: ["Info.plist"]),
        .testTarget(
            name: "SwiftGS1BarcodeTests",
            dependencies: ["SwiftGS1Barcode"],
            path: "SwiftGS1BarcodeTests",
            exclude: ["Info.plist"]),
    ],
    swiftLanguageVersions: [.v5]
)
