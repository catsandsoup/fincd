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
        VStack(alignment: .leading, spacing: 22) {
            header
            progressSummary
            courseOverview
            skillTableHeader
            skillTable
        }
        .padding(28)
        .frame(maxWidth: 1180, maxHeight: .infinity, alignment: .topLeading)
        .searchable(text: $searchText, prompt: "Find a skill")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Progress")
                .font(.largeTitle.weight(.semibold))
            Text("See which ideas are new, practiced, ready, or secure.")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }

    private var progressSummary: some View {
        GlassPanel {
            ViewThatFits {
                HStack(alignment: .center, spacing: 24) {
                    SummaryMetric(
                        title: "Overall",
                        value: NumberFormatting.confidence(averageConfidence),
                        detail: NumberFormatting.confidenceStatus(averageConfidence),
                        systemImage: "gauge.with.dots.needle.bottom.50percent"
                    )

                    Divider()

                    SummaryMetric(
                        title: "Secure skills",
                        value: "\(skillRows.filter { $0.level >= 4 }.count)",
                        detail: "\(skillRows.count) total",
                        systemImage: "checkmark.seal"
                    )

                    Divider()

                    VStack(alignment: .leading, spacing: 6) {
                        Label("Best next step", systemImage: "arrow.forward.circle")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        Text(nextSkill?.title ?? "Start with the first short lesson")
                            .font(.title3.weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 18) {
                    SummaryMetric(
                        title: "Overall",
                        value: NumberFormatting.confidence(averageConfidence),
                        detail: NumberFormatting.confidenceStatus(averageConfidence),
                        systemImage: "gauge.with.dots.needle.bottom.50percent"
                    )
                    SummaryMetric(
                        title: "Secure skills",
                        value: "\(skillRows.filter { $0.level >= 4 }.count)",
                        detail: "\(skillRows.count) total",
                        systemImage: "checkmark.seal"
                    )
                }
            }
        }
    }

    private var courseOverview: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 14)], spacing: 14) {
            ForEach(CurriculumCatalog.courses) { course in
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Label(course.title, systemImage: course.symbol)
                            .font(.headline)
                            .foregroundStyle(course.tint)
                        Spacer()
                        Text(NumberFormatting.confidenceStatus(ProgressResolver.courseConfidence(course.id, masteries: masteryMap)))
                            .foregroundStyle(.secondary)
                    }

                    ProgressView(value: ProgressResolver.courseConfidence(course.id, masteries: masteryMap))
                        .tint(course.tint)
                }
                .padding(16)
                .background(.thinMaterial, in: .rect(cornerRadius: 14))
            }
        }
    }

    private var skillTableHeader: some View {
        HStack(alignment: .center, spacing: 16) {
            Text("Skill Map")
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

    private var skillTable: some View {
        Table(filteredRows) {
            TableColumn("Skill") { row in
                VStack(alignment: .leading, spacing: 3) {
                    Text(row.skill.title)
                        .font(.headline)
                        .lineLimit(2)
                    Text("\(row.courseTitle) / \(row.unitTitle)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .padding(.vertical, 4)
            }

            TableColumn("Step") { row in
                SkillTagView(tag: row.skill.tag)
            }

            TableColumn("State") { row in
                VStack(alignment: .leading, spacing: 4) {
                    Text(row.statusTitle)
                    ProgressView(value: Double(row.level), total: 4)
                        .tint(row.tint)
                        .frame(maxWidth: 140)
                }
            }

            TableColumn("Attempts") { row in
                Text(row.attempts.formatted())
                    .foregroundStyle(row.attempts == 0 ? .secondary : .primary)
            }
        }
        .tableStyle(.inset)
        .frame(minHeight: 320)
        .overlay {
            if filteredRows.isEmpty {
                ContentUnavailableView(
                    "No Matching Skills",
                    systemImage: "magnifyingglass",
                    description: Text("Try a different filter or search term.")
                )
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
        case .new: "New"
        case .practicing: "Practicing"
        case .ready: "Ready"
        case .secure: "Secure"
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
            .orange
        case 3:
            .blue
        default:
            .green
        }
    }
}

private struct SummaryMetric: View {
    let title: String
    let value: String
    let detail: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 3) {
                Text(value)
                    .font(.title2.weight(.semibold))
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
