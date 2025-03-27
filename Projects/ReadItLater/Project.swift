import ProjectDescription

let project = Project(
  name: "ReadItLater",
  targets: [
    .target(
      name: "ReadItLater",
      destinations: .iOS,
      product: .app,
      bundleId: "com.minan.ReadItLater",
      deploymentTargets: .iOS("15.0"),
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ],
        ]
      ),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .external(name: "ComposableArchitecture"),
        .target(name: "SharedExtension"),
      ]
    ),
    .target(
      name: "ReadItLaterTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "com.minan.ReadItLaterTests",
      deploymentTargets: .iOS("15.0"),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [.target(name: "ReadItLater")]
    ),
    .target(
      name: "SharedExtension",
      destinations: .iOS,
      product: .appExtension,
      bundleId: "com.minan.ReadItLater.sharedextension",
      deploymentTargets: .iOS("15.0"),
      infoPlist: .extendingDefault(
        with: [
          "CFBundleDisplayName": "ReadItLater",
          "NSExtension": [
            "NSExtensionPointIdentifier": "com.apple.share-services",
            "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).ShareViewController",
            "NSExtensionAttributes": [
              "NSExtensionActivationRule": [
                "NSExtensionActivationSupportsText": true,
                "NSExtensionActivationSupportsWebURLWithMaxCount": 1
              ]
            ]
          ]
        ]
      ),
      sources: ["SharedExtensionSources/**"],
      resources: [],
      dependencies: []
    )
  ]
)
