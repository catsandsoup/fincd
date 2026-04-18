//
//  LessonRunnerView.swift
//  finc'd
//

import SwiftData
import SwiftUI

struct LessonRunnerView: View {
    let lesson: Lesson
    let onFinish: () -> Void

    @Environment(\.modelContext) private var modelContext
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var queue: [Question] = []
    @State private var currentIndex = 0
    @State private var selectedOptionID: String?
    @State private var numericText = ""
    @State private var feedback: LessonFeedback?
    @State private var hintsShown = 0
    @State private var requeuedQuestionIDs = Set<String>()
    @FocusState private var numericFieldFocused: Bool

    private var currentQuestion: Question? {
        guard queue.indices.contains(currentIndex) else { return nil }
        return queue[currentIndex]
    }

    var body: some View {
        VStack(spacing: 0) {
            if let question = currentQuestion {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        lessonHeader(question: question)
                        questionBody(question)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 26)
                    .padding(.bottom, 34)
                    .frame(maxWidth: 1060, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                actionBar(question)
            } else {
                LessonCompletionView(lesson: lesson, onFinish: onFinish)
            }
        }
        .onAppear {
            if queue.isEmpty {
                queue = CurriculumCatalog.questions(for: lesson)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showLessonHint)) { _ in
            guard let question = currentQuestion else { return }
            showNextHint(question)
        }
        .onReceive(NotificationCenter.default.publisher(for: .checkLessonAnswer)) { _ in
            guard let question = currentQuestion, canCheck(question), feedback?.isCorrect != true else { return }
            check(question)
        }
        .onReceive(NotificationCenter.default.publisher(for: .advanceLessonStep)) { _ in
            guard feedback?.isCorrect == true else { return }
            moveForward()
        }
        .animation(reduceMotion ? nil : .smooth, value: currentIndex)
    }

