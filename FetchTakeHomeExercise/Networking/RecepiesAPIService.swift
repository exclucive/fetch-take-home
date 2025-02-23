//
//  RecipeAPIService.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/20/25.
//

import Foundation

protocol RecipesAPIService {
    // Methods
    @discardableResult
    func loadRecipes(sortByName: Bool) async throws -> [Recipe]?
}

final class RecipesAPIServiceImp: RecipesAPIService {
    private enum Endoints: String {
        case getRecipes = "/recipes.json"
//        case getRecipes = "/recipes-malformed.json"
//        case getRecipes = "/recipes-empty.json"
    }
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    @discardableResult
    func loadRecipes(sortByName: Bool) async throws -> [Recipe]? {
        let apiRequest: APIRequest = APIRequestImp(endpoint: Endoints.getRecipes.rawValue)
        let response: RecipeResponse = try await apiService.load(apiRequest)
        let recipes = sortByName ? response.recipes.sorted { $0.name < $1.name } : response.recipes
        
        return recipes
    }
}
