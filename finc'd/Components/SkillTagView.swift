//
//  SkillTagView.swift
//  finc'd
//

import SwiftUI

struct SkillTagView: View {
    let tag: SkillTag

    var body: some View {
        Text(tag.title)
            .font(.caption.weight(.medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.quaternary.opacity(0.35), in: .capsule)
            .foregroundStyle(.secondary)
            .accessibilityLabel(tag.title)
    }
}
