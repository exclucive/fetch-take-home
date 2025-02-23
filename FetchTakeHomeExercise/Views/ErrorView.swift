//
//  ErrorView.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/23/25.
//

import SwiftUI

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
