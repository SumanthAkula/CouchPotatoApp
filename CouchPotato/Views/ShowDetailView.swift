//
//  ShowDetailView.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/30/24.
//

import SwiftUI

struct ShowDetailView: View {
    @EnvironmentObject var stateManager: TvStateManager
    @State var tracked: Bool = false
    
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
                .clipShape(.rect(cornerRadius: 25))
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
            tracked = stateManager.trackedShows.contains(where: { element in
                element.id == show.id
            })
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(show.name)
                        .font(.headline)
                    
                    if tracked {
                        Text("Tracking")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Track", systemImage: tracked ? "star.fill" : "star") {
                    tracked.toggle()
                }
            }
        }
        .onChange(of: tracked) {
            if (tracked) {
                stateManager.track(show: show)
            } else {
                stateManager.untrack(show: show)
            }
        }
    }
}
