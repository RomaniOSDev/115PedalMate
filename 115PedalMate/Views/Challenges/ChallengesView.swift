//
//  ChallengesView.swift
//  115PedalMate
//

import SwiftUI

struct ChallengesView: View {
    @ObservedObject var viewModel: PedalMateViewModel
    @State private var showAddChallengeSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.challenges) { challenge in
                    ChallengeCard(challenge: challenge)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteChallenge(challenge)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            if !challenge.isCompleted {
                                Button {
                                    viewModel.completeChallenge(challenge)
                                } label: {
                                    Label("Complete", systemImage: "checkmark")
                                }
                                .tint(.pedalActive)
                            }
                        }
                }

                Section {
                    Button("New challenge") {
                        showAddChallengeSheet = true
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
            .navigationTitle("Challenges")
            .sheet(isPresented: $showAddChallengeSheet) {
                AddChallengeView(viewModel: viewModel)
            }
        }
    }
}
