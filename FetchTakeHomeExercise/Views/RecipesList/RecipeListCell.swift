//
//  File.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/23/25.
//

import SwiftUI

struct RecipeListCell: View {
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
                Text("Name: \(recipe.name)")
                    .fontWeight(.regular)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(.secondary)
                Text("Cuisine: \(recipe.cuisine)")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
    }
}
