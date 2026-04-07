//
//  Challenge.swift
//  115PedalMate
//

import Foundation

struct Challenge: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var targetDistance: Double
    var currentDistance: Double
    var targetDays: Int
    var currentDays: Int
    var deadline: Date?
    var isCompleted: Bool
    let createdAt: Date

    var distanceProgress: Double {
        guard targetDistance > 0 else { return 0 }
        return min(currentDistance / targetDistance, 1.0)
    }

    var daysProgress: Double {
        guard targetDays > 0 else { return 0 }
        return min(Double(currentDays) / Double(targetDays), 1.0)
    }
}
