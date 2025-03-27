import SwiftUI
import Perception
import ComposableArchitecture

@Reducer
struct MainInput {
  
  @ObservableState
  struct State: Equatable {
    var text: String = ""
    var writeButtonIsHidden: Bool = true
    var writeButtonDisabled: Bool = false
  }
  
  enum Action {
    case textFieldChanged(String)
    case save
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .textFieldChanged(let text):
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