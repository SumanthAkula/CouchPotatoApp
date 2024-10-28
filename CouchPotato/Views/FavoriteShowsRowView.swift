//
//  FavoriteShowsRowView.swift
//  CouchPotato
//
//  Created by Sumo Akula on 10/26/24.
//

import SwiftUI

struct FavoriteShowsRowView: View {
    @EnvironmentObject var favoritedShowsManager: FavoritedShowsManager
    @State var nextEpisode: TvEpisode? = nil
    @State var previousEpisode: TvEpisode? = nil

    let show: TvShow
    var notify: Bool {
        favoritedShowsManager.notificationIds[show.id] != nil
    } // computed property to check whether or not the show has notifications enabled
    
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
                
                // if the show has ended, show the date it ended
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
                    // if the show has a next episode and has not ended, show time until next wpisode
                    let formatted = timeDifferenceFormatted(date: next)
                    Text("Next episode in \(formatted)")
                        .font(.subheadline)
                } else if let prev = previousEpisode?.airstamp ?? nil {
                    // otherwise, just show how long ago the last episode was
                    let formatted = timeDifferenceFormatted(date: prev)
                    Text("Last episode \(formatted) ago")
                        .font(.subheadline)
                }
            }
            .onAppear {
                // get information about next episode - if it exists
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
                
                // get informatino about the previous episode - if it exists
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
                // if notifications are enabled, show a little bell icon to indicate that
                Image(systemName: "bell.fill")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    // formats a date so it shows how long into the future or past the given date will be
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
                return "less  than an hour"
            }
        }
        
        return formatted
    }
}
