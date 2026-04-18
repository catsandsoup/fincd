//
//  CourseMapView.swift
//  finc'd
//

import SwiftUI

struct CourseMapView: View {
    let courseID: String
    @Binding var selection: SidebarSelection?
    let masteryMap: [String: SkillMastery]

    private var course: Course? {
        CurriculumCatalog.course(id: courseID)
    }

    private var lessons: [Lesson] {
        CurriculumCatalog.lessons(forCourse: courseID)
    }

    private var skills: [Skill] {
        CurriculumCatalog.units(for: courseID).flatMap { unit in
            CurriculumCatalog.skills.filter { $0.unitID == unit.id }
        }
    }

    private var courseConfidence: Double {
        ProgressResolver.courseConfidence(courseID, masteries: masteryMap)
    }

    private var nextLesson: Lesson? {
        lessons.first { ProgressResolver.lessonConfidence($0, masteries: masteryMap) < 0.95 } ?? lessons.first
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                courseHeader

                ForEach(CurriculumCatalog.units(for: courseID)) { unit in
                    UnitSectionView(unit: unit, selection: $selection, masteryMap: masteryMap)
                }
            }
            .padding(.horizontal, 34)
            .padding(.vertical, 30)
            .frame(maxWidth: 1040, alignment: .leading)
        }
    }

    private var courseHeader: some View {
        GlassPanel {
            ViewThatFits {
                HStack(alignment: .center, spacing: 24) {
                    courseTitleBlock
                    Spacer(minLength: 24)
                    courseActionBlock
                }

                VStack(alignment: .leading, spacing: 20) {
                    courseTitleBlock
                    courseActionBlock
                }
            }
        }
    }

    private var courseTitleBlock: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: course?.symbol ?? "graduationcap")
                    .font(.title2)
                    .foregroundStyle(course?.tint ?? .accentColor)
                    .frame(width: 30, height: 30)

                Text(course?.title ?? "Course")
                    .font(.largeTitle.weight(.semibold))
            }

            Text(course?.subtitle ?? "Build the idea from plain language to confident calculation.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            ProgressView(value: courseConfidence)
                .tint(course?.tint ?? .accentColor)
                .frame(maxWidth: 420)
                .accessibilityLabel("Course progress")
                .accessibilityValue(NumberFormatting.confidence(courseConfidence))

            HStack(spacing: 12) {
                Text("\(lessons.count) lessons")
                Text("\(skills.count) skills")
                Text("\(secureSkillCount) secure")
            }
            .font(.callout.weight(.medium))
            .foregroundStyle(.secondary)
        }
    }

    private var courseActionBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(NumberFormatting.confidenceStatus(courseConfidence))
                .font(.title2.weight(.semibold))

            if let nextLesson {
                Text("Next: \(nextLesson.title)")
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Button {
                    selection = .lesson(nextLesson.id)
                } label: {
                    Label("Continue", systemImage: "play.fill")
                }
                .buttonStyle(PrimaryGlassButtonStyle())
            }
        }
        .frame(minWidth: 220, alignment: .leading)
    }

    private var secureSkillCount: Int {
        skills.filter { (masteryMap[$0.id]?.level ?? 0) >= 4 }.count
    }
}

private struct UnitSectionView: View {
    let unit: Unit
    @Binding var selection: SidebarSelection?
    let masteryMap: [String: SkillMastery]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                Text(unit.title)
                    .font(.title2.weight(.semibold))

                Text(unit.subtitle)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(spacing: 0) {
                ForEach(CurriculumCatalog.lessons(for: unit.id)) { lesson in
                    LessonPathRow(
                        lesson: lesson,
                        confidence: ProgressResolver.lessonConfidence(lesson, masteries: masteryMap)
                    ) {
                        selection = .lesson(lesson.id)
                    }

                    if lesson.id != CurriculumCatalog.lessons(for: unit.id).last?.id {
                        Divider()
                            .padding(.leading, 58)
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }
}

private struct LessonPathRow: View {
    let lesson: Lesson
    let confidence: Double
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: lesson.kind.systemImage)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(tint)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(lesson.title)
                            .font(.headline)
                        Text(lesson.kind.title)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }

                    Text(lessonSummary)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 5) {
                    Text(NumberFormatting.confidenceStatus(confidence))
                        .font(.callout.weight(.medium))
                    Text(NumberFormatting.duration(seconds: lesson.estimatedSeconds))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
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

    private var lessonSummary: String {
        lesson.skillIDs
            .compactMap { CurriculumCatalog.skill(id: $0)?.title }
            .prefix(2)
            .joined(separator: " / ")
    }
}
