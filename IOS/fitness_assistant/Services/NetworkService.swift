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
        
        // Custom date decoding strategy to handle multiple date formats
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            // Try different date formats
            let formatters = [
                // ISO8601 with microseconds: "2025-12-18T21:03:57.732371Z"
                "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ",
                // ISO8601 with milliseconds: "2025-12-18T21:03:57.732Z"
                "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                // ISO8601 standard: "2025-12-18T21:03:57Z"
                "yyyy-MM-dd'T'HH:mm:ssZ",
                // Simple date: "2025-12-19"
                "yyyy-MM-dd"
            ]
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            for format in formatters {
                dateFormatter.dateFormat = format
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string: \(dateString)"
            )
        }
        
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

// MARK: - API Extensions

extension NetworkService {

    // MARK: - Workout Plans


    func getTodaysPlan() async throws -> TodaysPlanResponse {
        let endpoint = "/workout-plans/today"
        return try await get(endpoint: endpoint)
    }

    func getExerciseCategories() async throws -> [IOSCategoryResponse] {
        let endpoint = "/exercises/ios/categories"
        return try await get(endpoint: endpoint, requiresAuth: false)
    }

    func getExercisesByCategory(categoryName: String) async throws -> [CategorizedExerciseResponse] {
        let endpoint = "/exercises/ios/categories/\(categoryName)/exercises"
        return try await get(endpoint: endpoint, requiresAuth: false)
    }

    func addExerciseToTodaysPlan(exerciseId: Int, sets: Int, reps: Int) async throws -> TodaysPlanResponse {
        let endpoint = "/workout-plans/today/exercises"
        let body = PlanExerciseCreateRequest(
            exerciseId: exerciseId,
            sets: sets,
            reps: reps,
            orderIndex: nil
        )
        return try await post(endpoint: endpoint, body: body)
    }


    func removeExerciseFromPlan(planExerciseId: Int) async throws -> TodaysPlanResponse {
        let endpoint = "/workout-plans/exercises/\(planExerciseId)"
        return try await delete(endpoint: endpoint)
    }

    func markExerciseCompleted(planExerciseId: Int, completed: Bool) async throws -> TodaysPlanResponse {
        let endpoint = "/workout-plans/exercises/\(planExerciseId)/complete?completed=\(completed)"
        return try await patch(endpoint: endpoint, body: EmptyBody())
    }

    func getPlanByDate(_ date: Date) async throws -> TodaysPlanResponse {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        let endpoint = "/workout-plans/date/\(dateString)"
        return try await get(endpoint: endpoint)
    }

    func getUserPlans() async throws -> [UserDailyPlanResponse] {
        let endpoint = "/workout-plans"
        return try await get(endpoint: endpoint)
    }

    func getWorkoutStats() async throws -> WorkoutStats {
        let endpoint = "/stats/workout-stats"
        return try await get(endpoint: endpoint)
    }


    func getWeeklyStats() async throws -> WeeklyStats {
        let endpoint = "/stats/weekly-stats"
        return try await get(endpoint: endpoint)
    }


    func getRecentSessions(limit: Int = 10) async throws -> [WorkoutSession] {
        let endpoint = "/stats/recent-sessions?limit=\(limit)"
        return try await get(endpoint: endpoint)
    }

    func getExerciseDetail(exerciseId: Int) async throws -> ExerciseDetailResponse {
        let endpoint = "/exercises/\(exerciseId)"
        return try await get(endpoint: endpoint, requiresAuth: false)
    }
}



private struct EmptyBody: Codable {}



extension NetworkService {
    func get<T: Decodable>(endpoint: String, requiresAuth: Bool = true) async throws -> T {
        return try await request(endpoint: endpoint, method: .get, requiresAuth: requiresAuth)
    }

    func post<T: Decodable>(endpoint: String, body: Encodable, requiresAuth: Bool = true) async throws -> T {
        return try await request(endpoint: endpoint, method: .post, body: body, requiresAuth: requiresAuth)
    }

    func put<T: Decodable>(endpoint: String, body: Encodable, requiresAuth: Bool = true) async throws -> T {
        return try await request(endpoint: endpoint, method: .put, body: body, requiresAuth: requiresAuth)
    }

    func patch<T: Decodable>(endpoint: String, body: Encodable, requiresAuth: Bool = true) async throws -> T {
        return try await request(endpoint: endpoint, method: .patch, body: body, requiresAuth: requiresAuth)
    }

    func delete<T: Decodable>(endpoint: String, requiresAuth: Bool = true) async throws -> T {
        return try await request(endpoint: endpoint, method: .delete, requiresAuth: requiresAuth)
    }
}
