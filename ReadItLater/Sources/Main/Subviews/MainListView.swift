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
    var items: [String] = []
  }
  
  enum Action {
    case delete(IndexSet)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .delete(indexSet):
        state.items.remove(atOffsets: indexSet)
        return .none
      }
    }
  }
}

struct MainListView: View {
  @Perception.Bindable var store: StoreOf<MainList>
  
  var body: some View {
    List {
      ForEach(store.items, id: \.self) { item in
        Text(item)
      }
      .onDelete { indexSet in
        store.send(.delete(indexSet))
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
