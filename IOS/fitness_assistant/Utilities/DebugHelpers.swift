import Foundation

#if DEBUG
struct DebugHelpers {
    /// Логировать API запрос
    static func logAPIRequest(endpoint: String, method: String, body: Any? = nil) {
        print("📤 API Request: \(method) \(endpoint)")
        if let body = body {
            print("   Body: \(body)")
        }
    }

    /// Логировать API ответ
    static func logAPIResponse<T>(endpoint: String, response: T) {
        print("📥 API Response: \(endpoint)")
        print("   Data: \(response)")
    }

    /// Логировать ошибку API
    static func logAPIError(endpoint: String, error: Error) {
        print("❌ API Error: \(endpoint)")
        print("   Error: \(error.localizedDescription)")
    }
}
#endif