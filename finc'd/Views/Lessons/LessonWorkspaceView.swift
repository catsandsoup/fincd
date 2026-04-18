//
//  LessonWorkspaceView.swift
//  finc'd
//

import SwiftUI

struct LessonWorkspaceView: View {
    let question: Question
    let tint: Color

    @State private var selectedTermID: String?
    @State private var showsDetails = false

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

    private var firstStep: LessonStep? {
        steps.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header

            if let firstStep {
                stepRow(firstStep, isPrimary: true)
            }

            DisclosureGroup("More support", isExpanded: $showsDetails) {
                VStack(alignment: .leading, spacing: 16) {
                    let remainingSteps = Array(steps.dropFirst())
                    if !remainingSteps.isEmpty {
                        stepList(remainingSteps)
                    }

                    if !terms.isEmpty {
                        termSlots
                    }

                    conceptNote
                }
                .padding(.top, 10)
            }
            .font(.callout)
            .foregroundStyle(.secondary)
            .tint(.secondary)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.quaternary.opacity(0.08))
        }
        .onChange(of: question.id, initial: true) {
            selectedTermID = terms.first?.id
            showsDetails = false
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            Label("Before you answer", systemImage: "rectangle.and.pencil.and.ellipsis")
                .font(.headline)
                .foregroundStyle(.primary)
            Text("Name the moving parts, then choose the method.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func stepList(_ visibleSteps: [LessonStep]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(visibleSteps) { step in
                stepRow(step, isPrimary: false)
            }
        }
    }

    private func stepRow(_ step: LessonStep, isPrimary: Bool) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: step.systemImage)
                .foregroundStyle(isPrimary ? tint : .secondary)
                .frame(width: 20)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(step.title)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(step.detail)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
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
