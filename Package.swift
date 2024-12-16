// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ByteBuddy",
    platforms: [
        .iOS(.v15),
        .macOS(.v14)
    ],
    products: [
        .executable(name: "CLTExecutor", targets: ["CLTExecutor"]),
        .library(name: "ByteBuddy", type: .static, targets: ["ByteBuddy"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.5.0"),
        .package(url: "https://github.com/httpswift/swifter.git", from: "1.5.0")
    ],
    targets: [
        .target(name: "Shared"),
        .executableTarget(
            name: "CLTExecutor",
            dependencies: [
                "Shared",
                .product(name: "Swifter", package: "swifter"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(name: "ByteBuddy", dependencies: ["Shared"]),
        .testTarget(name: "Tests", dependencies: ["ByteBuddy"], path: "Tests")
    ],
    swiftLanguageVersions: [.v5]
)
