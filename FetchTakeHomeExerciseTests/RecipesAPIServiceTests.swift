//
//  RecipesAPIServiceTests.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/21/25.
//

import Foundation
@testable import FetchTakeHomeExercise
import XCTest

final class RecipesAPIServiceTests: XCTestCase {
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
    
    func testLoadRecipes() async throws {
        // GIVEN
        let expectedData = try loadTestJSON(named: "RecipesJSON")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedData)
        }
        
        // WHEN
        let service: RecipesAPIService = RecipesAPIServiceImp(apiService: apiService)
        let recipes = try? await service.loadRecipes(sortByName: false)
        
        // THEN
        XCTAssertEqual(recipes?.count, 63)
    }
    
    func testLoadRecipesSortedAlphabetically() async throws {
        // GIVEN
        let expectedData = try loadTestJSON(named: "RecipesJSON")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedData)
        }

        let service: RecipesAPIService = RecipesAPIServiceImp(apiService: apiService)

        // WHEN
        let recipes = try await service.loadRecipes(sortByName: true)
        
        // THEN
        let firstRecipe = try XCTUnwrap(recipes?.first, "Expected at least one recipe, but got nil")
        XCTAssertEqual(firstRecipe.name, "Apam Balik")
    }
    
    func testLoadRecipesMalformed() async throws {
        // GIVEN
        let malformedData = try loadTestJSON(named: "MalformedRecipesJSON")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, malformedData)
        }

        let service: RecipesAPIService = RecipesAPIServiceImp(apiService: apiService)

        // WHEN & THEN
        do {
            _ = try await service.loadRecipes(sortByName: true)
            XCTFail("Expected an error to be thrown, but no error was thrown")
        } catch {
            let error = error as? APIServiceErrors
            XCTAssertTrue(error == .invalidJSON)
        }
    }
}

extension RecipesAPIServiceTests {
    private func loadTestJSON(named fileName: String) throws -> Data {
        let bundle = Bundle(for: RecipesAPIServiceTests.self)
        
        let fileURL = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: "json"),
                                    "Can't find \(fileName).json in the test bundle")
        
        return try Data(contentsOf: fileURL)
    }
}
