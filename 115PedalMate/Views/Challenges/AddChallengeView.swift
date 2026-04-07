//
//  AddChallengeView.swift
//  115PedalMate
//

import SwiftUI

struct AddChallengeView: View {
    @ObservedObject var viewModel: PedalMateViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var targetDistance: Double = 100
    @State private var targetDays = 7
    @State private var hasDeadline = false
    @State private var deadline = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .tint(.pedalActive)
                }
                Section(header: Text("Targets").foregroundStyle(.gray)) {
                    HStack {
                        Text("Distance (km)")
                        Spacer()
                        TextField("", value: $targetDistance, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    }
                    Stepper("Active days: \(targetDays)", value: $targetDays, in: 1...30)
                        .tint(.pedalActive)
                }
                Section {
                    Toggle("Deadline", isOn: $hasDeadline)
                        .tint(.pedalActive)
                    if hasDeadline {
                        DatePicker("Due date", selection: $deadline, displayedComponents: .date)
                            .tint(.pedalActive)
                    }
                }
            }
            .foregroundStyle(Color.pedalDark)
            .scrollContentBackground(.hidden)
            .pedalScreenChrome()
            .navigationTitle("New challenge")
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
                        let challenge = Challenge(
                            id: UUID(),
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Challenge" : name.trimmingCharacters(in: .whitespacesAndNewlines),
                            targetDistance: targetDistance,
                            currentDistance: 0,
                            targetDays: targetDays,
                            currentDays: 0,
                            deadline: hasDeadline ? deadline : nil,
                            isCompleted: false,
                            createdAt: Date()
                        )
                        viewModel.addChallenge(challenge)
                        dismiss()
                    }
                    .foregroundStyle(Color.pedalActive)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
