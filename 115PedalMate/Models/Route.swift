//
//  Route.swift
//  115PedalMate
//

import Foundation

struct Route: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var distance: Double
    var elevationGain: Int?
    var description: String?
    var isFavorite: Bool
    var rides: [Ride]?
}
