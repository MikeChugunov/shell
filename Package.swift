// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Shell",
    products: [
        .library(name: "Shell", targets: ["Shell"]),
        .library(name: "ShellTesting", targets: ["ShellTesting"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/PathKit.git", .upToNextMinor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "Shell",
            dependencies: ["PathKit"]
        ),
        .target(
            name: "ShellTesting",
            dependencies: ["Shell"]
        ),
        .testTarget(
            name: "ShellTests",
            dependencies: ["Shell"]
        ),
    ]
)
