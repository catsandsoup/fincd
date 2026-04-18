//
//  ProgressDiagnosticsView.swift
//  finc'd
//

import SwiftUI

struct ProgressDiagnosticsView: View {
    let masteryMap: [String: SkillMastery]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                courseOverview
                skillGrid
            }
            .padding(28)
            .frame(maxWidth: 1120, alignment: .leading)
        }
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

    private var skillGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Skill Map")
                .font(.title2.weight(.semibold))

            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 10) {
                GridRow {
                    Text("Skill")
                        .foregroundStyle(.secondary)
                    Text("Type")
                        .foregroundStyle(.secondary)
                    Text("State")
                        .foregroundStyle(.secondary)
                }

                ForEach(CurriculumCatalog.skills) { skill in
                    GridRow {
                        Text(skill.title)
                            .lineLimit(2)

                        SkillTagView(tag: skill.tag)

                        HStack(spacing: 10) {
                            ProgressView(value: Double(masteryMap[skill.id]?.level ?? 0), total: 4)
                                .frame(width: 130)
                            Text(NumberFormatting.masteryStatus(level: masteryMap[skill.id]?.level ?? 0))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 76, alignment: .trailing)
                        }
                    }
                    Divider()
                        .gridCellColumns(3)
                }
            }
            .padding(16)
            .background(.thinMaterial, in: .rect(cornerRadius: 14))
        }
    }
}
