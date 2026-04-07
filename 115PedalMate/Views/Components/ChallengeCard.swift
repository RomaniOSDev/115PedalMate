//
//  ChallengeCard.swift
//  115PedalMate
//

import SwiftUI

struct ChallengeCard: View {
    let challenge: Challenge

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(challenge.name)
                    .foregroundStyle(Color.pedalDark)
                    .font(.headline)

                Spacer()

                if challenge.isCompleted {
                    Text("Completed!")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .foregroundStyle(Color.pedalActive)
                        .background {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.pedalActive.opacity(0.22),
                                            Color.pedalActive.opacity(0.08)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay {
                                    Capsule()
                                        .strokeBorder(Color.pedalActive.opacity(0.35), lineWidth: 1)
                                }
                                .shadow(color: Color.pedalActive.opacity(0.15), radius: 4, x: 0, y: 2)
                        }
                }
            }

            HStack {
                Text("Distance:")
                    .font(.caption)
                    .foregroundStyle(.gray)

                Text("\(Int(challenge.currentDistance))/\(Int(challenge.targetDistance)) km")
                    .font(.caption)
                    .foregroundStyle(Color.pedalActive)

                Spacer()

                ProgressView(value: challenge.distanceProgress)
                    .tint(.pedalActive)
                    .frame(width: 100, height: 4)
            }

            HStack {
                Text("Days:")
                    .font(.caption)
                    .foregroundStyle(.gray)

                Text("\(challenge.currentDays)/\(challenge.targetDays)")
                    .font(.caption)
                    .foregroundStyle(Color.pedalDark)

                Spacer()

                ProgressView(value: challenge.daysProgress)
                    .tint(.pedalDark)
                    .frame(width: 100, height: 4)
            }

            if let deadline = challenge.deadline {
                Text("Due \(formattedShortDate(deadline))")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
        }
        .padding(16)
        .pedalElevatedCard(cornerRadius: 18)
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.9), Color.pedalActive],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 5)
                .padding(.leading, 10)
                .padding(.vertical, 16)
                .allowsHitTesting(false)
        }
    }
}
