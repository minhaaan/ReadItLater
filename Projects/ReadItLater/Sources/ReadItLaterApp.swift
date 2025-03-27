import ComposableArchitecture
import SwiftUI

@main
struct ReadItLaterApp: App {
  var body: some Scene {
    WindowGroup {
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
