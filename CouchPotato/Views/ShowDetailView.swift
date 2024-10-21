//
//  ShowDetailView.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/30/24.
//

import SwiftUI

struct ShowDetailView: View {
    @EnvironmentObject var showsManager: FavoritedShowsManager
    
    @State var favorited: Bool = false
    @State var notify: Bool = false
    
    let show: TvShow
    
    var body: some View {
        ScrollView {
            if let image = show.image {
                AsyncImage(url: image.url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 15))
                .shadow(radius: 15)
                .padding(.horizontal, 50)
                .padding(.vertical)
            }
            
            Text(show.name)
                .font(.title)
            
            Text(show.genres.joined(separator: ", "))
            
            Divider()
            
            if let summary = show.summary {
                Text(summary.replacingOccurrences(of: #"\</?(p|b|i)>"#, with: "", options: .regularExpression, range: nil).replacingOccurrences(of: #"\<br />"#, with: "\n", options: .regularExpression, range: nil))
                    .padding()
            }
            
            Divider()
        }
        .onAppear {
            favorited = showsManager.trackedShows.contains(where: { element in
                element.id == show.id
            })
            
            notify = showsManager.notificationIds[show.id] != nil
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(show.name)
                        .font(.headline)
                    
                    if favorited {
                        Text("Favorited")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button("Notify Me", systemImage: notify ? "bell.fill" : "bell") {
                        if (!notify) {
                            showsManager.enableNotifications(for: show)
                        } else {
                            showsManager.disableNotifications(for: show)
                        }
                        
                        notify = showsManager.notificationIds[show.id] != nil
                    }
                    
                    Button("Track", systemImage: favorited ? "star.fill" : "star") {
                        favorited.toggle()
                    }
                }
            }
            
        }
        .onChange(of: favorited) {
            if (favorited) {
                showsManager.favorite(show: show)
            } else {
                showsManager.unfavorite(show: show)
            }
        }
        .onChange(of: notify) {
            if (notify) {
                showsManager.enableNotifications(for: show)
            } else {
                showsManager.disableNotifications(for: show)
            }
        }
    }
}
