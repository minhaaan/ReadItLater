import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "ReadItLaterStorage",
  options: .options(automaticSchemesOptions: .enabled(codeCoverageEnabled: true)),
  targets: [
    .target(
      name: "ReadItLaterStorage",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "com.minan.ReadItLaterStorage",
      deploymentTargets: .iOS("15.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .external(name: "ComposableArchitecture"),
      ],
      settings: .settings(
        base: ["DEVELOPMENT_TEAM": teamId],
        defaultSettings: .recommended
      )
    ),
    .target(
      name: "ReadItLaterStorageTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "com.minan.ReadItLaterStorageTests",
      deploymentTargets: .iOS("15.0"),
      infoPlist: .default,
      sources: ["Tests/**"],
      dependencies: [.target(name: "ReadItLaterStorage")],
      settings: .settings(
        base: ["DEVELOPMENT_TEAM": teamId],
        defaultSettings: .recommended
      )
    )
  ]
)
