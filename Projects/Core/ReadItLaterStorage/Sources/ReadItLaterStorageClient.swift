//
//  ReadItLaterStorageClient.swift
//  ReadItLaterStorageClient
//
//  Created by 최민한 on 3/27/25.
//

import Foundation
import Dependencies

public struct ReadItLaterStorageClient {
  public var save: (SharedItem) async throws -> Void
  public var removeItem: (SharedItem) async throws -> Void
  public var removeAt: (IndexSet) async throws -> Void
  public var loadAll: () async throws -> [SharedItem]
  public var clear: () async throws -> Void
}

extension ReadItLaterStorageClient: DependencyKey {
  public static var liveValue: ReadItLaterStorageClient {
    .fileStorage()
  }
}

extension DependencyValues {
  public var readItLaterStorage: ReadItLaterStorageClient {
    get { self[ReadItLaterStorageClient.self] }
    set { self[ReadItLaterStorageClient.self] = newValue }
  }
}


