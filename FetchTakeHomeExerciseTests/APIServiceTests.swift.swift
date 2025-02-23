//
//  APIServiceTests.swift.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/21/25.
//

import Foundation
@testable import FetchTakeHomeExercise
import XCTest

final class APIServiceTests: XCTestCase {
    private var apiService: APIService!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        apiService = APIServiceImp(sessionConfig: config)
    }
    
    override func tearDown() {
        apiService = nil
        MockURLProtocol.requestHandler = nil
        MockURLProtocol.error = nil
        super.tearDown()
    }
    
    func testLoadSuccessfulResponse() async throws {
        // GIVEN
        let expectedData =
        """
            {
                "uuid": "1234querty",
                "name": "Food 1",
                "cuisine": "Brazilian"
            }
        """
            .data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedData)
        }
        
        struct MockResponse: Decodable {
            let uuid: String
            let name: String
            let cuisine: String
        }
        
        let apiRequest: APIRequest = APIRequestImp(endpoint: "/get-name", httpMethod: .get)
        
        // WHEN
        let response: MockResponse = try await apiService.load(apiRequest)
        
        // THEN
        XCTAssertEqual(response.uuid, "1234querty")
        XCTAssertEqual(response.name, "Food 1")
        XCTAssertEqual(response.cuisine, "Brazilian")
    }
    
    func testLoadInvalidJSON() async throws {
        // GIVEN
        let expectedData =
        """
            {
                "uuid": "1234querty",
                "name": "Food 1",
                "cuisine": "Brazilian"
            }
        """
            .data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedData)
        }
        
        struct MockResponse: Decodable {
            let _uuid: String
            let _name: String
            let _cuisine: String
        }
        
        let apiRequest: APIRequest = APIRequestImp(endpoint: "/get-name", httpMethod: .get)
        
        do {
            // WHEN
            let _: MockResponse = try await apiService.load(apiRequest)
            
            // THEN
            XCTFail("Expected an invalidResponse")
        } catch let error as APIServiceErrors {
            
            // THEN
            XCTAssertEqual(error, .invalidJSON)
        } catch {
            
            // THEN
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testLoadInvalidResponse() async throws {
        // GIVEN
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        
        struct MockResponse: Decodable {}
        
        let apiRequest: APIRequest = APIRequestImp(endpoint: "/invalidURL", httpMethod: .get)
        
        do {
            // WHEN
            let _: MockResponse = try await apiService.load(apiRequest)
            
            // THEN
            XCTFail("Expected an invalidResponse")
        } catch let error as APIServiceErrors {
            
            // THEN
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            
            // THEN
            XCTFail("Unexpected error: \(error)")
        }
    }
}
