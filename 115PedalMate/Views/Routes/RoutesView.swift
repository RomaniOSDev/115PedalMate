//
//  RoutesView.swift
//  115PedalMate
//

import SwiftUI

struct RoutesView: View {
    @ObservedObject var viewModel: PedalMateViewModel
    @State private var showAddRouteSheet = false
    @State private var selectedRoute: Route?

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.routes) { route in
                    RouteCard(route: route)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteRoute(route)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                viewModel.toggleFavoriteRoute(route)
                            } label: {
                                Label("Favorite", systemImage: "star")
                            }
                            .tint(.pedalActive)
                        }
                        .onTapGesture {
                            selectedRoute = route
                        }
                }

                Section {
                    Button("Add route") {
                        showAddRouteSheet = true
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
            .navigationTitle("Routes")
            .sheet(isPresented: $showAddRouteSheet) {
                AddRouteView(viewModel: viewModel)
            }
            .sheet(item: $selectedRoute) { route in
                NavigationStack {
                    ScrollView {
                        RouteCard(route: route)
                            .padding()
                    }
                    .pedalScreenChrome()
                    .navigationTitle("Route details")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") {
                                selectedRoute = nil
                            }
                        }
                    }
                }
            }
        }
    }
}
