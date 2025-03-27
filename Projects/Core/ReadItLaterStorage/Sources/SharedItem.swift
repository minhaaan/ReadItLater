//
//  SharedItem.swift
//  ReadItLaterStorage
//
//  Created by 최민한 on 3/27/25.
//

import Foundation

/// 저장할 아이템 모델
public struct SharedItem: Codable, Equatable, Identifiable {
  public let id: UUID
  public let text: String
  public let date: Date
  
  public init(text: String, date: Date = Date()) {
    id = UUID()
    self.text = text
    self.date = date
  }
}
