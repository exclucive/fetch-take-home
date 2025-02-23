//
//  Untitled.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/20/25.
//

import SwiftUI
import Combine

enum ViewState {
    case loading
    case error(String)
    case empty
    case loaded([Recipe])
}

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published var state: ViewState = .loading

    private let recipesService: RecipesAPIService

    init(recipesService: RecipesAPIService) {
        self.recipesService = recipesService
    }

    func loadRecipes(sortByName: Bool = false) async {
        state = .loading
        do {
            let fetchedRecipes = try await recipesService.loadRecipes(sortByName: sortByName) ?? []
            state = fetchedRecipes.isEmpty ? .empty : .loaded(fetchedRecipes)
        } catch {
            state = .error("Failed to load recipes: \(error.localizedDescription)")
        }
    }
}
