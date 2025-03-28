//
//  ReadItLaterStorageClient.swift
//  ReadItLaterStorageClient
//
//  Created by 최민한 on 3/27/25.
//

import Dependencies
import Foundation

public struct ReadItLaterStorageClient {
  public var save: (SharedItem) async throws -> Void
  public var removeItem: (SharedItem) async throws -> Void
  public var removeAt: (IndexSet) async throws -> Void
  public var loadAll: () async throws -> [SharedItem]
  public var clear: () async throws -> Void
  
  static var settings = Settings()
  
  struct Settings {
    /// 저장할 파일의 위치 (Documents 디렉토리에 `sharedItems.json`)
    var storageURL: URL = {
      guard let containerURL = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: Constants.appGroupIdentifier
      ) else {
        fatalError("App Group \(Constants.appGroupIdentifier) not found!")
      }
      return containerURL.appendingPathComponent("sharedItems.json")
    }()
  }
}

extension ReadItLaterStorageClient: DependencyKey {
  public static var liveValue: ReadItLaterStorageClient {
    .fileStorage
  }
  
  public static var previewValue: ReadItLaterStorageClient {
    .fileStorage
  }
}

public extension DependencyValues {
  var readItLaterStorage: ReadItLaterStorageClient {
    get { self[ReadItLaterStorageClient.self] }
    set { self[ReadItLaterStorageClient.self] = newValue }
  }
}
