//
//  TvMazeService.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/24/24.
//

import Foundation
import SwiftUI


@MainActor class TvMazeApiService: ObservableObject {
    private let baseURL: String = "https://api.tvmaze.com"
    
    func searchForShow(query: String, completion: @escaping (Result<[TvShow], Error>) -> Void) {
        guard let queryURL = URL(string: "\(baseURL)/search/shows?q=\(query)") else {
            return
        }
        
        let request = URLRequest(url: queryURL)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode([TvSearchResult].self, from: data)
                    let shows = result.map { $0.show }
                    
                    completion(.success(shows))
                } catch (let error) {
                    if let url = request.url {
                        print("error: request url: \(url)")
                    }
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
