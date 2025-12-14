//
//  NetworkService.swift
//  fitness_assistant
//
//  Base network service for API requests
//

import Foundation


struct MessageResponse: Codable {
    let message: String
}

struct ErrorResponse: Codable {
    let detail: String
}


struct NetworkConfig {
    let baseURL: String
    let timeout: TimeInterval
    
    static let development = NetworkConfig(
        baseURL: "http://localhost:8000/api/v1",
        timeout: 30.0
    )
    
    static let production = NetworkConfig(
        baseURL: "https://api.yourapp.com/api/v1",
        timeout: 30.0
    )
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(String)
    case unauthorized
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let message):
            return message
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}



class NetworkService {

    static let shared = NetworkService()
    
    let config: NetworkConfig
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
 
    init(config: NetworkConfig = .development) {
        self.config = config
    }
    

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil,
        requiresAuth: Bool = false
    ) async throws -> T {
        return try await performRequest(
            endpoint: endpoint,
            method: method,
            body: body,
            requiresAuth: requiresAuth
        )
    }
    

    func request(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil,
        requiresAuth: Bool = false
    ) async throws {
        let _: MessageResponse = try await performRequest(
            endpoint: endpoint,
            method: method,
            body: body,
            requiresAuth: requiresAuth
        )
    }
    

    private func performRequest<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable?,
        requiresAuth: Bool
    ) async throws -> T {
        guard let url = URL(string: "\(config.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = config.timeout
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        

        if requiresAuth, let accessToken = KeychainService.shared.getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        

        if let body = body {
            do {
                request.httpBody = try encoder.encode(body)
                #if DEBUG
                if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
                    print("📤 Request to \(endpoint): \(jsonString)")
                }
                #endif
            } catch {
                throw NetworkError.decodingError(error)
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            

            #if DEBUG
            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 Response (\(httpResponse.statusCode)): \(responseString)")
            }
            #endif
            
            switch httpResponse.statusCode {
            case 200...299:
   
                if T.self == MessageResponse.self {

                    if data.isEmpty {
                        if let defaultResponse = MessageResponse(message: "Success") as? T {
                            return defaultResponse
                        }
                    }
                    do {
                        return try decoder.decode(T.self, from: data)
                    } catch {
      
                        if let defaultResponse = MessageResponse(message: "Success") as? T {
                            return defaultResponse
                        }
                        throw NetworkError.decodingError(error)
                    }
                } else {

                    do {
                        return try decoder.decode(T.self, from: data)
                    } catch let decodingError as DecodingError {
                        print("❌ Decoding error: \(decodingError)")
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("📄 JSON: \(jsonString)")
                        }
                        throw NetworkError.decodingError(decodingError)
                    } catch {
                        throw NetworkError.decodingError(error)
                    }
                }
                
            case 401:
                throw NetworkError.unauthorized
                
            case 400...499:
                if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                    throw NetworkError.serverError(errorResponse.detail)
                } else if let responseString = String(data: data, encoding: .utf8) {
                    throw NetworkError.serverError(responseString)
                } else {
                    throw NetworkError.serverError("Ошибка клиента: \(httpResponse.statusCode)")
                }
                
            case 500...599:
                throw NetworkError.serverError("Ошибка сервера: \(httpResponse.statusCode)")
                
            default:
                throw NetworkError.serverError("Неожиданный статус код: \(httpResponse.statusCode)")
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
