// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NFCTagIO",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NFCTagIO",
            targets: ["NFCTagIO"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NFCTagIO"),
        .testTarget(
            name: "NFCTagIOTests",
            dependencies: ["NFCTagIO"]),
    ]
)