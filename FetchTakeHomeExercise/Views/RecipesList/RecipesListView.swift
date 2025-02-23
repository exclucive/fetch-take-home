//
//  ContentView.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/17/25.
//

import SwiftUI

struct RecipesListView: View {
    @StateObject private var viewModel: RecipesListViewModel
    
    init(recipesService: RecipesAPIService) {
        _viewModel = StateObject(wrappedValue: RecipesListViewModel(recipesService: recipesService))
    }

    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView("Loading Recipes...")
                
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadRecipes() }
                    }
                
                case .empty:
                    EmptyStateView()
                
                case .loaded(let recipes):
                    List(recipes, id: \.uuid) { recipe in
                        RecipeListCell(recipe: recipe)
                    }
                    .refreshable {
                        await viewModel.loadRecipes()
                    }
                }
            }
            .navigationTitle("Recipes List")
            .task {
                await viewModel.loadRecipes()
            }
        }
    }
}

#Preview {
    let apiService: APIService = APIServiceImp()
    let recipesService: RecipesAPIService = RecipesAPIServiceImp(apiService: apiService)
    RecipesListView(recipesService: recipesService)
}
