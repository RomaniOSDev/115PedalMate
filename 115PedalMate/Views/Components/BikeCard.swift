//
//  BikeCard.swift
//  115PedalMate
//

import SwiftUI

struct BikeCard: View {
    let bike: Bike
    let stats: (rides: Int, distance: Double)

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.pedalActive.opacity(0.28), Color.pedalActive.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .shadow(color: Color.pedalActive.opacity(0.2), radius: 6, x: 0, y: 3)
                Image(systemName: "bicycle")
                    .foregroundStyle(Color.pedalActive)
                    .font(.title2)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(bike.name)
                        .foregroundStyle(Color.pedalDark)
                        .font(.headline)

                    if bike.isPrimary {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.pedalActive)
                            .font(.caption)
                    }
                }

                Text(bike.type)
                    .font(.caption)
                    .foregroundStyle(.gray)

                if let weight = bike.weight {
                    Text(String(format: "Weight: %.1f kg", weight))
                        .font(.caption2)
                        .foregroundStyle(Color.pedalActive)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(stats.distance)) km")
                    .foregroundStyle(Color.pedalActive)
                    .font(.headline)

                Text("\(stats.rides) rides")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
        .padding(16)
        .pedalElevatedCard(cornerRadius: 18)
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(PedalGradients.fab)
                .frame(width: 5)
                .padding(.leading, 10)
                .padding(.vertical, 16)
                .allowsHitTesting(false)
        }
    }
}
