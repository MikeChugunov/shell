import ProjectDescription

let project = Project(name: "Shell-Carthage",
                      targets: [
                        Target(name: "Shell",
                               platform: .macOS,
                               product: .framework,
                               bundleId: "io.tuist.Shell",
                               infoPlist: "Info.plist",
                               sources: "Sources/Shell/**",
                               dependencies: [
                                  .framework(path: "Carthage/Build/Mac/PathKit.framework")
                               ]),
                        Target(name: "ShellTesting",
                               platform: .macOS,
                               product: .framework,
                               bundleId: "io.tuist.ShellTesting",
                               infoPlist: "Info.plist",
                               sources: "Sources/ShellTesting/**",
                               dependencies: [
                                  .framework(path: "Carthage/Build/Mac/PathKit.framework"),
                                  .target(name: "Shell")
                               ])]
)
