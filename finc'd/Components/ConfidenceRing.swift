//
//  ConfidenceRing.swift
//  finc'd
//

import SwiftUI

struct ConfidenceRing: View {
    let progress: Double
    let tint: Color
    var lineWidth: CGFloat = 5

    var body: some View {
        ZStack {
            Circle()
                .stroke(.quaternary, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .accessibilityLabel("Confidence")
        .accessibilityValue(NumberFormatting.confidence(progress))
    }
}
