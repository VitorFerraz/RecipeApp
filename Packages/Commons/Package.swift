// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Commons",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Commons",
            targets: ["Commons"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Commons",
            dependencies: [.product(name: "Logging", package: "swift-log")],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]),
        .testTarget(
            name: "CommonsTests",
            dependencies: ["Commons"]
        ),
    ]
)
