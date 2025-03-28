//
//  MainListView.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import ComposableArchitecture
import Perception
import SwiftUI

struct MainListView: View {
  @Perception.Bindable var store: StoreOf<MainList>
  @Environment(\.scenePhase) var scenePhase
  
  var body: some View {
    WithPerceptionTracking {
      List {
        ForEach(store.items, id: \.id) { item in
          LinkifiedTextView(text: item.text)
        }
        .onDelete { indexSet in
          store.send(.delete(indexSet))
        }
      }
      .onChange(of: scenePhase) { newValue in
        if newValue == .active {
          store.send(.reload)
        }
      }
    }
  }
}

#Preview {
  MainListView(
    store: Store(
      initialState: MainList.State(),
      reducer: { MainList() }
    )
  )
}
