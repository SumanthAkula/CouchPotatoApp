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
            VStack(alignment: .leading) {
                Text("\(show.name)")
                Text("\(show.url)")
                    .font(.caption)
            }
        }
    }
}

struct ShowSearchView: View {
    @EnvironmentObject var tvMazeService: TvMazeApiService
    
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
                            tvMazeService.searchForShow(query: searchQuery) { result in
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
                        .contextMenu {
                            ShowDetailView(show: show)
                        }
                }
            }
            .navigationTitle(navigationTitle)
        }
    }
}
