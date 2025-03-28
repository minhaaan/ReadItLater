//
//  FileStorageTests.swift
//  ReadItLaterStorageTests
//
//  Created by 최민한 on 3/27/25.
//

@testable import ReadItLaterStorage
import Dependencies
import Foundation
import Testing

class FileStorageTests {
  /// 테스트를 위한 디렉토리 경로
  let testDirectory: URL = {
    let temp = FileManager.default.temporaryDirectory
    let dir = temp.appendingPathComponent("ReadItLaterTest", isDirectory: true)
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    return dir.appendingPathComponent("sharedItems.json")
  }()
  
  let storage: ReadItLaterStorageClient
  
  init() async throws {
    ReadItLaterStorageClient.settings.storageURL = testDirectory
    storage = ReadItLaterStorageClient.fileStorage
    // 테스트 전에 파일을 지워줌
    try await ReadItLaterStorageClient.fileStorage.clear()
  }
  
  deinit {
    // 테스트 후에 정리
    try? FileManager.default.removeItem(at: testDirectory)
  }
  
  @Test func saveAndLoad() async throws {
    // GIVEN
    let item = SharedItem(text: "Hello, world!")
    
    // WHEN
    try await storage.save(item)
    
    // THEN
    let loadedItems = try await storage.loadAll()
    #expect(loadedItems.count == 1)
    #expect(loadedItems.first == item)
  }
  
  @Test func removeItem() async throws {
    // GIVEN
    let item = SharedItem(text: "Hello, world!")
    try await storage.save(item)
    
    // WHEN
    try await storage.removeItem(item)
    
    // THEN
    let loadedItems = try await storage.loadAll()
    #expect(loadedItems.isEmpty)
  }
  
  @Test func removeAt() async throws {
    // GIVEN
    let item = SharedItem(text: "Hello, world!")
    let item1 = SharedItem(text: "Hello, world!123")
    try await storage.save(item)
    try await storage.save(item1)
    
    // WHEN
    try await storage.removeAt(IndexSet(integer: 0))
    
    // THEN
    let loadedItems = try await storage.loadAll()
    #expect(loadedItems.count == 1)
    #expect(loadedItems.first == item1)
  }
  
  @Test func loadAllSortedWithDate() async throws {
    // GIVEN
    let item = SharedItem(text: "Hello, world!", date: Date(timeIntervalSince1970: 0))
    let item1 = SharedItem(text: "Hello, world!123", date: Date(timeIntervalSince1970: 1))
    try await storage.save(item)
    try await storage.save(item1)
    
    // WHEN
    
    // THEN
    let loadedItems = try await storage.loadAll()
    #expect(loadedItems.count == 2)
    #expect(loadedItems.first == item1)
    #expect(loadedItems.last == item)
  }
}
