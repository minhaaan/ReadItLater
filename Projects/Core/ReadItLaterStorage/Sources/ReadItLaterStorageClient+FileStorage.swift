//
//  ReadItLaterStorageClient+FileStorage.swift
//  ReadItLaterStorage
//
//  Created by 최민한 on 3/27/25.
//

import Foundation

extension ReadItLaterStorageClient {
  static let fileStorage = ReadItLaterStorageClient(
    save: { item in
      var items = try loadItems()
      items.append(item)
      try saveItems(items)
    },
    removeItem: { item in
      var items = try loadItems()
      // item과 동일한 요소 제거
      items.removeAll { $0 == item }
      try saveItems(items)
    },
    removeAt: { indexSet in
      var items = try loadItems()
      items.remove(atOffsets: indexSet)
      try saveItems(items)
    },
    loadAll: {
      return try loadItems().sorted { $0.timestamp > $1.timestamp }
    },
    clear: {
      try? FileManager.default.removeItem(at: storageURL)
    }
  )
}

private extension ReadItLaterStorageClient {
  /// 저장할 파일의 위치 (Documents 디렉토리에 `sharedItems.json`)
  static var storageURL: URL = {
    let fm = FileManager.default
    let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
    return docs.appendingPathComponent("sharedItems.json")
  }()
  
  static func loadItems() throws -> [SharedItem] {
    // 파일이 없으면 빈 배열 리턴
    guard FileManager.default.fileExists(atPath: storageURL.path) else {
      return []
    }
    let data = try Data(contentsOf: storageURL)
    return try JSONDecoder().decode([SharedItem].self, from: data)
  }
  
  static func saveItems(_ items: [SharedItem]) throws {
    let data = try JSONEncoder().encode(items)
    try data.write(to: storageURL, options: .atomic)
  }
}
