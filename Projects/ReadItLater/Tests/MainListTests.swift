//
//  MainListTests.swift
//  ReadItLaterTests
//
//  Created by 최민한 on 3/28/25.
//

import ComposableArchitecture
import Dependencies
import Foundation
import ReadItLaterStorage
import Testing

@testable import ReadItLater

@MainActor
struct MainListTests {
  @Test func onAppear() async throws {
    // GIVEN
    let store = TestStore(
      initialState: MainList.State()
    ) {
      MainList()
    } withDependencies: {
      $0.readItLaterStorage.loadAll = {
        [.mock]
      }
    }
    
    // WHEN
    await store.send(.onAppear)
    
    // THEN
    await store.receive(\.loaded) { state in
      state.items = [.mock]
    }
    #expect(store.state.items.count == 1)
  }
  
  @Test() func insertAndDelete() async {
    // GIVEN
    var items: [SharedItem] = []
    
    let store = TestStore(
      initialState: MainList.State()
    ) {
      MainList()
    } withDependencies: {
      $0.readItLaterStorage.loadAll = {
        items
      }
      $0.readItLaterStorage.save = { item in
        items.append(item)
      }
      $0.readItLaterStorage.removeAt = { index in
        items.remove(atOffsets: index)
      }
    }
    
    // WHEN
    await store.send(.insert(""))
    
    // THEN
    await store.receive(\.loaded) { state in
      state.items = items
    }
    
    // Delete Test
    // WHEN
    await store.send(.delete(.init(integer: 0)))
    
    // THEN
    await store.receive(\.loaded) { state in
      state.items = []
    }
  }
}
