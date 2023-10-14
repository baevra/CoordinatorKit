// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CoordinatorKit",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "CoordinatorKit",
      targets: ["CoordinatorKit"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "CoordinatorKit",
      dependencies: []
    ),
    .testTarget(
      name: "CoordinatorKitTests",
      dependencies: ["CoordinatorKit"]
    )
  ]
)
