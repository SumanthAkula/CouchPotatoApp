//
//  TvStateManager.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/30/24.
//

import SwiftUI

class TvStateManager: ObservableObject {
    @Published var trackedShows: [TvShow] {
        didSet {
            let data = try! JSONEncoder().encode(trackedShows)
            UserDefaults.standard.set(data, forKey: "tracked_shows")
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "tracked_shows") {
            self.trackedShows = try! JSONDecoder().decode([TvShow].self, from: data)
        } else {
            self.trackedShows = []
        }
    }
    
    func track(show target: TvShow) {
        if !trackedShows.contains(where: { $0.id == target.id }) {
            trackedShows.append(target)
        }
    }
    
    func untrack(show target: TvShow) {
        trackedShows.removeAll { $0.id == target.id }
    }
}
