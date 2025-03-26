import UIKit
import MobileCoreServices

class ShareViewController: UIViewController {
  private var hasHandledShare = false

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard !hasHandledShare else { return }
    hasHandledShare = true

    handleShare()
  }

  private func handleShare() {
    guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
          let attachments = item.attachments else {
      print("⚠️ 공유 항목 없음")
      finish()
      return
    }

    for provider in attachments {
      // 우선 URL 시도
      if provider.hasItemConformingToTypeIdentifier("public.url") {
        provider.loadItem(forTypeIdentifier: "public.url", options: nil) { data, error in
          if let url = data as? URL {
            print("🌐 공유된 URL:", url.absoluteString)
          } else {
            print("❌ URL 파싱 실패:", data ?? "nil")
          }
          self.finish()
        }
        return
      }

      // 텍스트도 처리
      if provider.hasItemConformingToTypeIdentifier("public.text") {
        provider.loadItem(forTypeIdentifier: "public.text", options: nil) { data, error in
          if let text = data as? String {
            print("📝 공유된 텍스트:", text)
          } else {
            print("❌ 텍스트 파싱 실패:", data ?? "nil")
          }
          self.finish()
        }
        return
      }
    }

    // 둘 다 해당 안 될 경우
    print("⚠️ 공유 가능한 항목 없음")
    finish()
  }

  private func finish() {
    DispatchQueue.main.async {
      self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
  }
}
