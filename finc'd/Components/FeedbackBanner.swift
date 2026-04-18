//
//  FeedbackBanner.swift
//  finc'd
//

import SwiftUI

struct FeedbackBanner: View {
    let isCorrect: Bool
    let message: String
    let diagnosisTag: String?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                .foregroundStyle(isCorrect ? .green : .red)
                .font(.title3)

            VStack(alignment: .leading, spacing: 6) {
                Text(isCorrect ? "Correct" : "Review This Step")
                    .font(.headline)

                Text(message)
                    .foregroundStyle(.secondary)

                if let diagnosisTag {
                    Text(diagnosisTag.replacingOccurrences(of: "_", with: " "))
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.quaternary.opacity(0.35), in: .capsule)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(14)
        .background((isCorrect ? Color.green : Color.red).opacity(0.12), in: .rect(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke((isCorrect ? Color.green : Color.red).opacity(0.28))
        }
    }
}
