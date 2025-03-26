//
//  MainInputView.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import SwiftUI
import Perception
import ComposableArchitecture

@Reducer
struct MainInput {
  
  @ObservableState
  struct State: Equatable {
    var text: String = ""
    var writeButtonIsHidden: Bool = true
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

struct MainInputView: View {
  @Perception.Bindable var store: StoreOf<MainInput>
  
  var body: some View {
    WithPerceptionTracking {
      HStack {
        TextField(
          "입력",
          text: $store.text.sending(\.textFieldChanged)
        )
        .padding(20)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .stroke(.black.opacity(0.4), lineWidth: 2)
        )
        .submitLabel(.done)
        .onSubmit {
          store.send(.save)
        }
        
        if !store.writeButtonIsHidden {
          Button(action: {
            store.send(.save)
          }) {
            Image(systemName: "checkmark.circle.fill")
              .font(.title)
              .padding(12)
              .background(Color.blue)
              .foregroundColor(.white)
              .clipShape(RoundedRectangle(cornerRadius: 12))
          }
          .padding(.leading, 8)
          .transition(.move(edge: .trailing).combined(with: .opacity))
          .animation(.easeInOut(duration: 0.3), value: store.writeButtonIsHidden)
        }
      } // HStack
      .padding(.horizontal, 20)
    }
  }
  
}


#Preview {
  MainInputView(
    store: Store(
      initialState: MainInput.State(),
      reducer: {
        MainInput()
      }
    )
  )
}
