//
//  ProgressResolver.swift
//  finc'd
//

import Foundation
import SwiftData

enum ProgressResolver {
    static func masteryMap(from masteries: [SkillMastery]) -> [String: SkillMastery] {
        Dictionary(uniqueKeysWithValues: masteries.map { ($0.skillID, $0) })
    }

    static func level(for skillID: String, in masteries: [String: SkillMastery]) -> Int {
        masteries[skillID]?.level ?? 0
    }

    static func lessonConfidence(_ lesson: Lesson, masteries: [String: SkillMastery]) -> Double {
        guard !lesson.skillIDs.isEmpty else { return 0 }
        let total = lesson.skillIDs.reduce(0.0) { partial, skillID in
            partial + Double(level(for: skillID, in: masteries))
        }
        return total / Double(lesson.skillIDs.count * 4)
    }

    static func courseConfidence(_ courseID: String, masteries: [String: SkillMastery]) -> Double {
        let lessons = CurriculumCatalog.lessons(forCourse: courseID)
        guard !lessons.isEmpty else { return 0 }
        let total = lessons.reduce(0.0) { partial, lesson in
            partial + lessonConfidence(lesson, masteries: masteries)
        }
        return total / Double(lessons.count)
    }

    static func isLessonUnlocked(_ lesson: Lesson, masteries: [String: SkillMastery]) -> Bool {
        true
    }

    static func recommendedLesson(masteries: [String: SkillMastery]) -> Lesson {
        let dueSkillIDs = Set(
            masteries.values
                .filter { $0.nextReviewAt <= .now && $0.level > 0 && $0.level < 4 }
                .map(\.skillID)
        )

        if let dueLesson = CurriculumCatalog.lessons.first(where: { lesson in
            lesson.skillIDs.contains { dueSkillIDs.contains($0) }
        }) {
            return dueLesson
        }

        return CurriculumCatalog.lessons.first { lesson in
            lessonConfidence(lesson, masteries: masteries) < 1
        } ?? CurriculumCatalog.firstLesson()
    }

    static func weakestSkills(masteries: [String: SkillMastery], limit: Int = 6) -> [Skill] {
        CurriculumCatalog.skills
            .filter { skill in
                let mastery = masteries[skill.id]
                return mastery == nil || (mastery?.level ?? 0) < 3
            }
            .sorted { left, right in
                level(for: left.id, in: masteries) < level(for: right.id, in: masteries)
            }
            .prefix(limit)
            .map { $0 }
    }

    static func upsertMastery(
        skillID: String,
        isCorrect: Bool,
        usedHint: Bool,
        in context: ModelContext
    ) throws {
        let descriptor = FetchDescriptor<SkillMastery>(
            predicate: #Predicate { $0.skillID == skillID }
        )

        let mastery: SkillMastery
        if let existing = try context.fetch(descriptor).first {
            mastery = existing
        } else {
            let created = SkillMastery(skillID: skillID)
            context.insert(created)
            mastery = created
        }

        mastery.attempts += 1
        mastery.lastSeenAt = .now

        if isCorrect {
            mastery.consecutiveCorrect += 1
            let step = usedHint ? 0.12 : 0.22
            mastery.strength = min(1, mastery.strength + step)

            if !usedHint && mastery.consecutiveCorrect >= 2 {
                mastery.level = min(4, max(1, mastery.level + 1))
            } else {
                mastery.level = max(1, mastery.level)
            }
        } else {
            mastery.consecutiveCorrect = 0
            mastery.strength = max(0, mastery.strength - 0.18)
            mastery.level = max(0, mastery.level - 1)
        }

        mastery.nextReviewAt = nextReviewDate(for: mastery.level, from: .now)
        try context.save()
    }

    private static func nextReviewDate(for level: Int, from date: Date) -> Date {
        let days: Double
        switch level {
        case 0: days = 0.5
        case 1: days = 5
        case 2: days = 10
        case 3: days = 21
        default: days = 60
        }

        return date.addingTimeInterval(days * 24 * 60 * 60)
    }
}