    private func lessonHeader(question: Question) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(lesson.title)
                        .font(.title.weight(.semibold))
                    Text(headerDetail)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if let skill = CurriculumCatalog.skill(id: question.primarySkillID) {
                    SkillTagView(tag: skill.tag)
                        .opacity(0.72)
                }
            }

            ProgressView(value: Double(currentIndex), total: Double(max(queue.count, 1)))
                .tint(tint)
                .controlSize(.small)
                .accessibilityLabel("Lesson progress")
        }
    }

    private func questionBody(_ question: Question) -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: 24) {
                promptColumn(question)
                    .frame(minWidth: 590, maxWidth: 720, alignment: .leading)

                LessonWorkspaceView(question: question, tint: tint)
                    .frame(width: 270, alignment: .topLeading)
                    .id(question.id)
            }

            VStack(alignment: .leading, spacing: 22) {
                promptColumn(question)
                LessonWorkspaceView(question: question, tint: tint)
                    .id(question.id)
            }
        }
    }

    private func promptColumn(_ question: Question) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 18) {
                    Text(question.context)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(question.prompt)
                        .font(.system(.title, design: .default, weight: .semibold))
                        .fixedSize(horizontal: false, vertical: true)

                    if let formula = question.formula {
                        FormulaView(formula: formula)
                            .padding(.top, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                inputView(question)
            }
            .padding(26)
            .background(.quaternary.opacity(0.12), in: .rect(cornerRadius: 16))

            if hintsShown > 0 {
                hintsView(question)
            }

            if let feedback {
                FeedbackBanner(
                    isCorrect: feedback.isCorrect,
                    message: feedback.message,
                    diagnosisTag: feedback.diagnosisTag
                )
            }
        }
    }

    @ViewBuilder
    private func inputView(_ question: Question) -> some View {
        switch question.kind {
        case .choice, .formulaMapping:
            if question.interaction != nil {
                LessonInteractionTemplateView(
                    question: question,
                    tint: tint,
                    selectedOptionID: $selectedOptionID,
                    isChecked: feedback != nil,
                    isLocked: feedback?.isCorrect == true
                )
            } else {
                legacyChoiceView(question)
            }

        case .numeric:
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                TextField("Answer", text: $numericText)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.title, design: .rounded, weight: .semibold))
                    .frame(width: 260)
                    .disabled(feedback?.isCorrect == true)
                    .focused($numericFieldFocused)
                    .onSubmit {
                        check(question)
                    }

                if let unitSuffix = question.unitSuffix {
                    Text(unitSuffix)
                        .font(.title3.weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityElement(children: .combine)
        }
    }

    private func legacyChoiceView(_ question: Question) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(question.options) { option in
                Button {
                    guard feedback?.isCorrect != true else { return }
                    selectedOptionID = option.id
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: optionSymbol(option))
                            .foregroundStyle(optionForeground(option))
                            .frame(width: 18)
                            .accessibilityHidden(true)

                        Text(option.label)
                            .font(.title3.weight(.medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 15)
                    .background(optionBackground(option), in: .rect(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(optionBorder(option), lineWidth: selectedOptionID == option.id ? 1.2 : 0.8)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(option.label)
                .accessibilityAddTraits(selectedOptionID == option.id ? .isSelected : [])
            }
        }
    }

    private func hintsView(_ question: Question) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(question.hints.prefix(hintsShown).enumerated()), id: \.offset) { index, hint in
                HStack(alignment: .top, spacing: 8) {
                    Text("\(index + 1)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 20)
                    Text(hint)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding(12)
                .background(.quaternary.opacity(0.12), in: .rect(cornerRadius: 12))
            }
        }
    }

    private func actionBar(_ question: Question) -> some View {
        HStack(spacing: 12) {
            Button {
                showNextHint(question)
            } label: {
                Label("Hint", systemImage: "lightbulb")
            }
            .buttonStyle(QuietGlassButtonStyle())
            .keyboardShortcut("/", modifiers: [.command])
            .disabled(hintsShown >= question.hints.count || feedback?.isCorrect == true)

            Spacer()

            if feedback?.isCorrect == true {
                Button {
                    moveForward()
                } label: {
                    Label(isLastQuestion ? "Finish" : "Continue", systemImage: "arrow.right")
                }
                .buttonStyle(PrimaryGlassButtonStyle())
                .keyboardShortcut(.rightArrow, modifiers: [.command])
            } else {
                Button {
                    check(question)
                } label: {
                    Label("Check", systemImage: "checkmark")
                }
                .buttonStyle(PrimaryGlassButtonStyle())
                .keyboardShortcut(.return, modifiers: [.command])
                .disabled(!canCheck(question))
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 16)
        .background(.bar)
    }

    private func optionBackground(_ option: AnswerOption) -> Color {
        if feedback != nil, option.isCorrect {
            return Color.green.opacity(0.16)
        }

        if feedback != nil, selectedOptionID == option.id, !option.isCorrect {
            return Color.red.opacity(0.14)
        }

        if selectedOptionID == option.id {
            return tint.opacity(0.16)
        }

        return Color.secondary.opacity(0.08)
    }

    private func optionBorder(_ option: AnswerOption) -> Color {
        if feedback != nil, option.isCorrect {
            return .green.opacity(0.4)
        }

        if feedback != nil, selectedOptionID == option.id, !option.isCorrect {
            return .red.opacity(0.36)
        }

        if selectedOptionID == option.id {
            return tint.opacity(0.46)
        }

        return Color.secondary.opacity(0.16)
    }

    private func optionForeground(_ option: AnswerOption) -> Color {
        if feedback != nil, option.isCorrect {
            return .green
        }

        if feedback != nil, selectedOptionID == option.id, !option.isCorrect {
            return .red
        }

        return selectedOptionID == option.id ? tint : .secondary
    }

    private func optionSymbol(_ option: AnswerOption) -> String {
        if feedback != nil, option.isCorrect {
            return "checkmark.circle.fill"
        }

        if feedback != nil, selectedOptionID == option.id, !option.isCorrect {
            return "xmark.circle.fill"
        }

        return selectedOptionID == option.id ? "largecircle.fill.circle" : "circle"
    }

    private func showNextHint(_ question: Question) {
        hintsShown = min(question.hints.count, hintsShown + 1)
    }

    private func canCheck(_ question: Question) -> Bool {
        switch question.kind {
        case .choice, .formulaMapping:
            selectedOptionID != nil
        case .numeric:
            !numericText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    private func check(_ question: Question) {
        switch question.kind {
        case .choice, .formulaMapping:
            guard let option = question.options.first(where: { $0.id == selectedOptionID }) else {
                return
            }
            record(
                question: question,
                givenAnswer: option.label,
                correctAnswer: question.options.first(where: \.isCorrect)?.label ?? "",
                isCorrect: option.isCorrect,
                diagnosisTag: option.diagnosisTag,
                message: option.isCorrect ? question.successMessage : option.feedback
            )

        case .numeric:
            let cleaned = numericText
                .replacingOccurrences(of: ",", with: "")
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: "%", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            guard let answer = Double(cleaned), let expected = question.numericAnswer else {
                feedback = LessonFeedback(
                    isCorrect: false,
                    message: "Use a number, then try again.",
                    diagnosisTag: "number_format"
                )
                return
            }

            let tolerance = max(abs(expected) * question.tolerancePercent / 100.0, 0.001)
            let isCorrect = abs(answer - expected) <= tolerance
            record(
                question: question,
                givenAnswer: numericText,
                correctAnswer: expected.formatted(.number.precision(.fractionLength(0...3))),
                isCorrect: isCorrect,
                diagnosisTag: isCorrect ? nil : "calculation_check",
                message: isCorrect ? question.successMessage : "Check the period, the units, and whether the answer should be a rate or a dollar value."
            )
        }
    }

    private func record(
        question: Question,
        givenAnswer: String,
        correctAnswer: String,
        isCorrect: Bool,
        diagnosisTag: String?,
        message: String
    ) {
        let attempt = AttemptRecord(
            questionID: question.id,
            lessonID: lesson.id,
            skillID: question.primarySkillID,
            prompt: question.prompt,
            givenAnswer: givenAnswer,
            correctAnswer: correctAnswer,
            isCorrect: isCorrect,
            diagnosisTag: diagnosisTag,
            feedback: message,
            hintsUsed: hintsShown
        )
        modelContext.insert(attempt)

        do {
            try ProgressResolver.upsertMastery(
                skillID: question.primarySkillID,
                isCorrect: isCorrect,
                usedHint: hintsShown > 0,
                in: modelContext
            )
        } catch {
            feedback = LessonFeedback(
                isCorrect: false,
                message: "The answer was checked, but progress could not be saved.",
                diagnosisTag: nil
            )
            return
        }

        feedback = LessonFeedback(
            isCorrect: isCorrect,
            message: message,
            diagnosisTag: diagnosisTag
        )

        if !isCorrect, !requeuedQuestionIDs.contains(question.id) {
            queue.append(question)
            requeuedQuestionIDs.insert(question.id)
        }
    }

    private func moveForward() {
        guard currentIndex + 1 < queue.count else {
            queue = []
            return
        }

        currentIndex += 1
        selectedOptionID = nil
        numericText = ""
        feedback = nil
        hintsShown = 0
        numericFieldFocused = currentQuestion?.kind == .numeric
    }

    private var headerDetail: String {
        let unit = CurriculumCatalog.unit(id: lesson.unitID)
        let course = unit.flatMap { CurriculumCatalog.course(id: $0.courseID) }
        return [progressLabel, course?.title, unit?.title].compactMap { $0 }.joined(separator: " - ")
    }

    private var progressLabel: String {
        let noun = lesson.kind == .practice || lesson.kind == .check ? "Question" : "Step"
        return "\(noun) \(min(currentIndex + 1, max(queue.count, 1))) of \(max(queue.count, 1))"
    }

    private var tint: Color {
        guard
            let unit = CurriculumCatalog.unit(id: lesson.unitID),
            let course = CurriculumCatalog.course(id: unit.courseID)
        else {
            return .accentColor
        }
        return course.tint
    }

    private var isLastQuestion: Bool {
        currentIndex + 1 >= queue.count
    }
}

private struct LessonFeedback: Equatable {
    let isCorrect: Bool
    let message: String
    let diagnosisTag: String?
}

private struct LessonCompletionView: View {
    let lesson: Lesson
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 22) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)

            VStack(spacing: 8) {
                Text("Lesson Complete")
                    .font(.largeTitle.weight(.semibold))
                Text(lesson.title)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            Button {
                onFinish()
            } label: {
                Label("Back to Course", systemImage: "arrow.left")
            }
            .buttonStyle(PrimaryGlassButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
