import ComposableArchitecture
import Foundation
import Perception

@Reducer
struct Main {
  @ObservableState
  struct State: Equatable {
    var input = MainInput.State()
    var list = MainList.State()
  }
  
  enum Action {
    case input(MainInput.Action)
    case list(MainList.Action)
    case save(String)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.input, action: \.input) {
      MainInput()
    }
    Scope(state: \.list, action: \.list) {
      MainList()
    }
    
    Reduce { state, action in
      switch action {
      case .input(.save):
        // 입력값 저장
        let trimmed = state.input.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
          return .send(.save(trimmed))
        }
        return .none
        
      case let .save(text):
        return .merge(
          .send(.list(.insert(text))),
          .send(.input(.textFieldChanged("")))
        )
        
      default:
        return .none
      }
    }
  }
}
