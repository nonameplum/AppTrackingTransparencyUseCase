// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AppTrackingKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AppTrackingKit",
            targets: ["AppTrackingKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AppTrackingKit",
            dependencies: []),
        .testTarget(
            name: "AppTrackingKitTests",
            dependencies: ["AppTrackingKit"]),
    ]
)
