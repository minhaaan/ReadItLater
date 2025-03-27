//
//  MainInputView.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import ComposableArchitecture
import Perception
import SwiftUI

struct MainInputView: View {
  @Perception.Bindable var store: StoreOf<MainInput>
  
  var body: some View {
    WithPerceptionTracking {
      HStack {
        Button(action: {
          let pasteboard = UIPasteboard.general
          let pastedString = pasteboard.string ?? ""
          store.send(.textFieldChanged(pastedString))
        }) {
          Image(systemName: "document.on.clipboard.fill")
            .padding(12)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        
        TextEditor(text: $store.text.sending(\.textFieldChanged))
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .fixedSize(horizontal: false, vertical: true)
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
              .background(store.writeButtonDisabled ? Color.gray : Color.blue)
              .foregroundColor(.white)
              .clipShape(RoundedRectangle(cornerRadius: 12))
          }
          .padding(.leading, 8)
          .transition(.move(edge: .trailing).combined(with: .opacity))
          .animation(.easeInOut(duration: 0.3), value: store.writeButtonIsHidden)
          .disabled(store.writeButtonDisabled)
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
