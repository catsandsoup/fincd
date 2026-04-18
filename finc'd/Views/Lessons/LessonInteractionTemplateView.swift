//
//  LessonInteractionTemplateView.swift
//  finc'd
//

import SwiftUI

struct LessonInteractionTemplateView: View {
    let question: Question
    let tint: Color
    @Binding var selectedOptionID: String?
    let isChecked: Bool
    let isLocked: Bool

    private var interaction: QuestionInteraction? {
        question.interaction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let interaction {
                templateHeader(interaction)
            }

            switch interaction?.template {
            case .identifyInputs:
                inputTagGrid
            case .chooseMethod:
                choiceRows
            case .matchPeriod:
                periodRows
            case nil:
                choiceRows
            }
        }
    }

    private func templateHeader(_ interaction: QuestionInteraction) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: interaction.template.systemImage)
                .foregroundStyle(tint)
                .frame(width: 22)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(interaction.template.title)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(interaction.guidance)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var inputTagGrid: some View {
        FlowLayout(spacing: 10) {
            ForEach(question.options) { option in
                optionButton(option, style: .tag)
            }
        }
        .padding(.top, 2)
    }

    private var choiceRows: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(question.options) { option in
                optionButton(option, style: .row)
            }
        }
    }

    private var periodRows: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(question.options) { option in
                optionButton(option, style: .period)
            }
        }
    }

    private func optionButton(_ option: AnswerOption, style: OptionStyle) -> some View {
        Button {
            guard !isLocked else { return }
            selectedOptionID = option.id
        } label: {
            switch style {
            case .tag:
                HStack(spacing: 8) {
                    Image(systemName: optionSymbol(option))
                        .foregroundStyle(optionForeground(option))
                        .accessibilityHidden(true)
                    Text(option.label)
                        .font(.title3.weight(.medium))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .background(optionBackground(option), in: .rect(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(optionBorder(option), lineWidth: selectedOptionID == option.id ? 1.2 : 0.8)
                }

            case .row, .period:
                HStack(spacing: 12) {
                    Image(systemName: optionSymbol(option))
                        .foregroundStyle(optionForeground(option))
                        .frame(width: 18)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: style == .period ? 3 : 0) {
                        Text(option.label)
                            .font(.title3.weight(.medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)

                        if style == .period, let target = interaction?.target {
                            Text(target)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 15)
                .background(optionBackground(option), in: .rect(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(optionBorder(option), lineWidth: selectedOptionID == option.id ? 1.2 : 0.8)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(option.label)
        .accessibilityAddTraits(selectedOptionID == option.id ? .isSelected : [])
    }

    private func optionBackground(_ option: AnswerOption) -> Color {
        if isChecked, option.isCorrect {
            return Color.green.opacity(0.16)
        }

        if isChecked, selectedOptionID == option.id, !option.isCorrect {
            return Color.red.opacity(0.14)
        }

        if selectedOptionID == option.id {
            return tint.opacity(0.16)
        }

        return Color.secondary.opacity(0.08)
    }

    private func optionBorder(_ option: AnswerOption) -> Color {
        if isChecked, option.isCorrect {
            return .green.opacity(0.4)
        }

        if isChecked, selectedOptionID == option.id, !option.isCorrect {
            return .red.opacity(0.36)
        }

        if selectedOptionID == option.id {
            return tint.opacity(0.46)
        }

        return Color.secondary.opacity(0.16)
    }

    private func optionForeground(_ option: AnswerOption) -> Color {
        if isChecked, option.isCorrect {
            return .green
        }

        if isChecked, selectedOptionID == option.id, !option.isCorrect {
            return .red
        }

        return selectedOptionID == option.id ? tint : .secondary
    }

    private func optionSymbol(_ option: AnswerOption) -> String {
        if isChecked, option.isCorrect {
            return "checkmark.circle.fill"
        }

        if isChecked, selectedOptionID == option.id, !option.isCorrect {
            return "xmark.circle.fill"
        }

        return selectedOptionID == option.id ? "largecircle.fill.circle" : "circle"
    }
}

private enum OptionStyle {
    case tag
    case row
    case period
}
