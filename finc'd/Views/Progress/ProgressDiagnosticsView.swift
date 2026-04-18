//
//  ProgressDiagnosticsView.swift
//  finc'd
//

import SwiftUI

struct ProgressDiagnosticsView: View {
    let masteryMap: [String: SkillMastery]

    @State private var filter: ProgressFilter = .all
    @State private var searchText = ""

    private var skillRows: [SkillProgressRow] {
        CurriculumCatalog.skills.map { skill in
            let unit = CurriculumCatalog.unit(id: skill.unitID)
            let course = unit.flatMap { CurriculumCatalog.course(id: $0.courseID) }
            let mastery = masteryMap[skill.id]
            return SkillProgressRow(
                skill: skill,
                courseTitle: course?.title ?? "Course",
                unitTitle: unit?.title ?? "",
                level: mastery?.level ?? 0,
                attempts: mastery?.attempts ?? 0
            )
        }
    }

    private var filteredRows: [SkillProgressRow] {
        skillRows.filter { row in
            filter.includes(row)
            && (
                searchText.isEmpty
                || row.skill.title.localizedStandardContains(searchText)
                || row.unitTitle.localizedStandardContains(searchText)
                || row.courseTitle.localizedStandardContains(searchText)
            )
        }
    }

    private var averageConfidence: Double {
        guard !CurriculumCatalog.courses.isEmpty else { return 0 }
        let total = CurriculumCatalog.courses.reduce(0.0) { partial, course in
            partial + ProgressResolver.courseConfidence(course.id, masteries: masteryMap)
        }
        return total / Double(CurriculumCatalog.courses.count)
    }

    private var nextSkill: Skill? {
        ProgressResolver.weakestSkills(masteries: masteryMap, limit: 1).first
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                studyGuidance
                courseOverview
                skillListHeader
                skillList
            }
            .padding(28)
            .frame(maxWidth: 1080, alignment: .leading)
        }
        .searchable(text: $searchText, prompt: "Find a skill")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Progress")
                .font(.largeTitle.weight(.semibold))
            Text("Choose the next idea to revisit, then keep the path moving.")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }

    private var studyGuidance: some View {
        GroupBox {
            ViewThatFits {
                HStack(alignment: .top, spacing: 24) {
                    nextStepBlock
                    Divider()
                    directionBlock
                }

                VStack(alignment: .leading, spacing: 18) {
                    nextStepBlock
                    Divider()
                    directionBlock
                }
            }
            .padding(.vertical, 4)
        } label: {
            Label("Study guidance", systemImage: "arrow.forward.circle")
        }
    }

    private var nextStepBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Work on next")
                .font(.headline)

            Text(nextSkill?.title ?? "Start with the first short lesson")
                .font(.title3.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)

            Text(nextSkill.map { LearningCopy.skillGuidance(for: $0, mastery: masteryMap[$0.id]) } ?? "Build the first idea before checking speed or accuracy.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var directionBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current direction")
                .font(.headline)

            Text(NumberFormatting.confidenceStatus(averageConfidence))
                .font(.title3.weight(.semibold))

            ProgressView(value: averageConfidence)
                .accessibilityLabel("Overall study progress")
                .accessibilityValue(NumberFormatting.confidence(averageConfidence))

            Text("\(skillRows.count) ideas are available across the course path.")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var courseOverview: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Study Areas")
                .font(.title2.weight(.semibold))

            VStack(spacing: 0) {
                ForEach(CurriculumCatalog.courses) { course in
                    CourseStudyAreaRow(
                        course: course,
                        confidence: ProgressResolver.courseConfidence(course.id, masteries: masteryMap)
                    )

                    if course.id != CurriculumCatalog.courses.last?.id {
                        Divider()
                            .padding(.leading, 38)
                    }
                }
            }
        }
    }

    private var skillListHeader: some View {
        HStack(alignment: .center, spacing: 16) {
            Text("Ideas to Revisit")
                .font(.title2.weight(.semibold))

            Spacer()

            Picker("Show", selection: $filter) {
                ForEach(ProgressFilter.allCases) { filter in
                    Label(filter.title, systemImage: filter.systemImage)
                        .tag(filter)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            .frame(maxWidth: 520)
        }
    }

    private var skillList: some View {
        VStack(spacing: 0) {
            if filteredRows.isEmpty {
                ContentUnavailableView(
                    "No Matching Ideas",
                    systemImage: "magnifyingglass",
                    description: Text("Try a different filter or search term.")
                )
                .frame(maxWidth: .infinity, minHeight: 260)
            } else {
                ForEach(filteredRows) { row in
                    SkillStudyRow(row: row)

                    if row.id != filteredRows.last?.id {
                        Divider()
                            .padding(.leading, 28)
                    }
                }
            }
        }
    }
}

private enum ProgressFilter: String, CaseIterable, Identifiable {
    case all
    case new
    case practicing
    case ready
    case secure

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: "All"
        case .new: "Start"
        case .practicing: "Practice"
        case .ready: "Ready"
        case .secure: "Settled"
        }
    }

    var systemImage: String {
        switch self {
        case .all: "square.grid.2x2"
        case .new: "sparkle"
        case .practicing: "pencil.and.outline"
        case .ready: "flag"
        case .secure: "checkmark.seal"
        }
    }

    func includes(_ row: SkillProgressRow) -> Bool {
        switch self {
        case .all:
            true
        case .new:
            row.level == 0
        case .practicing:
            (1...2).contains(row.level)
        case .ready:
            row.level == 3
        case .secure:
            row.level >= 4
        }
    }
}

