//
//  ReadItLaterStorageClient+MemoryStorage.swift
//  ReadItLaterStorage
//
//  Created by 최민한 on 3/27/25.
//

import Foundation

// MARK: - ReadItLaterStorageClient + MemoryStorage
extension ReadItLaterStorageClient {
  static func memoryStorage() -> Self {
    actor Memory {
      var items: [SharedItem] = []
      
      func save(_ item: SharedItem) {
        items.append(item)
      }
      
      func removeItem(_ item: SharedItem) {
        items.removeAll { $0 == item }
      }
      
      func removeAt(_ indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
      }
      
      func loadAll() -> [SharedItem] {
        items.sorted { $0.date > $1.date }
      }
      
      func clear() {
        items.removeAll()
      }
    }
    
    let memory = Memory()
    
    return ReadItLaterStorageClient(
      save: { item in
        await memory.save(item)
      },
      removeItem: { item in
        await memory.removeItem(item)
      },
      removeAt: { indexSet in
        await memory.removeAt(indexSet)
      },
      loadAll: {
        await memory.loadAll()
      },
      clear: {
        await memory.clear()
      }
    )
  }
}
