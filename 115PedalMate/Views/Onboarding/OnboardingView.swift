//
//  OnboardingView.swift
//  115PedalMate
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isComplete: Bool

    @State private var page = 0

    private let pages: [OnboardingPageModel] = [
        OnboardingPageModel(
            icon: "figure.outdoor.cycle",
            symbolGradient: [Color.pedalActive, Color(red: 0.1, green: 0.4, blue: 0.3)],
            title: "Log every ride",
            subtitle: "Capture distance, duration, elevation, weather, and surface so your history stays meaningful."
        ),
        OnboardingPageModel(
            icon: "map.circle.fill",
            symbolGradient: [Color.blue.opacity(0.85), Color.pedalActive],
            title: "Bikes, routes & care",
            subtitle: "Manage your fleet, save favorite routes, track service, and link rides to the road you rode."
        ),
        OnboardingPageModel(
            icon: "chart.line.uptrend.xyaxis.circle.fill",
            symbolGradient: [Color.orange.opacity(0.95), Color.pedalActive],
            title: "Goals that move you",
            subtitle: "Set weekly distance targets, run challenges, and watch trends grow in your statistics."
        )
    ]

    var body: some View {
        ZStack {
            onboardingBackdrop

            VStack(spacing: 0) {
                topBar

                TabView(selection: $page) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(model: pages[index])
                            .tag(index)
                            .padding(.horizontal, 24)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .padding(.top, 8)

                bottomControls
                    .padding(.horizontal, 24)
                    .padding(.bottom, 28)
                    .padding(.top, 16)
            }
        }
    }

    private var onboardingBackdrop: some View {
        ZStack {
            Color.pedalBackground
            LinearGradient(
                colors: [
                    Color.pedalActive.opacity(0.2),
                    Color.pedalActive.opacity(0.06),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            LinearGradient(
                colors: [Color.clear, Color.pedalDark.opacity(0.04)],
                startPoint: .center,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
    }

    private var topBar: some View {
        HStack {
            if page > 0 {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        page -= 1
                    }
                } label: {
                    Label("Back", systemImage: "chevron.left")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.pedalDark)
                }
                .accessibilityIdentifier("onboarding_back")
            } else {
                Spacer().frame(width: 44)
            }

            Spacer()

            Button("Skip") {
                finishOnboarding()
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Color.pedalMuted)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 4)
    }

    private var bottomControls: some View {
        VStack(spacing: 12) {
            Button {
                if page >= pages.count - 1 {
                    finishOnboarding()
                } else {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        page += 1
                    }
                }
            } label: {
                Text(page >= pages.count - 1 ? "Get started" : "Next")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(PedalGradients.fab)
                            .overlay {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.28), lineWidth: 1)
                            }
                            .shadow(color: Color.pedalActive.opacity(0.45), radius: 16, x: 0, y: 8)
                            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                    }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier(page >= pages.count - 1 ? "onboarding_get_started" : "onboarding_next")
        }
    }

    private func finishOnboarding() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isComplete = true
        }
    }
}

// MARK: - Page model & view

private struct OnboardingPageModel {
    let icon: String
    let symbolGradient: [Color]
    let title: String
    let subtitle: String
}

private struct OnboardingPageView: View {
    let model: OnboardingPageModel

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 12)

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: model.symbolGradient.map { $0.opacity(0.22) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                    .shadow(color: model.symbolGradient[0].opacity(0.35), radius: 24, x: 0, y: 12)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.9), Color.white.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 160, height: 160)

                Image(systemName: model.icon)
                    .font(.system(size: 72))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(
                        LinearGradient(
                            colors: model.symbolGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            VStack(spacing: 12) {
                Text(model.title)
                    .font(.system(.title, design: .rounded).weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.pedalDark)

                Text(model.subtitle)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.pedalMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 8)

            Spacer(minLength: 24)
        }
    }
}

#Preview {
    OnboardingView(isComplete: .constant(false))
}
