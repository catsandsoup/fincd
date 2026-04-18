//
//  SidebarView.swift
//  finc'd
//

import SwiftUI

struct SidebarView: View {
    @Binding var selection: SidebarSelection?
    let masteryMap: [String: SkillMastery]

    var body: some View {
        List(selection: $selection) {
            Section {
                Label("Home", systemImage: "house")
                    .tag(SidebarSelection.home)
                Label("Progress", systemImage: "gauge.with.dots.needle.bottom.50percent")
                    .tag(SidebarSelection.progress)
                Label("Notebook", systemImage: "book.closed")
                    .tag(SidebarSelection.notebook)
            }

            Section("Courses") {
                ForEach(CurriculumCatalog.courses) { course in
                    SidebarCourseRow(course: course)
                    .tag(SidebarSelection.course(course.id))
                }
            }
        }
        .listStyle(.sidebar)
    }
}

private struct SidebarCourseRow: View {
    let course: Course

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: course.symbol)
                .foregroundStyle(course.tint)
                .frame(width: 18)

            Text(course.title)
                .lineLimit(1)
        }
    }
}
