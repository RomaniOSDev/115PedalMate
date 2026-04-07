//
//  BikeMaintenance.swift
//  115PedalMate
//

import Foundation

struct BikeMaintenance: Identifiable, Codable, Equatable {
    let id: UUID
    let bikeId: UUID
    let bikeName: String
    let date: Date
    var maintenanceType: String
    var distance: Int
    var notes: String?
}
