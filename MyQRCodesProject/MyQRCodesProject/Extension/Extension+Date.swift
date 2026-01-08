//
//  Extension+Date.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation

extension Date {

    func timeAgoString(now: Date = Date()) -> String {
        let secondsAgo = Int(now.timeIntervalSince(self))

        if secondsAgo < 0 {
            return "Just now"
        }

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day

        switch secondsAgo {
        case 0..<minute:
            return "Just now"

        case minute..<hour:
            let minutes = secondsAgo / minute
            return "\(minutes) min ago"

        case hour..<day:
            let hours = secondsAgo / hour
            return "\(hours) hour\(hours > 1 ? "s" : "") ago"

        case day..<week:
            let days = secondsAgo / day
            return days == 1 ? "Yesterday" : "\(days) days ago"

        default:
            let weeks = secondsAgo / week
            return "\(weeks) week\(weeks > 1 ? "s" : "") ago"
        }
    }
    
    var formattedLong: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "hh:mm aaa"
        return formatter.string(from: self)
    }
    
}

