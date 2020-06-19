//
//  AppleStoreError.swift
//  AppleSearch2
//
//  Created by Kristin Samuels  on 6/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation


// creating an enum for out app's custom error and conforming it to the localized error
enum AppleStoreError: LocalizedError {
    // Create our possible error cases
    case invaildURL
    case thrownError(Error)
    case noData
    case unableToDecode(Error)
    case unableToDecodeImage
    // create our custom error messages for each error case
    var errorDescription: String? {
        switch self {
        case .invaildURL:
            return "The server failed to reach the necessary URL"
        case .thrownError(let error):
            return "There was an error: \(error.localizedDescription)"
        case .noData:
            return "There was no date found"
        case .unableToDecode(let error):
            return "\(error) There was an error when"
        case .unableToDecodeImage:
            return "Unable to get the image for the store item"
        }
    }
}
