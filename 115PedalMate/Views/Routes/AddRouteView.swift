//
//  AddRouteView.swift
//  115PedalMate
//

import SwiftUI

struct AddRouteView: View {
    @ObservedObject var viewModel: PedalMateViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var distance: Double = 10
    @State private var elevationGain: Int?
    @State private var descriptionText = ""
    @State private var isFavorite = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
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
                        Text("Elevation (m)")
                        Spacer()
                        TextField("", value: $elevationGain, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    }
                }
                Section(header: Text("Description").foregroundStyle(.gray)) {
                    TextEditor(text: $descriptionText)
                        .frame(height: 80)
                        .tint(.pedalActive)
                }
                Section {
                    Toggle("Favorite", isOn: $isFavorite)
                        .tint(.pedalActive)
                }
            }
            .foregroundStyle(Color.pedalDark)
            .scrollContentBackground(.hidden)
            .pedalScreenChrome()
            .navigationTitle("New route")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color.pedalDark)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let route = Route(
                            id: UUID(),
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Route" : name.trimmingCharacters(in: .whitespacesAndNewlines),
                            distance: distance,
                            elevationGain: elevationGain,
                            description: descriptionText.isEmpty ? nil : descriptionText,
                            isFavorite: isFavorite,
                            rides: []
                        )
                        viewModel.addRoute(route)
                        dismiss()
                    }
                    .foregroundStyle(Color.pedalActive)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
