import Dependencies
import MobileCoreServices
import ReadItLaterStorage
import UIKit

class ShareViewController: UIViewController {
  private var hasHandledShare = false
  
  @Dependency(\.readItLaterStorage) var storage

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard !hasHandledShare else { return }
    hasHandledShare = true

    handleShare()
  }

  private func handleShare() {
    guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
          let attachments = item.attachments
    else {
      print("⚠️ 공유 항목 없음")
      finish()
      return
    }

    for provider in attachments {
      if provider.hasItemConformingToTypeIdentifier("public.url") {
        provider.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] data, _ in
          if let url = data as? URL {
            print("🌐 공유된 URL:", url.absoluteString)
            self?.saveSharedText(url.absoluteString)
          } else {
            print("❌ URL 파싱 실패:", data ?? "nil")
            self?.finish()
          }
        }
        return
      }

      if provider.hasItemConformingToTypeIdentifier("public.text") {
        provider.loadItem(forTypeIdentifier: "public.text", options: nil) { [weak self] data, _ in
          if let text = data as? String {
            print("📝 공유된 텍스트:", text)
            self?.saveSharedText(text)
          } else {
            print("❌ 텍스트 파싱 실패:", data ?? "nil")
            self?.finish()
          }
        }
        return
      }
    }

    print("⚠️ 공유 가능한 항목 없음")
    finish()
  }

  private func saveSharedText(_ text: String) {
    Task {
      let item = SharedItem(text: text)

      do {
        try await storage.save(item)
        print("✅ 저장 완료: \(item.text)")
      } catch {
        print("❌ 저장 실패: \(error)")
      }

      self.finish()
    }
  }

  private func finish() {
    DispatchQueue.main.async {
      self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
  }
}
