//
//  AddMaintenanceView.swift
//  115PedalMate
//

import SwiftUI

private let maintenanceTypeOptions = ["Cleaning", "Lube", "Tune-up", "Tires", "Other"]

struct AddMaintenanceView: View {
    @ObservedObject var viewModel: PedalMateViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var bikeId: UUID?
    @State private var date = Date()
    @State private var maintenanceType = "Cleaning"
    @State private var odometerKm: Int = 0
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Bike", selection: $bikeId) {
                        Text("Select bike").tag(UUID?.none)
                        ForEach(viewModel.bikes) { bike in
                            Text(bike.name).tag(Optional(bike.id))
                        }
                    }
                    .tint(.pedalActive)

                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                        .tint(.pedalActive)

                    Picker("Service type", selection: $maintenanceType) {
                        ForEach(maintenanceTypeOptions, id: \.self) { Text($0).tag($0) }
                    }
                    .tint(.pedalActive)

                    HStack {
                        Text("Odometer (km)")
                        Spacer()
                        TextField("", value: $odometerKm, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    }
                }
                Section(header: Text("Notes").foregroundStyle(.gray)) {
                    TextEditor(text: $notes)
                        .frame(height: 72)
                        .tint(.pedalActive)
                }
            }
            .foregroundStyle(Color.pedalDark)
            .scrollContentBackground(.hidden)
            .pedalScreenChrome()
            .navigationTitle("Log service")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.pedalDark)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .foregroundStyle(Color.pedalActive)
                        .disabled(bikeId == nil)
                }
            }
            .onAppear {
                if bikeId == nil {
                    bikeId = viewModel.bikes.first(where: { $0.isPrimary })?.id
                        ?? viewModel.bikes.first?.id
                }
                if let id = bikeId {
                    let total = Int(viewModel.bikeStats(id).distance.rounded())
                    odometerKm = max(odometerKm, total)
                }
            }
        }
    }

    private func save() {
        guard let bikeId,
              let bike = viewModel.bikes.first(where: { $0.id == bikeId }) else { return }
        let entry = BikeMaintenance(
            id: UUID(),
            bikeId: bikeId,
            bikeName: bike.name,
            date: date,
            maintenanceType: maintenanceType,
            distance: odometerKm,
            notes: notes.isEmpty ? nil : notes
        )
        viewModel.addMaintenance(entry)
        dismiss()
    }
}
