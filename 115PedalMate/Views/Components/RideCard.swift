//
//  RideCard.swift
//  115PedalMate
//

import SwiftUI

struct RideCard: View {
    let ride: Ride

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: ride.rideType.icon)
                    .foregroundStyle(Color.pedalActive)
                    .font(.title2)

                VStack(alignment: .leading) {
                    Text(formattedDate(ride.date))
                        .foregroundStyle(Color.pedalDark)
                        .font(.headline)

                    Text(ride.rideType.rawValue)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }

                Spacer()

                Text("\(Int(ride.distance)) km")
                    .foregroundStyle(Color.pedalActive)
                    .font(.title2)
                    .bold()

                if ride.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.pedalActive)
                        .font(.caption)
                }
            }

            HStack {
                Label(ride.formattedDuration, systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.gray)

                Spacer()

                Label(String(format: "%.1f km/h", ride.avgSpeed), systemImage: "speedometer")
                    .font(.caption)
                    .foregroundStyle(Color.pedalActive)

                Spacer()

                if let elevation = ride.elevationGain {
                    Label("\(elevation) m", systemImage: "mountain.2.fill")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }

            HStack {
                Image(systemName: ride.terrain.icon)
                    .font(.caption)
                    .foregroundStyle(Color.pedalActive)
                Text(ride.terrain.rawValue)
                    .font(.caption)
                    .foregroundStyle(.gray)

                Spacer()

                Image(systemName: ride.weather.icon)
                    .font(.caption)
                    .foregroundStyle(Color.pedalActive)
                Text(ride.weather.rawValue)
                    .font(.caption)
                    .foregroundStyle(.gray)

                Spacer()

                Text(ride.bikeName)
                    .font(.caption)
                    .foregroundStyle(Color.pedalActive)
            }
        }
        .padding(16)
        .pedalElevatedCard(cornerRadius: 18)
    }
}
