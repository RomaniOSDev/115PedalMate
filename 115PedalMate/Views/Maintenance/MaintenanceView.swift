//
//  MaintenanceView.swift
//  115PedalMate
//

import SwiftUI

struct MaintenanceView: View {
    @ObservedObject var viewModel: PedalMateViewModel
    @State private var showAdd = false

    private var sortedMaintenance: [BikeMaintenance] {
        viewModel.maintenance.sorted { $0.date > $1.date }
    }

    var body: some View {
        List {
            if sortedMaintenance.isEmpty {
                Section {
                    Text("No service records yet.")
                        .foregroundStyle(.gray)
                        .listRowBackground(Color.clear)
                }
            } else {
                ForEach(sortedMaintenance) { entry in
                    MaintenanceEntryRow(entry: entry)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteMaintenance(entry)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }

            Section {
                Button("Log service") { showAdd = true }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .fontWeight(.semibold)
                    .pedalCTARow(cornerRadius: 16)
                    .foregroundStyle(Color.pedalActive)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                    .disabled(viewModel.bikes.isEmpty)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .pedalScreenChrome()
        .navigationTitle("Maintenance")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showAdd) {
            AddMaintenanceView(viewModel: viewModel)
        }
    }
}

private struct MaintenanceEntryRow: View {
    let entry: BikeMaintenance

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .foregroundStyle(Color.pedalActive)
                Text(entry.bikeName)
                    .font(.headline)
                    .foregroundStyle(Color.pedalDark)
                Spacer()
                Text(formattedShortDate(entry.date))
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Text(entry.maintenanceType)
                .font(.subheadline)
                .foregroundStyle(Color.pedalActive)
            Text("Odometer: \(entry.distance) km")
                .font(.caption)
                .foregroundStyle(.gray)
            if let notes = entry.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
        }
        .padding(16)
        .pedalElevatedCard(cornerRadius: 18)
    }
}
