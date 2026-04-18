//
//  GlassPanel.swift
//  finc'd
//

import SwiftUI

struct GlassPanel<Content: View>: View {
    let cornerRadius: CGFloat
    @ViewBuilder var content: Content

    init(cornerRadius: CGFloat = 18, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .background {
                if #available(macOS 26.0, *) {
                    Color.clear
                        .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.regularMaterial)
                }
            }
    }
}

struct PrimaryGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(macOS 26.0, *) {
            configuration.label
                .font(.headline)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .glassEffect(.regular.tint(.accentColor).interactive(), in: .capsule)
                .opacity(configuration.isPressed ? 0.78 : 1)
        } else {
            configuration.label
                .font(.headline)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(.tint, in: .capsule)
                .foregroundStyle(.white)
                .opacity(configuration.isPressed ? 0.78 : 1)
        }
    }
}

struct QuietGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(macOS 26.0, *) {
            configuration.label
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .glassEffect(.regular.interactive(), in: .capsule)
                .opacity(configuration.isPressed ? 0.75 : 1)
        } else {
            configuration.label
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(.thinMaterial, in: .capsule)
                .opacity(configuration.isPressed ? 0.75 : 1)
        }
    }
}
