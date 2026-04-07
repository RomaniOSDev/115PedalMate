//
//  RideType.swift
//  115PedalMate
//

import Foundation

enum RideType: String, CaseIterable, Codable {
    case training = "Training"
    case leisure = "Leisure"
    case commute = "Commute"
    case race = "Race"
    case gravel = "Gravel"

    var icon: String {
        switch self {
        case .training: return "figure.outdoor.cycle"
        case .leisure: return "leaf.fill"
        case .commute: return "building.2.fill"
        case .race: return "flag.checkered"
        case .gravel: return "circle.hexagongrid.fill"
        }
    }
}
