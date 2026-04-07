//
//  SettingsView.swift
//  115PedalMate
//

import StoreKit
import SwiftUI
import UIKit

struct SettingsView: View {
    var body: some View {
        List {
            Section {
                Button {
                    rateApp()
                } label: {
                    Label("Rate us", systemImage: "star.fill")
                        .foregroundStyle(Color.pedalDark)
                }

                Button {
                    openPolicy(.privacyPolicy)
                } label: {
                    Label("Privacy policy", systemImage: "hand.raised.fill")
                        .foregroundStyle(Color.pedalDark)
                }

                Button {
                    openPolicy(.termsOfUse)
                } label: {
                    Label("Terms of use", systemImage: "doc.text.fill")
                        .foregroundStyle(Color.pedalDark)
                }
            } header: {
                Text("Support & legal")
                    .foregroundStyle(Color.pedalMuted)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .pedalScreenChrome()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .tint(.pedalActive)
    }

    private func openPolicy(_ link: AppExternalLink) {
        guard let url = link.url else { return }
        UIApplication.shared.open(url)
    }

    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
