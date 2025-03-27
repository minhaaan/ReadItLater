//
//  MainView.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import ComposableArchitecture
import Perception
import SwiftUI

struct MainView: View {
  @Perception.Bindable var store: StoreOf<Main>
  
  var body: some View {
    WithPerceptionTracking {
      VStack {
        MainListView(
          store: store.scope(state: \.list, action: \.list)
        )
        
        MainInputView(
          store: store.scope(state: \.input, action: \.input)
        )
      } // VStack
    }
  }
}

#Preview {
  MainView(
    store: Store(
      initialState: Main.State(),
      reducer: {
        Main()
      }
    )
  )
}
