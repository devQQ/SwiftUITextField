// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUITextField",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftUITextField",
            targets: ["SwiftUITextField"]),
    ],
    dependencies: [
       .package(url: "https://github.com/devQQ/SwiftUIStyleKit", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftUITextField",
            dependencies: ["SwiftUIStyleKit"]),
        .testTarget(
            name: "SwiftUITextFieldTests",
            dependencies: ["SwiftUITextField", "SwiftUIStyleKit"]),
    ]
)
