// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "NFCTagIO",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "NFCTagIO",
      targets: ["NFCTagIO"]
    ),
    .library(
      name: "NFCTagUI",
      targets: ["NFCTagUI"]
    ),
  ],
  targets: [
    .target(
      name: "NFCTagIO"
    ),
    .testTarget(
      name: "NFCTagIOTests",
      dependencies: ["NFCTagIO"]
    ),
    .target(
      name: "NFCTagUI",
      dependencies: ["NFCTagIO"]
    ),
  ]
)
