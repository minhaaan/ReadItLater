//
//  SharedKeys.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import Foundation
import Sharing

extension URL {
  static var texts: URL {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentDirectory.appendingPathComponent("texts")
  }
}
