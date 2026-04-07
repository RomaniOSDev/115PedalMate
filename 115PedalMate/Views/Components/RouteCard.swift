//
//  RouteCard.swift
//  115PedalMate
//

import SwiftUI

struct RouteCard: View {
    let route: Route

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(route.name)
                    .foregroundStyle(Color.pedalDark)
                    .font(.headline)

                Spacer()

                if route.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.pedalActive)
                        .font(.caption)
                }
            }

            HStack {
                Label("\(Int(route.distance)) km", systemImage: "map.fill")
                    .font(.caption)
                    .foregroundStyle(Color.pedalActive)

                if let elevation = route.elevationGain {
                    Spacer()
                    Label("\(elevation) m", systemImage: "mountain.2.fill")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }

            if let description = route.description {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }

            if let rides = route.rides, !rides.isEmpty {
                Text("Ridden \(rides.count) times")
                    .font(.caption2)
                    .foregroundStyle(Color.pedalActive)
            }
        }
        .padding(16)
        .pedalElevatedCard(cornerRadius: 18)
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.75), Color.pedalActive],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 5)
                .padding(.leading, 10)
                .padding(.vertical, 16)
                .allowsHitTesting(false)
        }
    }
}
