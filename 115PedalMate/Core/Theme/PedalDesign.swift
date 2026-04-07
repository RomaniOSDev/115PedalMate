//
//  PedalDesign.swift
//  115PedalMate
//

import SwiftUI

// MARK: - Gradients

enum PedalGradients {
    static let hero = LinearGradient(
        colors: [
            Color.pedalActive,
            Color(red: 0.12, green: 0.42, blue: 0.32),
            Color(red: 0.08, green: 0.32, blue: 0.28)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let fab = LinearGradient(
        colors: [
            Color(red: 0.22, green: 0.62, blue: 0.40),
            Color(red: 0.12, green: 0.44, blue: 0.30)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardFill = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.97, green: 0.99, blue: 0.98)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardEdge = LinearGradient(
        colors: [
            Color.white.opacity(0.95),
            Color.pedalActive.opacity(0.18)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let sheetSheen = LinearGradient(
        colors: [
            Color.white.opacity(0.55),
            Color.clear
        ],
        startPoint: .top,
        endPoint: .center
    )

    static let barMark = LinearGradient(
        colors: [
            Color.pedalActive.opacity(0.85),
            Color.pedalActive
        ],
        startPoint: .bottom,
        endPoint: .top
    )
}

// MARK: - View modifiers

extension View {
    /// Full-screen backdrop: soft tint + subtle depth toward bottom.
    func pedalScreenChrome() -> some View {
        background {
            ZStack {
                Color.pedalBackground
                LinearGradient(
                    colors: [
                        Color.pedalActive.opacity(0.22),
                        Color.pedalActive.opacity(0.06),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                LinearGradient(
                    colors: [Color.clear, Color.pedalDark.opacity(0.04)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
        }
    }

    /// Raised card: gradient fill, luminous edge, stacked shadows.
    func pedalElevatedCard(cornerRadius: CGFloat = 16) -> some View {
        background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(PedalGradients.cardFill)
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(PedalGradients.sheetSheen)
                        .allowsHitTesting(false)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(PedalGradients.cardEdge, lineWidth: 1)
                }
                .shadow(color: Color.pedalActive.opacity(0.16), radius: 8, x: 0, y: 4)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 12)
                .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
        }
    }

    /// Primary list / form CTA row (Add bike, Log ride, …).
    func pedalCTARow(cornerRadius: CGFloat = 16) -> some View {
        background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color(red: 0.98, green: 1, blue: 0.99)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.pedalActive.opacity(0.45), Color.pedalActive.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
                .shadow(color: Color.pedalActive.opacity(0.22), radius: 14, x: 0, y: 7)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
    }

    /// Floating action button look.
    func pedalFABBackground() -> some View {
        background {
            Circle()
                .fill(PedalGradients.fab)
                .overlay {
                    Circle()
                        .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)
                }
                .shadow(color: Color.pedalActive.opacity(0.5), radius: 14, x: 0, y: 8)
                .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
        }
    }

    /// Hero panel (home header).
    func pedalHeroPanel(cornerRadius: CGFloat = 24) -> some View {
        background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(PedalGradients.hero)
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.22), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .allowsHitTesting(false)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                }
                .shadow(color: Color.pedalActive.opacity(0.45), radius: 20, x: 0, y: 12)
                .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
        }
    }
}
