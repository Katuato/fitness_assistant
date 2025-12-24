//
//  WorkoutSession.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import Foundation

struct WorkoutSession: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let exerciseCount: Int
    let totalTime: Int
    let accuracy: Int
    let bodyPart: String

    enum CodingKeys: String, CodingKey {
        case date, exerciseCount, totalTime, accuracy, bodyPart
    }
    
    var formattedDate: String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return "Today, \(formatter.string(from: date))"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            return formatter.string(from: date)
        }
    }
    
    var formattedTime: String {
        "\(totalTime) min"
    }
    
    var formattedAccuracy: String {
        "\(accuracy)%"
    }
}
