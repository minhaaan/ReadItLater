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
  
  @Dependency(\.readItLaterStorage) var readItLaterStorage
  
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
        let userInputText = state.input.text
        return .send(.save(userInputText))
        
      case let .save(text):
        return .send(.list(.insert(text)))
        
      default:
        return .none
      }
    }
  }
}
