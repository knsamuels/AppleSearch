//
//  EntityTableViewCell.swift
//  AppleSearch2
//
//  Created by Kristin Samuels  on 6/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class EntityTableViewCell: UITableViewCell {

    @IBOutlet var artistDescriptionLabel: UILabel!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var artworkImageView: UIImageView!
    
    // Landing pads for musicTrack and appItem (In theory, only  one of these should have a value at any given time 
    var musicTrack: MusicTrack?
    var appItem: AppItem?
    
    // called by cellForRow at once a musicTrack or appItem has been set
    func updateViews() {
       
        // placeholder for a URL
        var url: URL?
        
        // updates views and url placeholder based on musicTrack info
        if let musicTrack = musicTrack {
            trackNameLabel.text = musicTrack.trackName
            artistDescriptionLabel.text = musicTrack.artistName
            url = musicTrack.artworkUrl100
        
            // Updates view and url placeholder on appIte info (if app was set)
        } else if let appItem = appItem {
            trackNameLabel.text = appItem.trackName
            artistDescriptionLabel.text = appItem.description
            url = appItem.artworkUrl100
        }
        
        // Resetting image to nil incase we don't have an image URL for a given musicTrack or appItem 
        self.artworkImageView.image = nil
        
        if let url = url {
            AppleStoreItemController.fetchImageFrom(url: url) { (result) in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        // Reenter main thread and set the artworkImageVIew.image to the image we fetched 
                        self.artworkImageView.image = image
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
//        } else {
//            self.artworkImageView.image = #imageLiteral(resourceName: <#T##String#>)
        }
    }
}
