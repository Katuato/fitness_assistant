//
//  WeeklyStats.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import Foundation

struct DayAccuracy: Identifiable {
    let id = UUID()
    let day: String
    let accuracy: Double
}

struct WeeklyStats {
    let weekLabel: String
    let averageAccuracy: Double
    let dailyAccuracies: [DayAccuracy]
    
    var formattedAccuracy: String {
        String(format: "%.1f%%", averageAccuracy)
    }
}
