//
//  AppleStoreItemController.swift
//  AppleSearch2
//
//  Created by Kristin Samuels  on 6/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
// https://itunes.apple.com/search?term=jack+johnson&entity=software

// create StringConstants struct to store all strings that we need to use in our API calls
struct StringConstants {
    fileprivate static let baseURLString = "https://itunes.apple.com"
    fileprivate static let searchComponent = "search"
    fileprivate static let searchQueryName = "term"
    fileprivate static let entityQueryName = "entity"
    fileprivate static let musicEntityQueryValue = "musicTrack"
    fileprivate static let appEntityQueryValue = "software"
    
}
class AppleStoreItemController {
    
    static func fetchMusicItems(searchTerm: String, completion: @escaping (Result<[MusicTrack], AppleStoreError>) -> Void) {
    
        // Part 1 Build out URL
        // Step 1 - Guard to make sure base URL exists, else exit function and complete with an error
        //https://itunes.apple.com
        guard let baseURL = URL(string: StringConstants.baseURLString) else {return completion(.failure(.invaildURL))}
        // Step 2 - Add Componets (folders) to our baseURL
        //https://itunes.apple.com/search
        let searchURL = baseURL.appendingPathComponent(StringConstants.searchComponent)
       
        // Step 3 - Create a local variable called components (or whatever you want) of type URLComponents, and pass in our searchURL
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        
        // Step 4 - Create our query items
        let searchQuery = URLQueryItem(name: StringConstants.searchQueryName, value: searchTerm)
        let entityQuery = URLQueryItem(name: StringConstants.entityQueryName, value: StringConstants.musicEntityQueryValue)
        
        // Step 5 - Add our quesry items to our local components variable
        components?.queryItems = [searchQuery, entityQuery]
        
        // Step 6 - Get our finalURL from the url on our componeents (with the added query items)
        //https://itunes.apple.com/search?term=Coldplay&entity=musicTrack
        guard let finalURL = components?.url else {return completion(.failure(.invaildURL))}
       
        //Step 7 - Always print URL so you can copy from debugger and check in postman for expented data
        print(finalURL)
        
        // Part 2 Run URLSession dataTask with built out URL (finalURL)
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            //Step 1 Handle possible errors and return and complete with a failure and custom error
            // Takes us off the main thread 
            if let error = error  {
                return completion(.failure(.thrownError(error)))
            }
            // Step 2 - Check to make sure our data is not nil, else we will return and complete with a failure and custom error
            guard let data = data else {return completion(.failure(.noData))}
            // Step 3 - Turn our data into the object(s) we want
            do {
                // Step 3.1 - Decode our data from the top level
                let topLevelTopDict = try JSONDecoder().decode(MusicTopLevelDictionay.self, from: data)
                //Unneccessary Step 3.2 Create varaible to store top level topLevelTopDict's results array
                let musicItems = topLevelTopDict.results
                // Step 3.2 Return out of the function and complete with success, passing through our array of music items
                return completion(.success(musicItems))
            } catch {
                // Step 4 Handle errors if one occured while trying to decode the data
                return completion(.failure(.unableToDecode(error)))
            } // Step 5 - MAKE SURE WE HAVE .resume() at the end of our dataTask function
        }.resume()
    }
    
    
    static func fetchAppItems(searchTerm: String, completion: @escaping (Result<[AppItem], AppleStoreError>) -> Void) {
        guard let baseURL = URL(string: StringConstants.baseURLString) else {return completion(.failure(.invaildURL))}
        let searchURL = baseURL.appendingPathComponent(StringConstants.searchComponent)
       
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        
        let searchQuery = URLQueryItem(name: StringConstants.searchQueryName, value: searchTerm)
        let entityQuery = URLQueryItem(name: StringConstants.entityQueryName, value: StringConstants.appEntityQueryValue)
       
        components?.queryItems = [searchQuery, entityQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invaildURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error  {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                
                let topLevelTopDict = try JSONDecoder().decode(AppTopLevelDictionary.self, from: data)
                let appItems = topLevelTopDict.results
                return completion(.success(appItems))
            } catch {
                return completion(.failure(.unableToDecode(error)))
            }
        }.resume()
    }
    
    static func fetchImageFrom(url: URL, completion: @escaping (Result<UIImage, AppleStoreError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecodeImage))}
            
            completion(.success(image))
            
        }.resume()
    }
}

