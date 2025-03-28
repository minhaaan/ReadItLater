//
//  ReadItLaterStorageClient+FileStorage.swift
//  ReadItLaterStorage
//
//  Created by 최민한 on 3/27/25.
//

import Foundation

// MARK: - ReadItLaterStorageClient + FileStorage

extension ReadItLaterStorageClient {
  static let fileStorage = ReadItLaterStorageClient { item in
    var items = try loadAllItems()
    items.append(item)
    try saveItems(items)
  } removeItem: { item in
    var items = try loadAllItems()
    items.removeAll { $0 == item }
    try saveItems(items)
  } removeAt: { indexSet in
    var items = try loadAllItems()
    items.remove(atOffsets: indexSet)
    try saveItems(items)
  } loadAll: {
    try loadAllItems().sorted { $0.date > $1.date }
  } clear: {
    try? FileManager.default.removeItem(at: ReadItLaterStorageClient.settings.storageURL)
  }
}

private extension ReadItLaterStorageClient {
  /// 파일저장소에서 전체 리스트 불러오기
  static func loadAllItems() throws -> [SharedItem] {
    // 파일이 없으면 빈 배열 리턴
    let url = Self.settings.storageURL
    guard FileManager.default.fileExists(atPath: url.path) else { return [] }
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode([SharedItem].self, from: data)
  }
  
  /// 파일저장소에 아이템 저장
  static func saveItems(_ items: [SharedItem]) throws {
    let url = Self.settings.storageURL
    let data = try JSONEncoder().encode(items)
    try data.write(to: url, options: .atomic)
  }
}
