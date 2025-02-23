//
//  String+Hash.swift
//  FetchTakeHomeExercise
//
//  Created by Igor on 2/22/25.
//

import CryptoKit
import Foundation

extension String {
    var sha256: String {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
