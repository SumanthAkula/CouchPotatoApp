//
//  TvStateManager.swift
//  CouchPotato
//
//  Created by Sumo Akula on 9/30/24.
//

import SwiftUI
import UserNotifications

class FavoritedShowsManager: ObservableObject {
    @Published var trackedShows: [TvShow] {
        didSet {
            let data = try! JSONEncoder().encode(trackedShows)
            UserDefaults.standard.set(data, forKey: "tracked_shows")
        }
    }
    
    // notifications IDs are stored in a dictionary with keys being TvShow IDs and
    // values being a list of notification IDs for that show
    @Published var notificationIds: [Int : [String]] = [:] {
        didSet {
            let data = try! JSONEncoder().encode(notificationIds)
            UserDefaults.standard.set(data, forKey: "notification_ids")
        }
    }
    
    
    init() {
        // decode favorite shows list from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "tracked_shows") {
            self.trackedShows = try! JSONDecoder().decode([TvShow].self, from: data)
        } else {
            self.trackedShows = []
        }
        
        // decode notification ID list from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "notification_ids") {
            self.notificationIds = try! JSONDecoder().decode([Int : [String]].self, from: data)
        } else {
            self.notificationIds = [:]
        }
    }
    
    func favorite(show target: TvShow) {
        if !trackedShows.contains(where: { $0.id == target.id }) {
            trackedShows.append(target)
        }
    }
    
    func unfavorite(show target: TvShow) {
        trackedShows.removeAll { $0.id == target.id }
    }
    
    func enableNotifications(for show: TvShow) {
        // step 1: create the notification
        let content = UNMutableNotificationContent()
        content.title = show.name
        content.body = "There's a new episode!"
        
        // step 2: schedule the notification
        // 2.1 we gotta find out what days to enable notifications on and store that data somehow
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        let showtime = show.schedule.time.split(separator: ":").map { string in
            Int(string)
        }   // turns the string "9:30" or "09:54" to an array of ints [9, 30], or [9, 54]
        
        dateComponents.hour = showtime[0]
        dateComponents.minute = showtime[1]
        
        var notificationIds: [String] = []
        for day in show.schedule.days { // for each day of the week the show has a new episode, create a new notification request
            switch (day) {
                case "Monday":
                    dateComponents.weekday = DateComponents.Day.monday.rawValue
                case "Tuesday":
                    dateComponents.weekday = DateComponents.Day.tuesday.rawValue
                case "Wednesday":
                    dateComponents.weekday = DateComponents.Day.wednesday.rawValue
                case "Thursday":
                    dateComponents.weekday = DateComponents.Day.thursday.rawValue
                case "Friday":
                    dateComponents.weekday = DateComponents.Day.friday.rawValue
                case "Saturday":
                    dateComponents.weekday = DateComponents.Day.saturday.rawValue
                case "Sunday":
                    dateComponents.weekday = DateComponents.Day.sunday.rawValue
                default:
                    continue
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let uuid = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Notification error: \(error.localizedDescription)")
                } else {
                    notificationIds.append(uuid)
                }
            }
        }
        
        self.notificationIds[show.id] = notificationIds
    }
    
    func disableNotifications(for show: TvShow) {
        if let ids = self.notificationIds[show.id] {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: ids)
            
            self.notificationIds.removeValue(forKey: show.id)
        }
    }
}
