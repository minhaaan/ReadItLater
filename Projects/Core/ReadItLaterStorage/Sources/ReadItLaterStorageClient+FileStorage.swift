//
//  ReadItLaterStorageClient+FileStorage.swift
//  ReadItLaterStorage
//
//  Created by 최민한 on 3/27/25.
//

import Foundation

extension ReadItLaterStorageClient {
  static func fileStorage(at url: URL = Self.storageURL) -> Self {
    return ReadItLaterStorageClient(
      save: { item in
        var items = try loadItems(from: url)
        items.append(item)
        try saveItems(items, to: url)
      },
      removeItem: { item in
        var items = try loadItems(from: url)
        // item과 동일한 요소 제거
        items.removeAll { $0 == item }
        try saveItems(items, to: url)
      },
      removeAt: { indexSet in
        var items = try loadItems(from: url)
        items.remove(atOffsets: indexSet)
        try saveItems(items, to: url)
      },
      loadAll: {
        return try loadItems(from: url).sorted { $0.date > $1.date }
      },
      clear: {
        try? FileManager.default.removeItem(at: url)
      }
    )
  }
}

private extension ReadItLaterStorageClient {
  /// 저장할 파일의 위치 (Documents 디렉토리에 `sha1redItems.json`)
  static var storageURL: URL = {
    guard let containerURL = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: Constants.appGroupIdentifier
    ) else {
      fatalError("App Group \(Constants.appGroupIdentifier) not found!")
    }
    return containerURL.appendingPathComponent("sharedItems.json")
  }()
  
  static func loadItems(from url: URL) throws -> [SharedItem] {
    // 파일이 없으면 빈 배열 리턴
    guard FileManager.default.fileExists(atPath: url.path) else { return [] }
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode([SharedItem].self, from: data)
  }
  
  static func saveItems(_ items: [SharedItem], to url: URL) throws {
    let data = try JSONEncoder().encode(items)
    try data.write(to: url, options: .atomic)
  }
  
}
