// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "compass",
    platforms: [
        .macOS(.v13)
    ],
        dependencies: [
            .package(
                url: "https://github.com/apple/swift-argument-parser.git",
                branch: "main"
            ),
           .package(url: "https://github.com/swiftwasm/carton", branch: "main"),

        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "compass",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "CartonKit", package: "carton")
            ],
            path: "Sources"),
    ]
)
