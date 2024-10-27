//
//  MyShowsView.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/30/24.
//

import SwiftUI

// if there are no tracked shows, this will be shown
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
    @EnvironmentObject var favoritedShowsManager: FavoritedShowsManager
    
    private let navigationTitle: String = "My Shows"
    
    var body: some View {
        NavigationStack {
            VStack {
                if favoritedShowsManager.trackedShows.isEmpty {
                    NoTrackedShowsView()
                } else {
                    List {
                        ForEach(favoritedShowsManager.trackedShows, id: \.id) { show in
                            NavigationLink(destination: ShowDetailView(show: show)) {
                                FavoriteShowsRowView(show: show)
                            }
                        }
                        .onDelete { indices in
                            // remove show from the list
                            favoritedShowsManager.trackedShows.remove(atOffsets: indices)
                        }
                        .onMove { source, dest in
                            // move show from one spot to another in the array
                            favoritedShowsManager.trackedShows.move(fromOffsets: source, toOffset: dest)
                        }
                    }
                    .toolbar {
                        EditButton() // show an edit button in the toolbar
                    }
                }
            }
            .navigationTitle(navigationTitle)
        }
    }
}
