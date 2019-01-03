// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Shell",
    products: [
        .library(name: "Shell", targets: ["Shell"]),
        .library(name: "ShellTesting", targets: ["ShellTesting"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMinor(from: "0.9.2")),
        .package(url: "https://github.com/antitypical/Result.git", .upToNextMinor(from: "4.1.0")),
    ],
    targets: [
        .target(
            name: "Shell",
            dependencies: ["PathKit", "Result"]
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
