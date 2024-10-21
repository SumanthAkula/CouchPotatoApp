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

struct FavoriteShowsRowView: View {
    @EnvironmentObject var favoritedShowsManager: FavoritedShowsManager
    
    let show: TvShow
    var notify: Bool {
        favoritedShowsManager.notificationIds[show.id] != nil
    }
    @State var nextEpisode: TvEpisode? = nil
    @State var previousEpisode: TvEpisode? = nil
    
    var body: some View {
        HStack {
            if let image = show.image {
                AsyncImage(url: image.url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .scaledToFit()
                .frame(width: 100)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 10)
                .padding(.trailing)
            }
            
            VStack(alignment: .leading) {
                Text(show.name)
                    .font(.headline)
                if let network = show.network {
                    Text(network.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if let endDateString = show.ended {
                    var date: Date {
                        let df = DateFormatter()
                        df.dateFormat = "YYYY-MM-DD"
                        return df.date(from: endDateString)!
                    }
                    Text("Ended \(timeDifferenceFormatted(date: date)) ago")
                        .font(.subheadline)
                }
                else if let next = nextEpisode?.airstamp ?? nil {
                    let formatted = timeDifferenceFormatted(date: next)
                    Text("Next episode in \(formatted)")
                        .font(.subheadline)
                } else if let prev = previousEpisode?.airstamp ?? nil {
                    let formatted = timeDifferenceFormatted(date: prev)
                    Text("Last episode \(formatted) ago")
                        .font(.subheadline)
                }
            }
            .onAppear {
                if let link = self.show._links.nextEpisode?.link {
                    TvMazeApiService.getEpisode(link: link) { result in
                        switch (result) {
                            case .success(let episode):
                                nextEpisode = episode
                            case .failure(let error):
                                print(error)
                                nextEpisode = nil
                        }
                    }
                }
                
                if let link = self.show._links.previousEpisode?.link {
                    TvMazeApiService.getEpisode(link: link) { result in
                        switch (result) {
                            case .success(let episode):
                                previousEpisode = episode
                            case .failure(let error):
                                print(error)
                                previousEpisode = nil
                        }
                    }
                }
            }
            Spacer()
            if (notify) {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func timeDifferenceFormatted(date: Date) -> String {
        let timeComponents = Calendar.current.dateComponents([.hour, .day, .month, .year], from: Date.now, to: date)
        
        var formatted: String {
            guard let years = timeComponents.year,
                  let months = timeComponents.month,
                  let days = timeComponents.day,
                  let hours = timeComponents.hour else {
                return ""
            }
            
            if (years != 0) {
                return "\(abs(years)) years"
            } else if (months != 0) {
                return "\(abs(months)) months"
            } else if (days != 0) {
                return "\(abs(days)) days"
            } else if (hours != 0) {
                return "\(abs(hours)) hours"
            } else {
                return ""
            }
        }
        
        return formatted
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
                            favoritedShowsManager.trackedShows.remove(atOffsets: indices)
                        }
                    }
                    .toolbar {
                        EditButton()
                    }
                }
            }
            .navigationTitle(navigationTitle)
        }
    }
}
