//
//  CurriculumCatalogTests.swift
//  finc'dTests
//

import Foundation
import Testing
@testable import finc_d

@MainActor
struct CurriculumCatalogTests {
    @Test func everyLessonQuestionExists() {
        let questionIDs = Set(CurriculumCatalog.questions.map(\.id))

        for lesson in CurriculumCatalog.lessons {
            #expect(!lesson.questionIDs.isEmpty)
            for id in lesson.questionIDs {
                #expect(questionIDs.contains(id))
            }
        }
    }

    @Test func everyQuestionHasCorrectAnswer() {
        for question in CurriculumCatalog.questions {
            switch question.kind {
            case .choice, .formulaMapping:
                #expect(question.options.contains { $0.isCorrect })
            case .numeric:
                #expect(question.numericAnswer != nil)
                #expect(question.tolerancePercent > 0)
            }
        }
    }

    @Test func lessonOrderStartsFromInputsBeforeCalculations() {
        let firstTVMLesson = CurriculumCatalog.lessons(forCourse: "tvm").first
        let firstCAPMLesson = CurriculumCatalog.lessons(forCourse: "capm").first

        #expect(firstTVMLesson?.skillIDs.contains("S1.1-R") == true)
        #expect(firstCAPMLesson?.skillIDs.contains("S4.2-M") == true)
    }

    @Test func formulaFormatterKeepsCoreFinanceSymbolsReadable() {
        let formatted = FormulaFormatter.display(
            from: "E(r_i) = r_f + \\beta_i(E(r_m) - r_f)"
        )

        #expect(formatted.contains("β"))
        #expect(formatted.contains("r"))
    }

    @Test func bondScaffoldingSeparatesFaceValueFromFutureValue() {
        let question = CurriculumCatalog.questions.first { $0.primarySkillID == "S2.1-M" }

        #expect(question != nil)

        let note = question.map { QuestionScaffolding.conceptNote(for: $0) } ?? ""
        let terms = question.map { QuestionScaffolding.terms(for: $0) } ?? []

        #expect(note.localizedStandardContains("not the same idea as future value"))
        #expect(terms.contains { $0.symbol == "F" || $0.meaning.localizedStandardContains("Face value") })
    }
}
