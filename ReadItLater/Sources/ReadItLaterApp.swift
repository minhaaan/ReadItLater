import SwiftUI
import ComposableArchitecture

@main
struct ReadItLaterApp: App {
  var body: some Scene {
    WindowGroup {
      MainView(
        store: Store(
          initialState: MainFeature.State(),
          reducer: {
            MainFeature()
          }
        )
      )
    }
  }
}
