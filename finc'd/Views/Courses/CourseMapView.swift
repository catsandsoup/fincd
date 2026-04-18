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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                courseHeader

                ForEach(CurriculumCatalog.units(for: courseID)) { unit in
                    UnitSectionView(unit: unit, selection: $selection, masteryMap: masteryMap)
                }
            }
            .padding(28)
            .frame(maxWidth: 1080, alignment: .leading)
        }
    }

    private var courseHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                if let course {
                    Image(systemName: course.symbol)
                        .font(.title2)
                        .foregroundStyle(course.tint)
                }
                Text(course?.title ?? "Course")
                    .font(.largeTitle.weight(.semibold))
            }

            Text(course?.subtitle ?? "")
                .font(.title3)
                .foregroundStyle(.secondary)

            ProgressView(value: ProgressResolver.courseConfidence(courseID, masteries: masteryMap))
                .tint(course?.tint ?? .accentColor)
                .frame(maxWidth: 420)
        }
    }
}

private struct UnitSectionView: View {
    let unit: Unit
    @Binding var selection: SidebarSelection?
    let masteryMap: [String: SkillMastery]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(unit.title)
                    .font(.title2.weight(.semibold))
                Text(unit.subtitle)
                    .foregroundStyle(.secondary)
            }

            LazyVStack(spacing: 10) {
                ForEach(CurriculumCatalog.lessons(for: unit.id)) { lesson in
                    LessonRowButton(
                        lesson: lesson,
                        confidence: ProgressResolver.lessonConfidence(lesson, masteries: masteryMap)
                    ) {
                        selection = .lesson(lesson.id)
                    }
                }
            }
        }
    }
}

private struct LessonRowButton: View {
    let lesson: Lesson
    let confidence: Double
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    ConfidenceRing(
                        progress: confidence,
                        tint: tint,
                        lineWidth: 4
                    )
                    .frame(width: 42, height: 42)

                    Image(systemName: lesson.kind.systemImage)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(tint)
                }

                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 8) {
                        Text(lesson.title)
                            .font(.headline)
                        Text(lesson.kind.title)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }

                    Text(skillLine)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Text(NumberFormatting.duration(seconds: lesson.estimatedSeconds))
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(.quaternary.opacity(0.14), in: .rect(cornerRadius: 12))
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

    private var skillLine: String {
        lesson.skillIDs
            .compactMap { CurriculumCatalog.skill(id: $0)?.title }
            .prefix(2)
            .joined(separator: " - ")
    }
}
