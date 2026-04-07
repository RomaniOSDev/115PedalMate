//
//  Terrain.swift
//  115PedalMate
//

import Foundation

enum Terrain: String, CaseIterable, Codable {
    case road = "Road"
    case trail = "Trail"
    case mixed = "Mixed"
    case indoor = "Indoor"

    var icon: String {
        switch self {
        case .road: return "road.lanes"
        case .trail: return "tree.fill"
        case .mixed: return "square.grid.2x2.fill"
        case .indoor: return "house.fill"
        }
    }
}
