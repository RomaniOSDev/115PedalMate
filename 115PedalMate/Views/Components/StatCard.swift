//
//  StatCard.swift
//  115PedalMate
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .foregroundStyle(.gray)
                    .font(.caption)
            }

            Text(value)
                .foregroundStyle(Color.pedalDark)
                .font(.title2)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .pedalElevatedCard(cornerRadius: 16)
    }
}
