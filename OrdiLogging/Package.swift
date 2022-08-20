// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "OrdiLogging",
  platforms: [
    .iOS(.v15),
    .macOS(.v11),
  ],
  products: [
    .library(name: "OrdiLogging", targets: ["OrdiLogging"]),
    .library(name: "OrdiPulseLogging", targets: ["OrdiPulseLogging"]),
    .library(name: "OrdiPulseAlamofirePlugin", targets: ["OrdiPulseAlamofirePlugin"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/kean/Pulse",
      .upToNextMinor(from: .init(0, 20, 1))),
    .package(
      url: "https://github.com/Alamofire/Alamofire.git",
      .upToNextMinor(from: .init(5, 5, 0))),
  ],
  targets: [
    .target(
      name: "OrdiLogging",
      dependencies: [],
      path: "Sources/OrdiLogging"),
    .target(
      name: "OrdiPulseLogging",
      dependencies: [
        "OrdiLogging",
        .product(name: "Pulse", package: "Pulse"),
        .product(name: "PulseUI", package: "Pulse"),
      ]),
    .target(
      name: "OrdiPulseAlamofirePlugin",
      dependencies: [
        .product(name: "Alamofire", package: "Alamofire"),
      ]),
  ])
