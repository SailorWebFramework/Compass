// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "compass",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "CompassCLI", targets: ["CompassCLI"]),
        .library(name: "CompassUtils", targets: ["CompassUtils"]),
        .executable(name: "Compass", targets: ["Compass"])  
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", branch: "main"),
        .package(url: "https://github.com/pakLebah/ANSITerminal", branch: "master"),
        .package(url: "https://github.com/eonist/FileWatcher.git", branch: "master")

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Compass",
            dependencies: [
                "CompassCLI",
            ],
            path: "Sources/Compass"),
        .target(
            name: "CompassCLI",
            dependencies: [
                "CompassUtils"
            ],
            path: "Sources/CompassCLI"),
        .target(
            name: "CompassUtils",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ANSITerminal",
                "FileWatcher"
            ],
            path: "Sources/CompassUtils"),
    ]
)