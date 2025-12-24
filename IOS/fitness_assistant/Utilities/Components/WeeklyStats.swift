//
//  WeeklyStats.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import Foundation

struct DayAccuracy: Identifiable, Codable {
    let id = UUID()
    let day: String
    let accuracy: Double

    enum CodingKeys: String, CodingKey {
        case day, accuracy
    }
}

struct WeeklyStats: Codable {
    let weekLabel: String
    let averageAccuracy: Double
    let dailyAccuracies: [DayAccuracy]

    enum CodingKeys: String, CodingKey {
        case weekLabel, averageAccuracy, dailyAccuracies
    }

    var formattedAccuracy: String {
        String(format: "%.1f%%", averageAccuracy)
    }
}
