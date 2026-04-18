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
                    .padding(28)
                    .frame(maxWidth: 880, alignment: .leading)
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
        .animation(reduceMotion ? nil : .smooth, value: currentIndex)
    }

    private func lessonHeader(question: Question) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(lesson.title)
                        .font(.largeTitle.weight(.semibold))
                    Text(headerDetail)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if let skill = CurriculumCatalog.skill(id: question.primarySkillID) {
                    SkillTagView(tag: skill.tag)
                }
            }

            ProgressView(value: Double(currentIndex), total: Double(max(queue.count, 1)))
                .tint(tint)
                .accessibilityLabel("Lesson progress")
        }
    }

    private func questionBody(_ question: Question) -> some View {
        VStack(alignment: .leading, spacing: 22) {
            GlassPanel {
                VStack(alignment: .leading, spacing: 18) {
                    Text(question.context)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(question.prompt)
                        .font(.title2.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)

                    if let formula = question.formula {
                        FormulaView(formula: formula)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            inputView(question)

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
            VStack(alignment: .leading, spacing: 10) {
                ForEach(question.options) { option in
                    Button {
                        guard feedback?.isCorrect != true else { return }
                        selectedOptionID = option.id
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: selectedOptionID == option.id ? "largecircle.fill.circle" : "circle")
                                .foregroundStyle(selectedOptionID == option.id ? tint : .secondary)

                            Text(option.label)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(14)
                        .background(optionBackground(option), in: .rect(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }

        case .numeric:
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                TextField("Answer", text: $numericText)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .frame(width: 220)
                    .disabled(feedback?.isCorrect == true)
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
                .background(.quaternary.opacity(0.18), in: .rect(cornerRadius: 12))
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
            .disabled(hintsShown >= question.hints.count || feedback?.isCorrect == true)

            Spacer()

            if feedback?.isCorrect == true {
                Button {
                    moveForward()
                } label: {
                    Label(isLastQuestion ? "Finish" : "Continue", systemImage: "arrow.right")
                }
                .buttonStyle(PrimaryGlassButtonStyle())
            } else {
                Button {
                    check(question)
                } label: {
                    Label("Check", systemImage: "checkmark")
                }
                .buttonStyle(PrimaryGlassButtonStyle())
                .disabled(!canCheck(question))
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 16)
        .background(.bar)
    }

    private func optionBackground(_ option: AnswerOption) -> Color {
        if feedback?.isCorrect == true, option.isCorrect {
            return Color.green.opacity(0.16)
        }

        if selectedOptionID == option.id {
            return tint.opacity(0.16)
        }

        return Color.secondary.opacity(0.08)
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
    }

    private var headerDetail: String {
        let unit = CurriculumCatalog.unit(id: lesson.unitID)
        let course = unit.flatMap { CurriculumCatalog.course(id: $0.courseID) }
        return [course?.title, unit?.title].compactMap { $0 }.joined(separator: " - ")
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
