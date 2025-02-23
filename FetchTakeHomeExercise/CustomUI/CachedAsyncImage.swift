//
//  CachedAsyncImage.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/19/25.
//

import Foundation
import SwiftUI


public struct CachedAsyncImage: View {
    @State private var image: UIImage?
    private let url: URL?
    private let fileManager = FileManager()
    
    public init(url: URL?) {
        self.url = url
    }
    
    public var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .task(loadImage)
            }
        }
    }
    
    
    @Sendable
    func loadImage() async  {
        guard let url else { return }
        let key = url.absoluteString.sha256
        
        // First check the cache
        if let cachedImage = fileManager.loadImageFromDisk(forKey: key) {
            image = cachedImage
            return
        }
        
        // If not, try to create a URL from the urlString.
        do {
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let uiImage = UIImage(data: data) {
                image = uiImage
                fileManager.saveImageToDisk(image: uiImage, forKey: key)
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }

}
