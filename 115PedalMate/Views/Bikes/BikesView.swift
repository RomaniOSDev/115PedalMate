//
//  BikesView.swift
//  115PedalMate
//

import SwiftUI

struct BikesView: View {
    @ObservedObject var viewModel: PedalMateViewModel
    @State private var showAddBikeSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.bikes) { bike in
                    BikeCard(bike: bike, stats: viewModel.bikeStats(bike.id))
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteBike(bike)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                viewModel.setPrimaryBike(bike)
                            } label: {
                                Label("Primary", systemImage: "star")
                            }
                            .tint(.pedalActive)
                        }
                }

                Section {
                    Button("Add bike") {
                        showAddBikeSheet = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .fontWeight(.semibold)
                    .pedalCTARow(cornerRadius: 16)
                    .foregroundStyle(Color.pedalActive)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .pedalScreenChrome()
            .navigationTitle("My bikes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        MaintenanceView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "wrench.and.screwdriver")
                            .foregroundStyle(Color.pedalActive)
                    }
                    .accessibilityLabel("Maintenance")
                }
            }
            .sheet(isPresented: $showAddBikeSheet) {
                AddBikeView(viewModel: viewModel) { _ in }
            }
        }
    }
}
