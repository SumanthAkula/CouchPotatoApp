//
//  EpisodeListView.swift
//  CouchPotato
//
//  Created by Sumo Akula on 10/27/24.
//

import SwiftUI

struct EpisodeListView: View {
    @State var episodes: [Int : [TvEpisode]]
    
    init(episodes: [Int : [TvEpisode]]) {
        self.episodes = episodes
        
        print(episodes)
    }
    
    var body: some View {
        Text("\(episodes.count)")
        List {
            ForEach(self.episodes.sorted {$0.key < $1.key }, id: \.key) { element in
                Section("\(element.key)") {
                    ForEach (element.value, id: \.id) { episode in
                        Text(episode.name)
                    }
                }
            }
        }
    }
}
