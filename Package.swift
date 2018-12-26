// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Shell",
    products: [
        .library(name: "Shell", targets: ["Shell"]),
        .library(name: "ShellTesting", targets: ["ShellTesting"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Shell",
            dependencies: []
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
