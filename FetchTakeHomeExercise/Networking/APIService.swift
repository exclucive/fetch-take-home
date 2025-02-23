//
//  APIService.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/20/25.
//

import Foundation

enum APIServiceErrors: Error {
    case invalidURL
    case invalidResponse
    case invalidJSON
}

protocol APIService {
    func load<T: Decodable>(_ apiRequest: APIRequest) async throws -> T
}

final class APIServiceImp: APIService {
    private typealias Response = (data: Data, urlResponse: URLResponse)
    private enum Constants {
        static let baseURL: String = "https://d3jbb8n5wk0qxi.cloudfront.net/"
    }
    
    // MARK: - Properties
    private let session: URLSession
    private let baseURL: String
    
    // MARK: - Initializer
    init(baseURL: String = Constants.baseURL,
         sessionConfig: URLSessionConfiguration = .default
    ) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: sessionConfig)
    }
    
    // MARK: - Methods
    func load<T: Decodable>(_ apiRequest: APIRequest) async throws -> T {
        // Prep URL
        guard let baseURL = URL(string: baseURL),
              let requestUrl = URL(string: apiRequest.endpoint, relativeTo: baseURL) else {
            throw APIServiceErrors.invalidURL
        }
        
        // Prep request
        var urlRequest: URLRequest = .init(url: requestUrl, timeoutInterval: apiRequest.timeoutInterval)
        urlRequest.httpMethod = apiRequest.httpMethod.rawValue
        
        // Send request
        let response: Response = try await session.data(for: urlRequest)
        
        // Check response for errors
        guard let httpResponse = response.urlResponse as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIServiceErrors.invalidResponse
        }
        
        // Parse JSON
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = apiRequest.decodingStrategy.key
        
        do {
            return try jsonDecoder.decode(T.self, from: response.data)
        } catch {
            throw APIServiceErrors.invalidJSON
        }
    }
}
