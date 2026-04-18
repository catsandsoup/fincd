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
            VStack(alignment: .leading, spacing: 24) {
                header

                focusPanel

                courseStrip
                revisitSection
            }
            .padding(28)
            .frame(maxWidth: 1120, alignment: .leading)
        }
        .background(.background)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("finc'd")
                .font(.largeTitle.weight(.semibold))
            Text("Name the inputs, choose the method, solve the next step.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var focusPanel: some View {
        GlassPanel {
            ViewThatFits {
                HStack(alignment: .top, spacing: 28) {
                    continuePanel
                    Divider()
                    reviewPanel
                }

                VStack(alignment: .leading, spacing: 22) {
                    continuePanel
                    Divider()
                    reviewPanel
                }
            }
        }
    }

    private var continuePanel: some View {
        VStack(alignment: .leading, spacing: 18) {
            Label("Continue", systemImage: recommendedLesson.kind.systemImage)
                .font(.headline)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                Text(recommendedLesson.title)
                    .font(.title.weight(.semibold))
                Text(lessonSubtitle(recommendedLesson))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button {
                selection = .lesson(recommendedLesson.id)
            } label: {
                Label("Open", systemImage: "arrow.right")
            }
            .buttonStyle(PrimaryGlassButtonStyle())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var reviewPanel: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Notebook", systemImage: "book.closed")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(reviewText)
                .font(.title3.weight(.semibold))

            Text("Revisit ideas that need another look.")
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                selection = .lesson(recommendedLesson.id)
            } label: {
                Label("Review", systemImage: "arrow.triangle.2.circlepath")
            }
            .buttonStyle(QuietGlassButtonStyle())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var courseStrip: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Courses")
                .font(.title3.weight(.semibold))

            VStack(spacing: 0) {
                ForEach(CurriculumCatalog.courses) { course in
                    Button {
                        selection = .course(course.id)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: course.symbol)
                                .foregroundStyle(course.tint)
                                .frame(width: 22)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(course.title)
                                    .font(.headline)
                                Text(course.subtitle)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }

                            Spacer()

                            Text(NumberFormatting.confidenceStatus(ProgressResolver.courseConfidence(course.id, masteries: masteryMap)))
                                .font(.headline)
                                .foregroundStyle(.secondary)

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
                    }
                }
            }
        }
    }

    private var revisitSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Skills to Revisit")
                .font(.title3.weight(.semibold))

            if skillsToRevisit.isEmpty {
                Text("No review items yet.")
                    .foregroundStyle(.secondary)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 10)], spacing: 10) {
                    ForEach(skillsToRevisit) { skill in
                        HStack(spacing: 10) {
                            SkillTagView(tag: skill.tag)
                            Text(skill.title)
                                .lineLimit(2)
                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
    }

    private var reviewText: String {
        let reviewCount = attempts.filter { !$0.isCorrect }.count
        if reviewCount == 0 {
            return "Nothing in the notebook yet"
        }
        return "\(reviewCount) item\(reviewCount == 1 ? "" : "s") to revisit"
    }

    private func lessonSubtitle(_ lesson: Lesson) -> String {
        let unit = CurriculumCatalog.unit(id: lesson.unitID)
        let course = unit.flatMap { CurriculumCatalog.course(id: $0.courseID) }
        return [course?.title, unit?.title, NumberFormatting.duration(seconds: lesson.estimatedSeconds)]
            .compactMap { $0 }
            .joined(separator: " - ")
    }
}
