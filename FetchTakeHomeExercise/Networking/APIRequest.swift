//
//  APIRequest.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/20/25.
//

import Foundation

protocol APIRequest {
    var endpoint: String { get }
    var httpMethod: HTTPMethod { get }
    var timeoutInterval: TimeInterval { get }
    var decodingStrategy: DecodingStrategy { get }
    
    init(endpoint: String,
         httpMethod: HTTPMethod,
         timeoutInterval: TimeInterval,
         decodingStrategy: DecodingStrategy)
}

struct APIRequestImp: APIRequest {
    let endpoint: String
    let httpMethod: HTTPMethod
    let timeoutInterval: TimeInterval
    let decodingStrategy: DecodingStrategy
    
    init(endpoint: String,
         httpMethod: HTTPMethod = .get,
         timeoutInterval: TimeInterval = 60,
         decodingStrategy: DecodingStrategy = .default) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.timeoutInterval = timeoutInterval
        self.decodingStrategy = decodingStrategy
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum DecodingStrategy: Int, Equatable {
    case convertFromSnakeCase
    case `default`
    
    var key: JSONDecoder.KeyDecodingStrategy {
        switch self {
        case .convertFromSnakeCase:
            return .convertFromSnakeCase
        case .default:
            return .useDefaultKeys
            
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
