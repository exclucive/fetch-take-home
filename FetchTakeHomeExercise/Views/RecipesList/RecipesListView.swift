//
//  ContentView.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/17/25.
//

import SwiftUI

struct RecipesListView: View {
    @StateObject private var viewModel: RecipesViewModel
    
    init(recipesService: RecipesAPIService) {
        _viewModel = StateObject(wrappedValue: RecipesViewModel(recipesService: recipesService))
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
                        RecipeRow(recipe: recipe)
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

struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let photoURL = recipe.photoURLSmall,
               let url = URL(string: photoURL) {
                CachedAsyncImage(url: url)
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(12)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Cuisine: \(recipe.cuisine)")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text("Name: \(recipe.name)")
                    .fontWeight(.regular)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.5))
            Text("No recipes to show 😔")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.red.opacity(0.7))
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
            Button(action: retryAction) {
                Text("Try Again")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    let apiService: APIService = APIServiceImp()
    let recipesService: RecipesAPIService = RecipesAPIServiceImp(apiService: apiService)
    RecipesListView(recipesService: recipesService)
}
