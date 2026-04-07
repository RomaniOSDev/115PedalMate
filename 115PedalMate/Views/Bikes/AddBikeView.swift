//
//  AddBikeView.swift
//  115PedalMate
//

import SwiftUI

struct AddBikeView: View {
    @ObservedObject var viewModel: PedalMateViewModel
    var onSaved: (Bike) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var type = "Road"
    @State private var color = ""
    @State private var weight: Double?
    @State private var notes = ""
    @State private var isPrimary = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .tint(.pedalActive)
                    TextField("Type", text: $type)
                    TextField("Color", text: $color)
                    HStack {
                        Text("Weight (kg)")
                        Spacer()
                        TextField("", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    }
                }
                Section(header: Text("Notes").foregroundStyle(.gray)) {
                    TextEditor(text: $notes)
                        .frame(height: 80)
                        .tint(.pedalActive)
                }
                Section {
                    Toggle("Set as primary bike", isOn: $isPrimary)
                        .tint(.pedalActive)
                }
            }
            .foregroundStyle(Color.pedalDark)
            .scrollContentBackground(.hidden)
            .pedalScreenChrome()
            .navigationTitle("New bike")
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
                        let bike = Bike(
                            id: UUID(),
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Bike" : name.trimmingCharacters(in: .whitespacesAndNewlines),
                            type: type.isEmpty ? "Road" : type,
                            color: color.isEmpty ? "—" : color,
                            weight: weight,
                            notes: notes.isEmpty ? nil : notes,
                            isPrimary: isPrimary,
                            createdAt: Date()
                        )
                        viewModel.addBike(bike)
                        onSaved(bike)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .foregroundStyle(Color.pedalActive)
                }
            }
        }
    }
}
