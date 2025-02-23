//
//  FileManager+Fetch.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/22/25.
//

import UIKit

extension FileManager {
    func saveImageToDisk(image: UIImage, forKey key: String) {
        guard let data = image.pngData() else { return }
        let url = getImageCacheDirectory().appendingPathComponent(key)
        try? data.write(to: url)
    }

    func loadImageFromDisk(forKey key: String) -> UIImage? {
        let url = getImageCacheDirectory().appendingPathComponent(key)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }

    private func getImageCacheDirectory() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let cacheDirectory = documentsDirectory.appendingPathComponent("ImageCache", isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating cache directory: \(error)")
            }
        }
        
        return cacheDirectory
    }

}
