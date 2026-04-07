//
//  HomeView.swift
//  115PedalMate
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: PedalMateViewModel
    @Binding var mainTabSelection: Int

    @State private var showAddRide = false
    @State private var selectedRide: Ride?

    private var ridesThisWeekCount: Int {
        let calendar = Calendar.current
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else { return 0 }
        return viewModel.rides.filter { $0.date >= weekAgo }.count
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        heroSection

                        statsGridSection

                        weeklyGoalCard

                        if let last = viewModel.recentRides.first {
                            lastRideHighlight(last)
                        }

                        quickActionsRow

                        recentSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 96)
                }
                .scrollIndicators(.hidden)
                .pedalScreenChrome()
                .refreshable {
                    viewModel.loadFromUserDefaults()
                }

                addRideButton
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(formattedNavbarDate())
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color.pedalMuted)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(Color.pedalActive)
                    }
                    .accessibilityLabel("Settings")
                }
            }
            .sheet(isPresented: $showAddRide) {
                AddRideView(viewModel: viewModel)
            }
            .sheet(item: $selectedRide) { ride in
                rideDetailSheet(ride)
            }
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                Text(greeting())
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .accessibilityAddTraits(.isHeader)

                (Text("You logged ") + Text("\(ridesThisWeekCount)").bold() + Text(" rides in the last 7 days."))
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.92))

                HStack(spacing: 6) {
                    Image(systemName: "figure.outdoor.cycle")
                        .font(.caption.weight(.semibold))
                    Text("\(String(format: "%.0f", viewModel.weeklyDistance)) km this week")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(.white.opacity(0.98))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background {
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .overlay {
                            Capsule()
                                .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)
                        }
                        .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                }
            }

            Spacer(minLength: 0)

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.32), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 72, height: 72)
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                Image(systemName: "bicycle.circle.fill")
                    .font(.system(size: 56))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .white.opacity(0.35))
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .pedalHeroPanel(cornerRadius: 24)
    }

    // MARK: - Stats grid

    private var statsGridSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.title3.bold())
                .foregroundStyle(Color.pedalDark)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                HomeStatTile(
                    title: "Total km",
                    value: String(format: "%.0f", viewModel.totalDistance),
                    icon: "map.fill",
                    accent: Color.pedalActive
                )
                HomeStatTile(
                    title: "Rides",
                    value: "\(viewModel.totalRides)",
                    icon: "bicycle",
                    accent: Color.blue.opacity(0.85)
                )
                HomeStatTile(
                    title: "Hours",
                    value: "\(viewModel.totalHours)",
                    icon: "clock.fill",
                    accent: Color.orange.opacity(0.9)
                )
                HomeStatTile(
                    title: "Elevation",
                    value: "\(viewModel.totalElevation) m",
                    icon: "mountain.2.fill",
                    accent: Color.purple.opacity(0.85)
                )
            }
        }
    }

    // MARK: - Weekly goal

    private var weeklyGoalCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Text("Weekly goal")
                    .font(.headline)
                    .foregroundStyle(Color.pedalDark)
                Spacer()
                Text("\(Int(viewModel.weeklyDistance)) / \(viewModel.weeklyGoal) km")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(
                        viewModel.weeklyDistance >= Double(viewModel.weeklyGoal)
                        ? Color.pedalActive
                        : Color.pedalMuted
                    )
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.pedalActive.opacity(0.12), Color.pedalMuted.opacity(0.08)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 12)
                        .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 1)
                    Capsule()
                        .fill(PedalGradients.fab)
                        .frame(width: max(10, geo.size.width * viewModel.weeklyProgress), height: 12)
                        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: viewModel.weeklyProgress)
                        .shadow(color: Color.pedalActive.opacity(0.35), radius: 6, x: 0, y: 3)
                }
            }
            .frame(height: 12)

            if viewModel.weeklyProgress >= 1.0 {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Color.pedalActive)
                        .imageScale(.medium)
                    Text("Weekly distance target reached — great work.")
                        .font(.caption)
                        .foregroundStyle(Color.pedalDark.opacity(0.85))
                }
            } else {
                let remaining = max(0, viewModel.weeklyGoal - Int(viewModel.weeklyDistance))
                Group {
                    if remaining == 0 {
                        Text("You are on track — keep going.")
                            .font(.caption)
                            .foregroundStyle(Color.pedalMuted)
                    } else {
                        (Text("About ") + Text("\(remaining) km").bold().foregroundColor(Color.pedalDark) + Text(" left to hit your weekly goal."))
                            .font(.caption)
                            .foregroundColor(Color.pedalMuted)
                    }
                }
            }
        }
        .padding(18)
        .pedalElevatedCard(cornerRadius: 22)
    }

    // MARK: - Last ride

    private func lastRideHighlight(_ ride: Ride) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last ride")
                .font(.title3.bold())
                .foregroundStyle(Color.pedalDark)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formattedDate(ride.date))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.pedalDark)
                    Text(ride.rideType.rawValue)
                        .font(.caption)
                        .foregroundStyle(Color.pedalMuted)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(ride.distance)) km")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.pedalActive)
                    Text(ride.formattedDuration)
                        .font(.caption)
                        .foregroundStyle(Color.pedalMuted)
                }
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.pedalActive.opacity(0.12),
                                Color.pedalActive.opacity(0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [Color.pedalActive.opacity(0.45), Color.pedalActive.opacity(0.15)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                    .shadow(color: Color.pedalActive.opacity(0.12), radius: 8, x: 0, y: 4)
            }
        }
    }

    // MARK: - Quick actions

    private var quickActionsRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Shortcuts")
                .font(.title3.bold())
                .foregroundStyle(Color.pedalDark)

            HStack(spacing: 12) {
                HomeQuickActionButton(
                    title: "Log ride",
                    icon: "plus.circle.fill",
                    color: Color.pedalActive
                ) {
                    showAddRide = true
                }

                HomeQuickActionButton(
                    title: "Routes",
                    icon: "map.fill",
                    color: Color.blue.opacity(0.85)
                ) {
                    mainTabSelection = 2
                }

                HomeQuickActionButton(
                    title: "Challenges",
                    icon: "trophy.fill",
                    color: Color.orange.opacity(0.9)
                ) {
                    mainTabSelection = 3
                }
            }
        }
    }

    // MARK: - Recent rides

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent rides")
                    .font(.title3.bold())
                    .foregroundStyle(Color.pedalDark)
                Spacer()
                if !viewModel.recentRides.isEmpty {
                    Text("\(viewModel.recentRides.count) shown")
                        .font(.caption)
                        .foregroundStyle(Color.pedalMuted)
                }
            }

            if viewModel.recentRides.isEmpty {
                emptyRidesPlaceholder
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.recentRides) { ride in
                        RideCard(ride: ride)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedRide = ride
                            }
                            .contextMenu {
                                Button {
                                    viewModel.toggleFavoriteRide(ride)
                                } label: {
                                    Label(
                                        ride.isFavorite ? "Remove favorite" : "Favorite",
                                        systemImage: ride.isFavorite ? "star.slash" : "star"
                                    )
                                }
                                Button(role: .destructive) {
                                    viewModel.deleteRide(ride)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }
    }

    private var emptyRidesPlaceholder: some View {
        VStack(spacing: 14) {
            Image(systemName: "road.lanes")
                .font(.system(size: 44))
                .foregroundStyle(Color.pedalActive.opacity(0.5))
            Text("No rides yet")
                .font(.headline)
                .foregroundStyle(Color.pedalDark)
            (Text("Tap ") + Text("Log ride").bold().foregroundColor(Color.pedalActive) + Text(" or the + button to add your first entry."))
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.pedalMuted)
            Button {
                showAddRide = true
            } label: {
                Text("Add ride")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 13)
                    .background {
                        Capsule()
                            .fill(PedalGradients.fab)
                            .overlay {
                                Capsule()
                                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                            }
                            .shadow(color: Color.pedalActive.opacity(0.4), radius: 12, x: 0, y: 6)
                    }
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .pedalElevatedCard(cornerRadius: 22)
    }

    // MARK: - FAB

    private var addRideButton: some View {
        Button {
            showAddRide = true
        } label: {
            Image(systemName: "plus")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 58, height: 58)
                .pedalFABBackground()
        }
        .padding(.trailing, 20)
        .padding(.bottom, 16)
        .accessibilityLabel("Add ride")
    }

    // MARK: - Sheets

    private func rideDetailSheet(_ ride: Ride) -> some View {
        NavigationStack {
            ScrollView {
                RideCard(ride: ride)
                    .padding()
            }
            .pedalScreenChrome()
            .navigationTitle("Ride details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        selectedRide = nil
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Hello"
        }
    }

    private func formattedNavbarDate() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "EEE, MMM d"
        return f.string(from: Date())
    }
}

// MARK: - Subviews

private struct HomeStatTile: View {
    let title: String
    let value: String
    let icon: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [accent.opacity(0.28), accent.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .shadow(color: accent.opacity(0.2), radius: 5, x: 0, y: 2)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(accent)
            }
            Text(title)
                .font(.caption)
                .foregroundStyle(Color.pedalMuted)
            Text(value)
                .font(.system(.title2, design: .rounded).bold())
                .foregroundStyle(Color.pedalDark)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .pedalElevatedCard(cornerRadius: 18)
    }
}

private struct HomeQuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Text(title)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Color.pedalDark)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .pedalElevatedCard(cornerRadius: 16)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView(viewModel: PedalMateViewModel(), mainTabSelection: .constant(0))
}
