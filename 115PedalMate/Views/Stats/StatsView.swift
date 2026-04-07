//
//  StatsView.swift
//  115PedalMate
//

import Charts
import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: PedalMateViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        StatCard(
                            title: "Total km",
                            value: String(format: "%.0f", viewModel.totalDistance),
                            icon: "map.fill",
                            color: .pedalActive
                        )

                        StatCard(
                            title: "Rides",
                            value: "\(viewModel.totalRides)",
                            icon: "bicycle",
                            color: .pedalActive
                        )

                        StatCard(
                            title: "Avg speed",
                            value: String(format: "%.1f km/h", viewModel.avgSpeedOverall),
                            icon: "speedometer",
                            color: .pedalActive
                        )

                        StatCard(
                            title: "Longest ride",
                            value: "\(Int(viewModel.longestRide)) km",
                            icon: "trophy.fill",
                            color: .pedalActive
                        )
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Distance by month")
                            .font(.headline)
                            .foregroundStyle(Color.pedalDark)

                        Chart {
                            ForEach(viewModel.monthlyDistance) { data in
                                BarMark(
                                    x: .value("Month", data.month),
                                    y: .value("Km", data.distance)
                                )
                                .foregroundStyle(PedalGradients.barMark)
                            }
                        }
                        .frame(height: 200)
                    }
                    .padding(18)
                    .pedalElevatedCard(cornerRadius: 20)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ride types")
                            .font(.headline)
                            .foregroundStyle(Color.pedalDark)

                        ForEach(viewModel.typeDistribution) { item in
                            HStack {
                                Image(systemName: item.icon)
                                    .foregroundStyle(Color.pedalActive)
                                    .frame(width: 30)

                                Text(item.name)
                                    .foregroundStyle(Color.pedalDark)

                                Spacer()

                                Text("\(Int(item.distance)) km")
                                    .foregroundStyle(Color.pedalActive)

                                Text("(\(Int(item.percentage))%)")
                                    .foregroundStyle(.gray)
                                    .font(.caption)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(18)
                    .pedalElevatedCard(cornerRadius: 20)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .pedalScreenChrome()
            .navigationTitle("Statistics")
        }
    }
}
