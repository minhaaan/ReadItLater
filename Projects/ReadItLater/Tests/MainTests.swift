//
//  MainTests.swift
//  ReadItLaterTests
//
//  Created by 최민한 on 3/28/25.
//

import Testing
import ComposableArchitecture
import ReadItLaterStorage

@testable import ReadItLater

@MainActor
struct MainTests {
  
  @Test func save_정상적() async throws {
    // GIVEN
    var items: [SharedItem] = []
    
    let store = TestStore(
      initialState: Main.State(input: .init(text: "1123213"))
    ) { 
      Main()
    } withDependencies: { 
      $0.readItLaterStorage.loadAll = {
        return items
      }
      $0.readItLaterStorage.save = { item in
        items.append(item)
      }
    }
    
    // WHEN
    await store.send(.input(.save))
    
    // THEN
    await store.receive(\.input.textFieldChanged) {
      $0.input.text = ""
    }
    await store.receive(\.save)
    await store.receive(\.list.insert)
    await store.receive(\.list.loaded) {
      $0.list.items = items
    }
  }
  
  
}
