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
    
    static func ==(lhs: ShowSchedule, rhs: ShowSchedule) -> Bool {
        return lhs.time == rhs.time && lhs.days == rhs.days
    }
}

struct ShowRating: Codable {
    let average: Double?
    
    static func ==(lhs: ShowRating, rhs: ShowRating) -> Bool {
        return lhs.average == rhs.average
    }
}

struct TvNetwork: Codable {
    let id: Int
    let name: String
    let country: TvCountry
    let officialSite: String?
    
    static func ==(lhs: TvNetwork, rhs: TvNetwork) -> Bool {
        return lhs.id == rhs.id
    }
}

struct TvCountry: Codable {
    let name: String
    let code: String
    let timezone: String
    
    static func ==(lhs: TvCountry, rhs: TvCountry) -> Bool {
        return lhs.code == rhs.code
    }
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
    
    static func ==(lhs: TvShow, rhs: TvShow) -> Bool {
        return lhs.id == rhs.id
    }
}

struct TvSearchResult: Codable {
    let score: Double
    let show: TvShow
}

struct TvEpisode: Codable {
    let id: Int
    let name: String
    let season: Int
    let number: Int?
    let airstamp: Date?
    let runtime: Int?
    let rating: ShowRating
    let image: TvImageUrl?
    let summary: String?
}

struct TvEmbeddings: Codable {
    let previousEpisode: TvLink?
    let nextEpisode: TvLink?
    
    enum CodingKeys: String, CodingKey {
        case previousEpisode = "previousepisode"
        case nextEpisode = "nextepisode"
    }
}

struct TvLink: Codable {
    let name: String?
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case link = "href"
    }
}
