//
//  MainListView.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import ComposableArchitecture
import Perception
import SwiftUI

@Reducer
struct MainList {
  
  @ObservableState
  struct State: Equatable {
    @Shared(.fileStorage(.texts)) var items: [String] = []
  }
  
  enum Action {
    case insert(String)
    case delete(IndexSet)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .insert(text):
        state.$items.withLock {
          $0.insert(text, at: 0)
        }
        return .none
      case let .delete(indexSet):
        state.$items.withLock {
          $0.remove(atOffsets: indexSet)
        }
        return .none
      }
    }
  }
}

struct MainListView: View {
  @Perception.Bindable var store: StoreOf<MainList>
  
  var body: some View {
    WithPerceptionTracking {
      List {
        ForEach(store.items, id: \.self) { item in
          LinkifiedTextView(text: item)
        }
        .onDelete { indexSet in
          store.send(.delete(indexSet))
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
