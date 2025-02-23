//
//  APIRequestTests.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/21/25.
//

import Foundation
@testable import FetchTakeHomeExercise
import XCTest

final class APIRequestTests: XCTestCase {
    func testInitWithCustomValues() {
        // GIVEN
        let request: APIRequest = APIRequestImp(endpoint: "/test",
                                                httpMethod: .post,
                                                timeoutInterval: 30,
                                                decodingStrategy: .convertFromSnakeCase)
        
        // THEN
        XCTAssertEqual(request.endpoint, "/test")
        XCTAssertEqual(request.httpMethod, .post)
        XCTAssertEqual(request.timeoutInterval, 30)
        XCTAssertEqual(request.decodingStrategy, DecodingStrategy.convertFromSnakeCase)
    }

    func testInitWithDefaultValues() {
        // GIVEN
        let request: APIRequest = APIRequestImp(endpoint: "/defaultEndpoint")

        // THEN
        XCTAssertEqual(request.endpoint, "/defaultEndpoint")
        XCTAssertEqual(request.httpMethod, .get)
        XCTAssertEqual(request.timeoutInterval, 60)
        XCTAssertEqual(request.decodingStrategy, DecodingStrategy.default)
    }
}
