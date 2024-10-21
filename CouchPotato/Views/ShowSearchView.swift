//
//  ShowSearchView.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/24/24.
//

import SwiftUI

struct ShowSearchResultView: View {
    var show: TvShow
    
    var body: some View {
        NavigationLink(destination: ShowDetailView(show: show)) {
            HStack {
                if let image = show.image {
                    AsyncImage(url: image.url) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .scaledToFit()
                    .frame(width: 50)
                    .clipShape(.rect(cornerRadius: 5))
                    .shadow(radius: 5)
                }
                
                VStack(alignment: .leading) {
                    Text("\(show.name)")
                    if let network = show.network {
                        Text(network.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text("\(show.genres.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct ShowSearchView: View {
    @State private var searchQuery: String = ""
    @State private var shows: [TvShow] = []
    
    let navigationTitle: String = "Search"
    
    @State var textColor: Color = .primary
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Search for a TV show...", text: $searchQuery)
                        .onChange(of: searchQuery) {
                            TvMazeApiService.searchForShow(query: searchQuery) { result in
                                switch (result) {
                                    case .success(let result):
                                        shows = result
                                        textColor = .primary
                                    case .failure:
                                        textColor = .red
                                }
                            }
                        }
                        .foregroundColor(textColor)
                }
                
                ForEach(shows, id: \.id) { show in
                    ShowSearchResultView(show: show)
                }
            }
            .navigationTitle(navigationTitle)
        }
    }
}
