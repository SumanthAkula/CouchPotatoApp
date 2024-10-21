//
//  TvMazeService.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/24/24.
//

import Foundation
import SwiftUI


class TvMazeApiService {
    private static let baseURL: String = "https://api.tvmaze.com"
    
    static func getEpisode(link: String, completion: @escaping (Result<TvEpisode, Error>) -> Void) {
        guard let url = URL(string: link) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    let result = try decoder.decode(TvEpisode.self, from: data)
                    completion(.success(result))
                } catch (let error) {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    static func getEpisode(id: Int) {
        return
    }
    
    static func getEpisodes(for show: TvShow, completion: @escaping (Result<[TvEpisode], Error>) -> Void) {
        guard let queryURL = URL(string: "\(baseURL)/shows/\(show.id)/episodes?specials=1") else {
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
                decoder.dateDecodingStrategy = .iso8601
            
                do {
                    let result = try decoder.decode([TvEpisode].self, from: data)
                    completion(.success(result))
                } catch (let error) {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    static func searchForShow(query: String, completion: @escaping (Result<[TvShow], Error>) -> Void) {
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
