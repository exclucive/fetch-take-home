//
//  FetchTakeHomeExerciseApp.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/17/25.
//

import SwiftUI

@main
struct FetchTakeHomeExerciseApp: App {
    var body: some Scene {
        WindowGroup {
            let apiService: APIService = APIServiceImp()
            let recipesService: RecipesAPIService = RecipesAPIServiceImp(apiService: apiService)
            RecipesListView(recipesService: recipesService)
        }
    }
}
