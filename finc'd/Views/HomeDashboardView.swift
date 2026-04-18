//
//  HomeDashboardView.swift
//  finc'd
//

import SwiftUI

struct HomeDashboardView: View {
    @Binding var selection: SidebarSelection?
    let masteryMap: [String: SkillMastery]
    let attempts: [AttemptRecord]

    private var recommendedLesson: Lesson {
        ProgressResolver.recommendedLesson(masteries: masteryMap)
    }

    private var skillsToRevisit: [Skill] {
        ProgressResolver.weakestSkills(masteries: masteryMap)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                header
                todaySection
                pathSection
                revisitSection
            }
            .padding(.horizontal, 34)
            .padding(.vertical, 30)
            .frame(maxWidth: 1040, alignment: .leading)
        }
        .background(.background)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("finc'd")
                .font(.largeTitle.weight(.semibold))
            Text("Start with the next small step, then revisit ideas that need another pass.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var todaySection: some View {
        GroupBox {
            ViewThatFits {
                HStack(alignment: .top, spacing: 28) {
                    todayCopy
                    Spacer(minLength: 18)
                    Divider()
                    todayActions
                }

                VStack(alignment: .leading, spacing: 22) {
                    todayCopy
                    Divider()
                    todayActions
                }
            }
            .padding(.vertical, 4)
        } label: {
            Label("Next study step", systemImage: recommendedLesson.kind.systemImage)
        }
    }

    private var todayCopy: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recommendedLesson.title)
                .font(.largeTitle.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)

            Text(lessonSubtitle(recommendedLesson))
                .font(.title3)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var todayActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                selection = .lesson(recommendedLesson.id)
            } label: {
                Label("Continue", systemImage: "play.fill")
            }
            .buttonStyle(PrimaryGlassButtonStyle())

            Text(reviewText)
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if attempts.contains(where: { !$0.isCorrect }) {
                Button {
                    selection = .notebook
                } label: {
                    Label("Open Notebook", systemImage: "book.closed")
                }
                .buttonStyle(QuietGlassButtonStyle())
            }
        }
        .frame(minWidth: 230, alignment: .leading)
    }

    private var pathSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Path")
                .font(.title2.weight(.semibold))

            VStack(spacing: 0) {
                ForEach(CurriculumCatalog.courses) { course in
                    let confidence = ProgressResolver.courseConfidence(course.id, masteries: masteryMap)
                    Button {
                        selection = .course(course.id)
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: course.symbol)
                                .foregroundStyle(course.tint)
                                .font(.title3)
                                .frame(width: 26)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(course.title)
                                    .font(.headline)
                                Text(course.subtitle)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)

                                ProgressView(value: confidence)
                                    .tint(course.tint)
                                    .frame(maxWidth: 220)
                            }

                            Spacer()

                            Text(courseCue(confidence))
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)

                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 10)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)

                    if course.id != CurriculumCatalog.courses.last?.id {
                        Divider()
                            .padding(.leading, 40)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var revisitSection: some View {
        if !skillsToRevisit.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Focus Next")
                    .font(.title2.weight(.semibold))

                VStack(spacing: 0) {
                    ForEach(skillsToRevisit) { skill in
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundStyle(.secondary)
                                .frame(width: 20)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(skill.title)
                                    .font(.headline)
                                    .lineLimit(2)

                                Text(LearningCopy.skillGuidance(for: skill, mastery: masteryMap[skill.id]))
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 12)

                        if skill.id != skillsToRevisit.last?.id {
                            Divider()
                                .padding(.leading, 30)
                        }
                    }
                }
            }
        }
    }

    private var reviewText: String {
        let reviewCount = attempts.filter { !$0.isCorrect }.count
        if reviewCount == 0 {
            return "Your notebook is clear."
        }
        return "\(reviewCount) idea\(reviewCount == 1 ? "" : "s") waiting in your notebook."
    }

    private func lessonSubtitle(_ lesson: Lesson) -> String {
        let unit = CurriculumCatalog.unit(id: lesson.unitID)
        let course = unit.flatMap { CurriculumCatalog.course(id: $0.courseID) }
        return [course?.title, unit?.title, NumberFormatting.duration(seconds: lesson.estimatedSeconds)]
            .compactMap { $0 }
            .joined(separator: " / ")
    }

    private func courseCue(_ confidence: Double) -> String {
        switch confidence {
        case ..<0.05:
            "Start"
        case ..<0.7:
            "Keep going"
        case ..<0.95:
            "Review"
        default:
            "Settled"
        }
    }
}
