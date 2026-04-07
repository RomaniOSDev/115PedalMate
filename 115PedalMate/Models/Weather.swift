//
//  Weather.swift
//  115PedalMate
//

import Foundation

enum Weather: String, CaseIterable, Codable {
    case sunny = "Sunny"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
    case windy = "Windy"
    case snow = "Snow"

    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .cloudy: return "cloud.fill"
        case .rainy: return "cloud.rain.fill"
        case .windy: return "wind"
        case .snow: return "snowflake"
        }
    }
}
