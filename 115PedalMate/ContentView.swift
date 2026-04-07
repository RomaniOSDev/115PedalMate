//
//  ContentView.swift
//  115PedalMate
//

import SwiftUI

struct ContentView: View {
    @AppStorage("pedalmate_onboarding_complete") private var onboardingComplete = false

    @StateObject private var viewModel = PedalMateViewModel()
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if onboardingComplete {
                mainTabView
            } else {
                OnboardingView(isComplete: $onboardingComplete)
            }
        }
    }

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel, mainTabSelection: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            BikesView(viewModel: viewModel)
                .tabItem {
                    Label("Bikes", systemImage: "bicycle")
                }
                .tag(1)

            RoutesView(viewModel: viewModel)
                .tabItem {
                    Label("Routes", systemImage: "map.fill")
                }
                .tag(2)

            ChallengesView(viewModel: viewModel)
                .tabItem {
                    Label("Challenges", systemImage: "trophy.fill")
                }
                .tag(3)

            StatsView(viewModel: viewModel)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
                .tag(4)
        }
        .onAppear {
            viewModel.loadFromUserDefaults()
        }
        .tint(.pedalActive)
    }
}

#Preview {
    ContentView()
}
