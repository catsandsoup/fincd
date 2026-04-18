//
//  CurriculumModels.swift
//  finc'd
//

import Foundation
import SwiftUI

enum SkillTag: String, CaseIterable, Identifiable, Codable {
    case recognition = "R"
    case mapping = "M"
    case execution = "E"
    case interpretation = "I"
    case transfer = "T"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .recognition: "Recognise"
        case .mapping: "Map"
        case .execution: "Execute"
        case .interpretation: "Interpret"
        case .transfer: "Transfer"
        }
    }
}

enum LessonKind: String, Codable {
    case lesson
    case practice
    case check
    case boss
    case review
    case concept

    var title: String {
        switch self {
        case .lesson: "Lesson"
        case .practice: "Practice"
        case .check: "Check"
        case .boss: "Challenge"
        case .review: "Review"
        case .concept: "Concept"
        }
    }

    var systemImage: String {
        switch self {
        case .lesson: "circle.fill"
        case .practice: "circle"
        case .check: "checkmark.square.fill"
        case .boss: "crown.fill"
        case .review: "arrow.triangle.2.circlepath"
        case .concept: "doc.text"
        }
    }
}

enum QuestionKind: String, Codable {
    case choice
    case numeric
    case formulaMapping
}

enum LessonInteractionTemplate: String, Codable, Hashable {
    case identifyInputs
    case chooseMethod
    case matchPeriod

    var title: String {
        switch self {
        case .identifyInputs: "Identify the input"
        case .chooseMethod: "Choose the method"
        case .matchPeriod: "Match the period"
        }
    }

    var systemImage: String {
        switch self {
        case .identifyInputs: "number.square"
        case .chooseMethod: "list.bullet.rectangle"
        case .matchPeriod: "calendar.badge.clock"
        }
    }
}

struct QuestionInteraction: Codable, Hashable {
    let template: LessonInteractionTemplate
    let target: String
    let guidance: String
}

struct Course: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let order: Int
    let tint: Color
    let symbol: String
}

struct Unit: Identifiable, Hashable {
    let id: String
    let courseID: String
    let title: String
    let subtitle: String
    let order: Int
}

struct Skill: Identifiable, Hashable {
    let id: String
    let unitID: String
    let title: String
    let tag: SkillTag
    let prereqSkillIDs: [String]
}

struct Lesson: Identifiable, Hashable {
    let id: String
    let unitID: String
    let title: String
    let kind: LessonKind
    let skillIDs: [String]
    let order: Int
    let estimatedSeconds: Int
    let questionIDs: [String]
}

struct Question: Identifiable, Hashable {
    let id: String
    let lessonID: String
    let kind: QuestionKind
    let interaction: QuestionInteraction?
    let primarySkillID: String
    let context: String
    let prompt: String
    let formula: FormulaDisplay?
    let options: [AnswerOption]
    let numericAnswer: Double?
    let tolerancePercent: Double
    let unitSuffix: String?
    let hints: [String]
    let successMessage: String
}

struct AnswerOption: Identifiable, Hashable {
    let id: String
    let label: String
    let isCorrect: Bool
    let diagnosisTag: String?
    let feedback: String
}

struct FormulaDisplay: Hashable {
    let latex: String
    let spoken: String
}
