//
//  CouchPotatoApp.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/24/24.
//

import SwiftUI

@main
struct CouchPotatoApp: App {
    init() {
        // Firebase.configure() call here if using Firebase
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(FavoritedShowsManager()) // state manager environment object
        }
    }
}
