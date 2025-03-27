import ProjectDescription

let project = Project(
  name: "ReadItLaterStorage",
  targets: [
    .target(
      name: "ReadItLaterStorage",
      destinations: .iOS,
      product: .framework,
      bundleId: "com.minan.ReadItLaterStorage",
      deploymentTargets: .iOS("15.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .external(name: "ComposableArchitecture"),
      ]
    ),
    .target(
      name: "ReadItLaterStorageTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "com.minan.ReadItLaterStorageTests",
      deploymentTargets: .iOS("15.0"),
      infoPlist: .default,
      sources: ["Tests/**"],
      dependencies: [.target(name: "ReadItLaterStorage")]
    )
  ]
)
