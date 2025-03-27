//
//  LinkPreviewView.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import LinkPresentation
import SwiftUI

struct LinkPreviewView: UIViewRepresentable {
  let url: URL

  func makeUIView(context _: Context) -> LPLinkView {
    LPLinkView(url: url)
  }

  func updateUIView(_ uiView: LPLinkView, context _: Context) {
    let provider = LPMetadataProvider()
    provider.startFetchingMetadata(for: url) { metadata, _ in
      if let metadata {
        DispatchQueue.main.async {
          uiView.metadata = metadata
        }
      }
    }
  }
}
