//
//  MainView.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import SwiftUI
import Perception
import ComposableArchitecture

@Reducer
struct MainFeature {
  
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
        state.list.items.insert(text, at: 0)
        state.input.text = ""
        state.input.writeButtonIsHidden = true
        return .none
        
      default:
        return .none
      }
    }
  }
  
  
  
}

struct MainView: View {
  @Perception.Bindable var store: StoreOf<MainFeature>
  
  var body: some View {
    WithPerceptionTracking {
      VStack {
        MainInputView(
          store: store.scope(state: \.input, action: \.input)
        )
        
        MainListView(
          store: store.scope(state: \.list, action: \.list)
        )
      } // VStack
    }
  }
  
}

#Preview {
  MainView(
    store: Store(
      initialState: MainFeature.State(),
      reducer: {
        MainFeature()
      }
    )
  )
}
