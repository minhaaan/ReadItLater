//
//  LinkifiedTextView.swift
//  ReadItLater
//
//  Created by 최민한 on 3/27/25.
//

import SwiftUI

import SwiftUI

struct LinkifiedTextView: View {
  
  let text: String

  var body: some View {
    let parts = parseTextWithLinks(from: text)

    HStack(alignment: .firstTextBaseline, spacing: 0) {
      ForEach(Array(parts.enumerated()), id: \.offset) { index, part in
        switch part {
        case .text(let string):
          Text(string)
        case .link(let string):
          Text(string)
            .foregroundColor(.blue)
            .underline()
            .onTapGesture {
              if let url = validatedURL(from: string) {
                UIApplication.shared.open(url)
              }
            }
        }
      }
    }
    .textSelection(.enabled)
  }

  // MARK: - Parsing

  enum TextPart {
    case text(String)
    case link(String)
  }
  
  func parseTextWithLinks(from text: String) -> [TextPart] {
    let pattern = #"((https?|ftp)://[^\s]+)"#

    guard let regex = try? NSRegularExpression(pattern: pattern) else {
      return [.text(text)]
    }

    var result: [TextPart] = []
    var currentIndex = text.startIndex

    let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))

    for match in matches {
      guard let range = Range(match.range, in: text) else { continue }
      let linkText = String(text[range])

      if currentIndex < range.lowerBound {
        let normalText = String(text[currentIndex..<range.lowerBound])
        result.append(.text(normalText))
      }

      result.append(.link(linkText))
      currentIndex = range.upperBound
    }

    if currentIndex < text.endIndex {
      result.append(.text(String(text[currentIndex...])))
    }

    return result
  }

  private func validatedURL(from string: String) -> URL? {
    let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: encoded),
          UIApplication.shared.canOpenURL(url) else {
      return nil
    }
    return url
  }
}



#Preview {
  VStack {
    LinkifiedTextView(text: "Hello World!")
    LinkifiedTextView(text: "Hello World! https://www.apple.com")
    LinkifiedTextView(text: "Hello World! https://www.apple.com Hello World!")
    LinkifiedTextView(text: "Hello World! https://www.apple.com https://naver.com Hello World!")
    LinkifiedTextView(text: "https://www.apple.com")
  }
}