private struct SkillProgressRow: Identifiable {
    let skill: Skill
    let courseTitle: String
    let unitTitle: String
    let level: Int
    let attempts: Int

    var id: String { skill.id }

    var statusTitle: String {
        NumberFormatting.masteryStatus(level: level)
    }

    var tint: Color {
        switch level {
        case 0:
            .secondary
        case 1...2:
            .accentColor
        case 3:
            .accentColor
        default:
            .secondary
        }
    }
}

private struct CourseStudyAreaRow: View {
    let course: Course
    let confidence: Double

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: course.symbol)
                .font(.title3)
                .foregroundStyle(course.tint)
                .frame(width: 26)

            VStack(alignment: .leading, spacing: 7) {
                Text(course.title)
                    .font(.headline)

                Text(course.subtitle)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                ProgressView(value: confidence)
                    .tint(course.tint)
                    .frame(maxWidth: 260)
                    .accessibilityLabel("\(course.title) progress")
                    .accessibilityValue(NumberFormatting.confidence(confidence))
            }

            Spacer(minLength: 16)

            Text(NumberFormatting.confidenceStatus(confidence))
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 12)
    }
}

private struct SkillStudyRow: View {
    let row: SkillProgressRow

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: row.systemImage)
                .font(.callout.weight(.semibold))
                .foregroundStyle(row.tint)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 3) {
                Text(row.skill.title)
                    .font(.headline)
                    .lineLimit(2)

                Text("\(row.courseTitle) / \(row.unitTitle)")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text(LearningCopy.skillGuidance(for: row.skill, mastery: nil, level: row.level))
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 16)

            VStack(alignment: .trailing, spacing: 6) {
                Text(row.statusTitle)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.secondary)

                ProgressView(value: Double(row.level), total: 4)
                    .tint(row.tint)
                    .frame(width: 96)

                if row.attempts > 0 {
                    Text("\(row.attempts) attempt\(row.attempts == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension SkillProgressRow {
    var systemImage: String {
        switch level {
        case 0:
            "circle"
        case 1...2:
            "arrow.triangle.2.circlepath"
        case 3:
            "flag"
        default:
            "checkmark"
        }
    }
}
