// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SwiftOverlays",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftOverlays",
            targets: ["SwiftOverlays"]
        )
    ],
    targets: [
        .target(
            name: "SwiftOverlays",
            dependencies: [],
            path: "SwiftOverlays",
            exclude: ["Info.plist"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
