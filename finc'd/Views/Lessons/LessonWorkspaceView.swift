//
//  LessonWorkspaceView.swift
//  finc'd
//

import SwiftUI

struct LessonWorkspaceView: View {
    let question: Question
    let tint: Color

    @State private var selectedTermID: String?

    private var steps: [LessonStep] {
        QuestionScaffolding.steps(for: question)
    }

    private var terms: [FormulaTerm] {
        QuestionScaffolding.terms(for: question)
    }

    private var selectedTerm: FormulaTerm? {
        guard let selectedTermID else { return terms.first }
        return terms.first { $0.id == selectedTermID } ?? terms.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header
            stepList

            if !terms.isEmpty {
                termSlots
            }

            conceptNote
        }
        .padding(18)
        .background {
            if #available(macOS 26.0, *) {
                Color.clear
                    .glassEffect(.regular, in: .rect(cornerRadius: 18))
            } else {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.thinMaterial)
            }
        }
        .onChange(of: question.id, initial: true) {
            selectedTermID = terms.first?.id
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            Label("Before You Answer", systemImage: "rectangle.and.pencil.and.ellipsis")
                .font(.headline)
            Text("Name the moving parts, then choose the method.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var stepList: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(steps) { step in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: step.systemImage)
                        .foregroundStyle(tint)
                        .frame(width: 20)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(step.title)
                            .font(.callout.weight(.semibold))
                        Text(step.detail)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    private var termSlots: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Symbols")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            FlowLayout(spacing: 8) {
                ForEach(terms) { term in
                    Button {
                        selectedTermID = term.id
                    } label: {
                        Text(term.symbol)
                            .font(.system(.callout, design: .serif, weight: .semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(term.id == selectedTerm?.id ? tint.opacity(0.18) : Color.secondary.opacity(0.10), in: .capsule)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(term.symbol), \(term.meaning)")
                }
            }

            if let selectedTerm {
                Text(selectedTerm.meaning)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity)
            }
        }
    }

    private var conceptNote: some View {
        VStack(alignment: .leading, spacing: 10) {
            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Label("Remember", systemImage: "lightbulb")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(QuestionScaffolding.conceptNote(for: question))
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
