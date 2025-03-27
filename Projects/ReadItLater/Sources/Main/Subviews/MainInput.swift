import ComposableArchitecture
import Perception
import SwiftUI

@Reducer
struct MainInput {
  @ObservableState
  struct State: Equatable {
    var text = ""
    var writeButtonIsHidden = true
    var writeButtonDisabled = true
  }

  enum Action {
    case textFieldChanged(String)
    case save
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .textFieldChanged(text):
        state.text = text
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        state.writeButtonDisabled = trimmed.isEmpty
        withAnimation {
          state.writeButtonIsHidden = text.isEmpty
        }
        return .none
      case .save:
        return .none
      }
    }
  }
}
