//
//  EntityListTableViewController.swift
//  AppleSearch2
//
//  Created by Kristin Samuels  on 6/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class EntityListTableViewController: UITableViewController {

    @IBOutlet var entitySegmentedControl: UISegmentedControl!
    @IBOutlet var itunesSearchBar: UISearchBar!
    
    // We created 2 potentail Source of Truths to handle our data depending on weather the data is MusicTracks or AppItems
    var musicItems: [MusicTrack] = []
    var appItems: [AppItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // set searchbar delegate in order to access searchbar methods
        itunesSearchBar.delegate = self 
    }

    // Re- search data after segmented control value changed
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        search()
        
    }
    // calling fetch functiond depending on which segment we are on
    func search() {
        // make sure user entered something into the search bar, else exit function
        guard let searchTerm = itunesSearchBar.text, !searchTerm.isEmpty else { return }
        // if music tab us selected, fetch our music tracks
        if entitySegmentedControl.selectedSegmentIndex == 0 {
            AppleStoreItemController.fetchMusicItems(searchTerm: searchTerm) { (result) in
                switch result {
                case .success (let musicTracks):
                    // set our musicTracks (one of our Sources of Truth) to the musicTracks we fetched
                    self.musicItems = musicTracks
                    DispatchQueue.main.async {
                        // because this is an UI change , it needs to be on the main thread - which means it needs to be inside a dispatchQueue.main.async 
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            // if appTap is selected, fetch our Apps
        } else {
            AppleStoreItemController.fetchAppItems(searchTerm: searchTerm) { (result) in
                switch result {
                case .success(let apps):
                    self.appItems = apps
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch entitySegmentedControl.selectedSegmentIndex {
        case 0:
            return self.musicItems.count
        case 1:
            return self.appItems.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entityCell", for: indexPath) as? EntityTableViewCell else {return UITableViewCell()}
        // determin if we are on music tab or app tab
        switch entitySegmentedControl.selectedSegmentIndex {
            // Get the info for the cell if we are on music tab and set cells musicTrack property
        case 0:
            let track = musicItems[indexPath.row]
            cell.musicTrack = track
            cell.appItem = nil
            // Get the info for the cell if we are on app tab and set cells appItem property
        case 1:
            let app = appItems[indexPath.row]
            cell.musicTrack = nil
            cell.appItem = app
        default:
            break 
        }
        // call the cells update views function to update the views with our musicTrack or appItem (depending on which was sent)
        cell.updateViews()
        
        return cell
    }
}

extension EntityListTableViewController: UISearchBarDelegate {
    // Tell our EntityListTableViewController what to do when the user clicks search (or hits enter) - We are telling it to run its search function 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
}
