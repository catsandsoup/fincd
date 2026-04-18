//
//  LocalProgressModels.swift
//  finc'd
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: String
    var displayName: String
    var lastActiveAt: Date
    var createdAt: Date

    init(
        id: String = "local",
        displayName: String = "Learner",
        lastActiveAt: Date = .distantPast,
        createdAt: Date = .now
    ) {
        self.id = id
        self.displayName = displayName
        self.lastActiveAt = lastActiveAt
        self.createdAt = createdAt
    }
}

@Model
final class SkillMastery {
    @Attribute(.unique) var skillID: String
    var level: Int
    var strength: Double
    var consecutiveCorrect: Int
    var attempts: Int
    var lastSeenAt: Date
    var nextReviewAt: Date

    init(
        skillID: String,
        level: Int = 0,
        strength: Double = 0,
        consecutiveCorrect: Int = 0,
        attempts: Int = 0,
        lastSeenAt: Date = .distantPast,
        nextReviewAt: Date = .now
    ) {
        self.skillID = skillID
        self.level = level
        self.strength = strength
        self.consecutiveCorrect = consecutiveCorrect
        self.attempts = attempts
        self.lastSeenAt = lastSeenAt
        self.nextReviewAt = nextReviewAt
    }
}

@Model
final class AttemptRecord {
    var id: UUID
    var questionID: String
    var lessonID: String
    var skillID: String
    var prompt: String
    var givenAnswer: String
    var correctAnswer: String
    var isCorrect: Bool
    var diagnosisTag: String?
    var feedback: String
    var hintsUsed: Int
    var attemptedAt: Date

    init(
        id: UUID = UUID(),
        questionID: String,
        lessonID: String,
        skillID: String,
        prompt: String,
        givenAnswer: String,
        correctAnswer: String,
        isCorrect: Bool,
        diagnosisTag: String?,
        feedback: String,
        hintsUsed: Int,
        attemptedAt: Date = .now
    ) {
        self.id = id
        self.questionID = questionID
        self.lessonID = lessonID
        self.skillID = skillID
        self.prompt = prompt
        self.givenAnswer = givenAnswer
        self.correctAnswer = correctAnswer
        self.isCorrect = isCorrect
        self.diagnosisTag = diagnosisTag
        self.feedback = feedback
        self.hintsUsed = hintsUsed
        self.attemptedAt = attemptedAt
    }
}
