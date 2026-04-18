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
                    UnitSectionView(
                        unit: unit,
                        currentLessonID: nextLesson?.id,
                        selection: $selection,
                        masteryMap: masteryMap
                    )
                }
            }
            .padding(.horizontal, 34)
            .padding(.vertical, 30)
            .frame(maxWidth: 1040, alignment: .leading)
        }
    }

    private var courseHeader: some View {
        GroupBox {
            ViewThatFits {
                HStack(alignment: .top, spacing: 24) {
                    courseTitleBlock
                    Spacer(minLength: 24)
                    courseActionBlock
                }

                VStack(alignment: .leading, spacing: 20) {
                    courseTitleBlock
                    courseActionBlock
                }
            }
            .padding(.vertical, 4)
        } label: {
            Label("Course path", systemImage: course?.symbol ?? "graduationcap")
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

            Text("\(lessons.count) short lessons")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }

    private var courseActionBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(courseCue)
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

    private var courseCue: String {
        switch courseConfidence {
        case ..<0.05:
            "Start here"
        case ..<0.95:
            "Keep going"
        default:
            "Ready for review"
        }
    }
}

private struct UnitSectionView: View {
    let unit: Unit
    let currentLessonID: String?
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
                    let confidence = ProgressResolver.lessonConfidence(lesson, masteries: masteryMap)
                    LessonPathRow(
                        lesson: lesson,
                        state: LessonPathState(lessonID: lesson.id, currentLessonID: currentLessonID, confidence: confidence)
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
    let state: LessonPathState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: state.systemImage)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(state.tint(base: tint))
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 5) {
                    Text(lesson.title)
                        .font(.headline)

                    Text(lessonSummary)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 5) {
                    Text(state.title)
                        .font(.callout)
                        .foregroundStyle(state.tint(base: tint))
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

private enum LessonPathState {
    case current
    case done
    case review
    case new

    init(lessonID: String, currentLessonID: String?, confidence: Double) {
        if confidence >= 0.95 {
            self = .done
        } else if lessonID == currentLessonID {
            self = .current
        } else if confidence > 0.05 {
            self = .review
        } else {
            self = .new
        }
    }

    var title: String {
        switch self {
        case .current:
            "Current"
        case .done:
            "Done"
        case .review:
            "Review"
        case .new:
            "New"
        }
    }

    var systemImage: String {
        switch self {
        case .current:
            "play.circle.fill"
        case .done:
            "checkmark.circle.fill"
        case .review:
            "arrow.triangle.2.circlepath.circle"
        case .new:
            "circle"
        }
    }

    func tint(base: Color) -> Color {
        switch self {
        case .current:
            base
        case .done, .review, .new:
            .secondary
        }
    }
}
