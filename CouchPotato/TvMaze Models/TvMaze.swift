//
//  TvMaze.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/30/24.
//

import Foundation

struct ShowSchedule: Codable {
    let time: String
    let days: [String]
}

struct ShowRating: Codable {
    let average: Double?
}

struct TvNetwork: Codable {
    let id: Int
    let name: String
    let country: TvCountry
    let officialSite: String?
}

struct TvCountry: Codable {
    let name: String
    let code: String
    let timezone: String
}

struct TvImageUrl: Codable {
    let small: String?
    let medium: String?
    let large: String?
    let original: String?
    
    var url: URL? {
        if let original = self.original {
            return URL(string: original)
        } else if let large = self.large {
            return URL(string: large)
        } else if let medium = self.medium {
            return URL(string: medium)
        } else if let small = self.small {
            return URL(string: small)
        } else {
            return nil // no url exists
        }
    }
}

struct TvShow: Identifiable, Codable {
    let id: Int
    let url: URL
    let name: String
    let type: String
    let genres: [String]
    let language: String
    let status: String
    let runtime: Int?
    let averageRuntime: Int?
    let premiered: String?
    let ended: String?
    let officialSite: String?
    let schedule: ShowSchedule
    let rating: ShowRating
    let network: TvNetwork?
    let image: TvImageUrl?
    let summary: String
}

struct TvSearchResult: Codable {
    let score: Double
    let show: TvShow
}
