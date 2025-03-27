//
//  PressHighlightButtonStyle.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import SwiftUI

struct PressHighlightButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .opacity(configuration.isPressed ? 0.5 : 1.0)
  }
}
