//
//  PedalMateViewModel.swift
//  115PedalMate
//

import Combine
import Foundation

@MainActor
final class PedalMateViewModel: ObservableObject {
    @Published var rides: [Ride] = []
    @Published var bikes: [Bike] = []
    @Published var routes: [Route] = []
    @Published var challenges: [Challenge] = []
    @Published var maintenance: [BikeMaintenance] = []

    var totalRides: Int { rides.count }

    var totalDistance: Double {
        rides.reduce(0) { $0 + $1.distance }
    }

    var totalHours: Int {
        rides.reduce(0) { $0 + $1.duration } / 60
    }

    var totalElevation: Int {
        rides.compactMap { $0.elevationGain }.reduce(0, +)
    }

    var weeklyDistance: Double {
        let calendar = Calendar.current
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else { return 0 }
        return rides.filter { $0.date >= weekAgo }.reduce(0) { $0 + $1.distance }
    }

    var weeklyGoal: Int {
        let fromChallenge = challenges.first { $0.name.localizedCaseInsensitiveContains("week") }
        if let d = fromChallenge?.targetDistance { return Int(d.rounded()) }
        return 50
    }

    var weeklyProgress: Double {
        guard weeklyGoal > 0 else { return 0 }
        return min(weeklyDistance / Double(weeklyGoal), 1.0)
    }

    var recentRides: [Ride] {
        Array(rides.sorted { $0.date > $1.date }.prefix(10))
    }

    var avgSpeedOverall: Double {
        guard !rides.isEmpty else { return 0 }
        let totalSpeed = rides.reduce(0) { $0 + $1.avgSpeed }
        return totalSpeed / Double(rides.count)
    }

    var longestRide: Double {
        rides.map { $0.distance }.max() ?? 0
    }

    struct MonthlyDistance: Identifiable {
        let id: String
        let month: String
        let distance: Double
        let sortDate: Date
    }

