//
//  Bike.swift
//  115PedalMate
//

import Foundation

struct Bike: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var type: String
    var color: String
    var weight: Double?
    var notes: String?
    var isPrimary: Bool
    let createdAt: Date
}
