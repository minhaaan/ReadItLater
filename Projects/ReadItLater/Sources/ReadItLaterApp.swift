import ComposableArchitecture
import SwiftUI

@main
struct ReadItLaterApp: App {
  var body: some Scene {
    WindowGroup {
      if TestContext.current == nil {
        MainView(
          store: Store(
            initialState: Main.State(),
            reducer: {
              Main()
            }
          )
        )
      }
    }
  }
}
