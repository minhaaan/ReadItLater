import ProjectDescription

let project = Project(
    name: "ReadItLater",
    targets: [
        .target(
            name: "ReadItLater",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.ReadItLater",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["ReadItLater/Sources/**"],
            resources: ["ReadItLater/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "ReadItLaterTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.ReadItLaterTests",
            infoPlist: .default,
            sources: ["ReadItLater/Tests/**"],
            resources: [],
            dependencies: [.target(name: "ReadItLater")]
        ),
    ]
)
