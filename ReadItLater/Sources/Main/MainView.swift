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
  }
  
  enum Action {
    case input(MainInput.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.input, action: \.input) {
      MainInput()
    }
    
    Reduce { state, action in
      return .none
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
        
        Spacer()
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
