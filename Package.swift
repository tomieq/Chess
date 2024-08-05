// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "chess",
    products: [
        .library(
            name: "chess",
            targets: ["chess"]),
        .executable(name: "web",
                    targets: ["web"])
    ],
    dependencies: [
        .package(url: "https://github.com/tomieq/BootstrapStarter", from: "1.0.0"),
        .package(url: "https://github.com/tomieq/swifter.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/tomieq/Template.swift.git", from: "1.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "chess",
            dependencies: []),
        .executableTarget(name: "web",
                          dependencies: ["chess",
                                         .product(name: "BootstrapTemplate", package: "BootstrapStarter"),
                                         .product(name: "Swifter", package: "Swifter"),
                                         .product(name: "Template", package: "Template.swift")]),
        .testTarget(
            name: "chessTests",
            dependencies: ["chess"])
    ]
)
