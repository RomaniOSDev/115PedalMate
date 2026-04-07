//
//  AddRideView.swift
//  115PedalMate
//

import SwiftUI

struct AddRideView: View {
    @ObservedObject var viewModel: PedalMateViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var rideType: RideType = .training
    @State private var selectedBikeId: UUID?
    @State private var routeName = ""
    @State private var distance: Double = 10
    @State private var duration = 60
    @State private var elevationGain: Int?
    @State private var avgSpeed: Double = 20
    @State private var maxSpeed: Double = 35
    @State private var terrain: Terrain = .road
    @State private var weather: Weather = .sunny
    @State private var calories: Int?
    @State private var avgHeartRate: Int?
    @State private var notes = ""
    @State private var isFavorite = false
    @State private var showAddBike = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Date & time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .tint(.pedalActive)

                    Picker("Ride type", selection: $rideType) {
                        ForEach(RideType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.icon).tag(type)
                        }
                    }
                    .tint(.pedalActive)

                    Picker("Bike", selection: $selectedBikeId) {
                        ForEach(viewModel.bikes) { bike in
                            Text(bike.name).tag(Optional(bike.id))
                        }
                        Text("Add new bike").tag(UUID?.none)
                    }
                    .tint(.pedalActive)
                    .onChange(of: selectedBikeId) { newValue in
                        guard newValue == nil else { return }
                        showAddBike = true
                    }
                }

                Section(header: Text("Route").foregroundStyle(.gray)) {
                    TextField("Route name", text: $routeName)
                        .foregroundStyle(Color.pedalDark)
                        .tint(.pedalActive)

                    HStack {
                        Text("Distance (km)")
                        Spacer()
                        TextField("", value: $distance, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Time (min)")
                        Spacer()
                        Stepper("\(duration)", value: $duration, in: 1...600, step: 5)
                            .foregroundStyle(Color.pedalActive)
                    }

                    HStack {
                        Text("Elevation (m)")
                        Spacer()
                        TextField("", value: $elevationGain, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section(header: Text("Speed").foregroundStyle(.gray)) {
                    HStack {
                        Text("Average speed")
                        Spacer()
                        TextField("", value: $avgSpeed, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                        Text("km/h")
                    }

                    HStack {
                        Text("Max speed")
                        Spacer()
                        TextField("", value: $maxSpeed, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                        Text("km/h")
                    }
                }

                Section(header: Text("Conditions").foregroundStyle(.gray)) {
                    Picker("Surface", selection: $terrain) {
                        ForEach(Terrain.allCases, id: \.self) { t in
                            Label(t.rawValue, systemImage: t.icon).tag(t)
                        }
                    }
                    .tint(.pedalActive)

                    Picker("Weather", selection: $weather) {
                        ForEach(Weather.allCases, id: \.self) { w in
                            Label(w.rawValue, systemImage: w.icon).tag(w)
                        }
                    }
                    .tint(.pedalActive)
                }

                Section(header: Text("Vitals").foregroundStyle(.gray)) {
                    HStack {
                        Text("Calories")
                        Spacer()
                        TextField("", value: $calories, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Avg heart rate")
                        Spacer()
                        TextField("", value: $avgHeartRate, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                        Text("bpm")
                    }
                }

                Section(header: Text("Notes").foregroundStyle(.gray)) {
                    TextEditor(text: $notes)
                        .frame(height: 80)
                        .foregroundStyle(Color.pedalDark)
                        .tint(.pedalActive)
                }

                Section {
                    Toggle("Add to favorites", isOn: $isFavorite)
                        .tint(.pedalActive)
                }
            }
            .foregroundStyle(Color.pedalDark)
            .scrollContentBackground(.hidden)
            .pedalScreenChrome()
            .navigationTitle("New ride")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color.pedalDark)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save ride") {
                        saveRide()
                    }
                    .bold()
                    .foregroundStyle(Color.pedalActive)
                    .disabled(!canSave)
                }
            }
            .sheet(isPresented: $showAddBike, onDismiss: {
                if selectedBikeId == nil {
                    selectedBikeId = viewModel.bikes.first(where: { $0.isPrimary })?.id
                        ?? viewModel.bikes.first?.id
                }
            }) {
                AddBikeView(viewModel: viewModel) { newBike in
                    selectedBikeId = newBike.id
                }
            }
            .onAppear {
                if selectedBikeId == nil {
                    selectedBikeId = viewModel.bikes.first(where: { $0.isPrimary })?.id
                        ?? viewModel.bikes.first?.id
                }
                if viewModel.bikes.isEmpty {
                    showAddBike = true
                }
            }
        }
    }

    private var canSave: Bool {
        guard let bikeId = selectedBikeId,
              let bike = viewModel.bikes.first(where: { $0.id == bikeId }) else {
            return false
        }
        return distance > 0 && !bike.name.isEmpty
    }

    private func saveRide() {
        guard let bikeId = selectedBikeId,
              let bike = viewModel.bikes.first(where: { $0.id == bikeId }) else { return }

        let trimmedRoute = routeName.trimmingCharacters(in: .whitespacesAndNewlines)
        let ride = Ride(
            id: UUID(),
            date: date,
            distance: distance,
            duration: duration,
            avgSpeed: avgSpeed,
            maxSpeed: maxSpeed,
            elevationGain: elevationGain,
            rideType: rideType,
            terrain: terrain,
            weather: weather,
            bikeId: bikeId,
            bikeName: bike.name,
            calories: calories,
            avgHeartRate: avgHeartRate,
            notes: notes.isEmpty ? nil : notes,
            routeName: trimmedRoute.isEmpty ? nil : trimmedRoute,
            isFavorite: isFavorite,
            createdAt: Date()
        )
        viewModel.addRide(ride)
        dismiss()
    }
}
