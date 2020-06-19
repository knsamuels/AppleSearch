//
//  AppItem.swift
//  AppleSearch2
//
//  Created by Kristin Samuels  on 6/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation

struct AppTopLevelDictionary: Codable {
    
    let results: [AppItem]
}

struct AppItem: Codable {
    let trackName: String
    let description: String
    let artworkUrl100: URL?
}
