import ProjectDescription

let project = Project(
  name: "ReadItLater",
  targets: [
    .target(
      name: "ReadItLater",
      destinations: .iOS,
      product: .app,
      bundleId: "io.tuist.ReadItLater",
      deploymentTargets: .iOS("15.0"),
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
      dependencies: [
        .external(name: "ComposableArchitecture")
      ]
    ),
    .target(
      name: "ReadItLaterTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "io.tuist.ReadItLaterTests",
      deploymentTargets: .iOS("15.0"),
      infoPlist: .default,
      sources: ["ReadItLater/Tests/**"],
      resources: [],
      dependencies: [.target(name: "ReadItLater")]
    ),
  ]
)
