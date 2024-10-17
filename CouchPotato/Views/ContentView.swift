//
//  ContentView.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tvMazeService: TvMazeApiService
    
    var body: some View {
        TabView {
            Tab("My Shows", systemImage: "film.stack") {
                MyShowsView()
            }
            
            Tab("Search Shows", systemImage: "magnifyingglass") {
                ShowSearchView()
            }
        }
    }
}

#Preview {
    ContentView()
}
