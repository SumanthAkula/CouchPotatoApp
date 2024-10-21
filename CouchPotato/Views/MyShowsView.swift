//
//  MyShowsView.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/30/24.
//

import SwiftUI

struct NoTrackedShowsView: View {
    var body: some View {
        VStack {
            Text("There are no shows currently being favorited")
                .font(.headline)
            Text("You can search for a show to add to this list")
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
        
    }
}

struct MyShowsView: View {
    @EnvironmentObject var tvStateManager: TvStateManager
    
    private let navigationTitle: String = "My Shows"
    
    var body: some View {
        NavigationStack {
            VStack {
                if tvStateManager.trackedShows.isEmpty {
                    NoTrackedShowsView()
                } else {
                    List {
                        ForEach(tvStateManager.trackedShows, id: \.id) { show in
                            NavigationLink(show.name, destination: ShowDetailView(show: show))
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
        }
    }
}
