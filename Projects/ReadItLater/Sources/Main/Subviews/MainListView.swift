//
//  MainListView.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import ComposableArchitecture
import Perception
import SwiftUI
import ReadItLaterStorage
import Dependencies

@Reducer
struct MainList {
  
  @ObservableState
  struct State: Equatable {
    var items: [SharedItem] = []
  }
  
  enum Action {
    case onAppear
    case loaded([SharedItem])
    case insert(String)
    case delete(IndexSet)
  }
  
  @Dependency(\.readItLaterStorage) var readItLaterStorage
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        // 저장된 목록 로드
        return .run { send in
          do {
            let sharedItems = try await readItLaterStorage.loadAll()
            await send(.loaded(sharedItems))
          } catch {
            // 에러 처리
          }
        }
        
      case let .loaded(items):
        state.items = items
        return .none
        
      case let .insert(text):
        let item = SharedItem(text: text, date: Date())
        return .run { send in
          do {
            try await readItLaterStorage.save(item)
            let updatedItems = try await readItLaterStorage.loadAll()
            await send(.loaded(updatedItems))
          } catch {
            // 필요하면 에러 처리
          }
        }
        
      case let .delete(indexSet):
        return .run { send in
          do {
            try await readItLaterStorage.removeAt(indexSet)
            let updatedItems = try await readItLaterStorage.loadAll()
            await send(.loaded(updatedItems))
          } catch {
            // 필요하면 에러 처리
          }
        }
      }
    }
  }
}

struct MainListView: View {
  @Perception.Bindable var store: StoreOf<MainList>
  
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
      .onAppear {
        store.send(.onAppear)
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
