//
//  MusicItem.swift
//  AppleSearch2
//
//  Created by Kristin Samuels  on 6/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation

struct MusicTopLevelDictionay: Codable {
    
    let results: [MusicTrack]
}

struct MusicTrack: Codable {
    
    let trackName: String
    let artistName: String
    // optional, could not exisit, nil 
    let artworkUrl100: URL?
}

/*
 { Music Top Level
 results: [
        
        {  Music Track
 
        trackName: "something"
        artistName: "soemthing"
        artworkUrl100: "something.jpg"
 
        }
        {  Music Track
        }
        {  Music Track
        }
 
    ]
    
 }
 
 */
