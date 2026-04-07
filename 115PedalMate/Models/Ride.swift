//
//  Ride.swift
//  115PedalMate
//

import Foundation

struct Ride: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var distance: Double
    var duration: Int
    var avgSpeed: Double
    var maxSpeed: Double
    var elevationGain: Int?
    var rideType: RideType
    var terrain: Terrain
    var weather: Weather
    var bikeId: UUID
    var bikeName: String
    var calories: Int?
    var avgHeartRate: Int?
    var notes: String?
    var routeName: String?
    var isFavorite: Bool
    let createdAt: Date

    var avgPace: String {
        guard distance > 0 else { return "--:--" }
        let minutesPerKm = Double(duration) / distance
        let minutes = Int(minutesPerKm)
        let seconds = Int((minutesPerKm - Double(minutes)) * 60)
        return String(format: "%d:%02d min/km", minutes, seconds)
    }

    var formattedDuration: String {
        let hours = duration / 60
        let minutes = duration % 60
        if hours > 0 {
            return "\(hours) h \(minutes) min"
        }
        return "\(minutes) min"
    }
}