    var monthlyDistance: [MonthlyDistance] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: rides) { ride -> Date in
            let components = calendar.dateComponents([.year, .month], from: ride.date)
            return calendar.date(from: components) ?? ride.date
        }

        return grouped.map { date, rides in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            formatter.locale = Locale(identifier: "en_US")
            let label = formatter.string(from: date)
            let distance = rides.reduce(0) { $0 + $1.distance }
            return MonthlyDistance(
                id: "\(calendar.component(.year, from: date))-\(calendar.component(.month, from: date))",
                month: label,
                distance: distance,
                sortDate: date
            )
        }
        .sorted { $0.sortDate < $1.sortDate }
    }

    struct TypeDistribution: Identifiable {
        let id: String
        let name: String
        let icon: String
        let distance: Double
        let percentage: Double
    }

    var typeDistribution: [TypeDistribution] {
        let grouped = Dictionary(grouping: rides, by: { $0.rideType })
        let total = totalDistance

        return grouped.map { type, rides in
            let distance = rides.reduce(0) { $0 + $1.distance }
            return TypeDistribution(
                id: type.rawValue,
                name: type.rawValue,
                icon: type.icon,
                distance: distance,
                percentage: total > 0 ? distance / total * 100 : 0
            )
        }
        .sorted { $0.distance > $1.distance }
    }

    func bikeStats(_ bikeId: UUID) -> (rides: Int, distance: Double) {
        let bikeRides = rides.filter { $0.bikeId == bikeId }
        return (bikeRides.count, bikeRides.reduce(0) { $0 + $1.distance })
    }

    func addRide(_ ride: Ride) {
        rides.append(ride)
        applyRideToRoutes(ride)
        updateChallenges(with: ride)
        saveToUserDefaults()
    }

    func updateRide(_ ride: Ride) {
        if let index = rides.firstIndex(where: { $0.id == ride.id }) {
            rides[index] = ride
            applyRideToRoutes(ride)
            saveToUserDefaults()
        }
    }

    func deleteRide(_ ride: Ride) {
        rides.removeAll { $0.id == ride.id }
        for i in routes.indices {
            routes[i].rides?.removeAll { $0.id == ride.id }
        }
        saveToUserDefaults()
    }

    func toggleFavoriteRide(_ ride: Ride) {
        if let index = rides.firstIndex(where: { $0.id == ride.id }) {
            rides[index].isFavorite.toggle()
            applyRideToRoutes(rides[index])
            saveToUserDefaults()
        }
    }

    func addBike(_ bike: Bike) {
        if bike.isPrimary {
            for i in bikes.indices {
                bikes[i].isPrimary = false
            }
        }
        bikes.append(bike)
        saveToUserDefaults()
    }

    func deleteBike(_ bike: Bike) {
        bikes.removeAll { $0.id == bike.id }
        maintenance.removeAll { $0.bikeId == bike.id }
        saveToUserDefaults()
    }

    func addMaintenance(_ entry: BikeMaintenance) {
        maintenance.append(entry)
        saveToUserDefaults()
    }

    func deleteMaintenance(_ entry: BikeMaintenance) {
        maintenance.removeAll { $0.id == entry.id }
        saveToUserDefaults()
    }

    func setPrimaryBike(_ bike: Bike) {
        for i in bikes.indices {
            bikes[i].isPrimary = (bikes[i].id == bike.id)
        }
        saveToUserDefaults()
    }

    func addRoute(_ route: Route) {
        routes.append(route)
        saveToUserDefaults()
    }

    func deleteRoute(_ route: Route) {
        routes.removeAll { $0.id == route.id }
        saveToUserDefaults()
    }

    func toggleFavoriteRoute(_ route: Route) {
        if let index = routes.firstIndex(where: { $0.id == route.id }) {
            routes[index].isFavorite.toggle()
            saveToUserDefaults()
        }
    }

    func addChallenge(_ challenge: Challenge) {
        challenges.append(challenge)
        saveToUserDefaults()
    }

    func deleteChallenge(_ challenge: Challenge) {
        challenges.removeAll { $0.id == challenge.id }
        saveToUserDefaults()
    }

    func completeChallenge(_ challenge: Challenge) {
        if let index = challenges.firstIndex(where: { $0.id == challenge.id }) {
            challenges[index].isCompleted = true
            saveToUserDefaults()
        }
    }

    private func normalizedRouteKey(_ string: String?) -> String? {
        guard let trimmed = string?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmed.isEmpty else {
            return nil
        }
        return trimmed.lowercased()
    }

    /// Keeps `Route.rides` in sync with the canonical `rides` array (match by `ride.routeName` ↔ `route.name`).
    private func applyRideToRoutes(_ ride: Ride) {
        for i in routes.indices {
            routes[i].rides?.removeAll { $0.id == ride.id }
            if routes[i].rides?.isEmpty == true {
                routes[i].rides = nil
            }
        }
        guard let key = normalizedRouteKey(ride.routeName),
              let idx = routes.firstIndex(where: { normalizedRouteKey($0.name) == key }) else {
            return
        }
        if routes[idx].rides == nil {
            routes[idx].rides = []
        }
        routes[idx].rides?.append(ride)
    }

    private func updateChallenges(with ride: Ride) {
        for i in challenges.indices where !challenges[i].isCompleted {
            challenges[i].currentDistance += ride.distance

            let existingDays = Set(
                rides.filter { $0.date >= challenges[i].createdAt }
                    .map { Calendar.current.startOfDay(for: $0.date) }
            )
            challenges[i].currentDays = existingDays.count

            if challenges[i].currentDistance >= challenges[i].targetDistance,
               challenges[i].currentDays >= challenges[i].targetDays {
                challenges[i].isCompleted = true
            }
        }
        saveToUserDefaults()
    }

    private let ridesKey = "pedalmate_rides"
    private let bikesKey = "pedalmate_bikes"
    private let routesKey = "pedalmate_routes"
    private let challengesKey = "pedalmate_challenges"
    private let maintenanceKey = "pedalmate_maintenance"

    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(rides) {
            UserDefaults.standard.set(encoded, forKey: ridesKey)
        }
        if let encoded = try? JSONEncoder().encode(bikes) {
            UserDefaults.standard.set(encoded, forKey: bikesKey)
        }
        if let encoded = try? JSONEncoder().encode(routes) {
            UserDefaults.standard.set(encoded, forKey: routesKey)
        }
        if let encoded = try? JSONEncoder().encode(challenges) {
            UserDefaults.standard.set(encoded, forKey: challengesKey)
        }
        if let encoded = try? JSONEncoder().encode(maintenance) {
            UserDefaults.standard.set(encoded, forKey: maintenanceKey)
        }
    }

    func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: ridesKey),
           let decoded = try? JSONDecoder().decode([Ride].self, from: data) {
            rides = decoded
        }

        if let data = UserDefaults.standard.data(forKey: bikesKey),
           let decoded = try? JSONDecoder().decode([Bike].self, from: data) {
            bikes = decoded
        }

        if let data = UserDefaults.standard.data(forKey: routesKey),
           let decoded = try? JSONDecoder().decode([Route].self, from: data) {
            routes = decoded
        }

        if let data = UserDefaults.standard.data(forKey: challengesKey),
           let decoded = try? JSONDecoder().decode([Challenge].self, from: data) {
            challenges = decoded
        }

        if let data = UserDefaults.standard.data(forKey: maintenanceKey),
           let decoded = try? JSONDecoder().decode([BikeMaintenance].self, from: data) {
            maintenance = decoded
        }

        if rides.isEmpty {
            loadDemoData()
        } else {
            rebuildRouteRideReferences()
        }
    }

    private func rebuildRouteRideReferences() {
        for i in routes.indices {
            routes[i].rides = nil
        }
        for ride in rides {
            applyRideToRoutes(ride)
        }
        saveToUserDefaults()
    }

    private func loadDemoData() {
        let bike = Bike(
            id: UUID(),
            name: "Giant TCR",
            type: "Road",
            color: "Red",
            weight: 8.5,
            notes: "Carbon frame",
            isPrimary: true,
            createdAt: Date()
        )
        bikes = [bike]

        let ride = Ride(
            id: UUID(),
            date: Date().addingTimeInterval(-86400 * 2),
            distance: 45.5,
            duration: 105,
            avgSpeed: 26.0,
            maxSpeed: 42.5,
            elevationGain: 320,
            rideType: .training,
            terrain: .road,
            weather: .sunny,
            bikeId: bike.id,
            bikeName: bike.name,
            calories: 1250,
            avgHeartRate: 145,
            notes: "Great training session",
            routeName: "Riverside loop",
            isFavorite: true,
            createdAt: Date()
        )

        let ride2 = Ride(
            id: UUID(),
            date: Date().addingTimeInterval(-86400 * 5),
            distance: 28.3,
            duration: 85,
            avgSpeed: 20.0,
            maxSpeed: 35.0,
            elevationGain: 150,
            rideType: .leisure,
            terrain: .mixed,
            weather: .cloudy,
            bikeId: bike.id,
            bikeName: bike.name,
            calories: 680,
            avgHeartRate: 130,
            notes: nil,
            routeName: "City park",
            isFavorite: false,
            createdAt: Date()
        )

        rides = [ride, ride2]

        let route = Route(
            id: UUID(),
            name: "Riverside loop",
            distance: 45.5,
            elevationGain: 320,
            description: "Scenic route along the river",
            isFavorite: true,
            rides: [ride]
        )
        routes = [route]

        let challenge = Challenge(
            id: UUID(),
            name: "100 km this week",
            targetDistance: 100,
            currentDistance: 45.5,
            targetDays: 5,
            currentDays: 1,
            deadline: Date().addingTimeInterval(86400 * 5),
            isCompleted: false,
            createdAt: Date()
        )
        challenges = [challenge]

        maintenance = [
            BikeMaintenance(
                id: UUID(),
                bikeId: bike.id,
                bikeName: bike.name,
                date: Date().addingTimeInterval(-86400 * 14),
                maintenanceType: "Cleaning",
                distance: Int(bikeStats(bike.id).distance.rounded()),
                notes: "Chain cleaned and re-lubed"
            )
        ]
    }
}
