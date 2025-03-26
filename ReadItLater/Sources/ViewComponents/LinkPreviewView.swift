//
//  LinkPreviewView.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import SwiftUI
import LinkPresentation

struct LinkPreviewView: UIViewRepresentable {
  let url: URL

  func makeUIView(context: Context) -> LPLinkView {
    LPLinkView(url: url)
  }

  func updateUIView(_ uiView: LPLinkView, context: Context) {
    let provider = LPMetadataProvider()
    provider.startFetchingMetadata(for: url) { metadata, error in
      if let metadata {
        DispatchQueue.main.async {
          uiView.metadata = metadata
        }
      }
    }
  }
}
