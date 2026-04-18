//
//  ContentView.swift
//  finc'd
//

import SwiftData
import SwiftUI

enum SidebarSelection: Hashable {
    case home
    case course(String)
    case progress
    case notebook
    case lesson(String)
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var masteries: [SkillMastery]
    @Query(sort: [SortDescriptor(\AttemptRecord.attemptedAt, order: .reverse)])
    private var attempts: [AttemptRecord]

    @State private var selection: SidebarSelection? = .home

    private var masteryMap: [String: SkillMastery] {
        ProgressResolver.masteryMap(from: masteries)
    }

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection, masteryMap: masteryMap)
                .navigationSplitViewColumnWidth(min: 220, ideal: 250, max: 320)
        } detail: {
            detailView
                .navigationTitle(detailTitle)
        }
        .onReceive(NotificationCenter.default.publisher(for: .continueRecommendedLesson)) { _ in
            selection = .lesson(ProgressResolver.recommendedLesson(masteries: masteryMap).id)
        }
        .onReceive(NotificationCenter.default.publisher(for: .startReview)) { _ in
            selection = .lesson(ProgressResolver.recommendedLesson(masteries: masteryMap).id)
        }
    }

    @ViewBuilder
    private var detailView: some View {
        switch selection ?? .home {
        case .home:
            HomeDashboardView(selection: $selection, masteryMap: masteryMap, attempts: attempts)
        case .course(let id):
            CourseMapView(courseID: id, selection: $selection, masteryMap: masteryMap)
        case .progress:
            ProgressDiagnosticsView(masteryMap: masteryMap)
        case .notebook:
            ReviewNotebookView(selection: $selection, attempts: attempts)
        case .lesson(let id):
            if let lesson = CurriculumCatalog.lessonsByID[id] {
                LessonRunnerView(lesson: lesson) {
                    selection = .course(CurriculumCatalog.unit(id: lesson.unitID)?.courseID ?? "tvm")
                }
            } else {
                ContentUnavailableView("Lesson unavailable", systemImage: "questionmark.folder")
            }
        }
    }

    private var detailTitle: String {
        switch selection ?? .home {
        case .home: "finc'd"
        case .course(let id): CurriculumCatalog.course(id: id)?.title ?? "Course"
        case .progress: "Progress"
        case .notebook: "Notebook"
        case .lesson(let id): CurriculumCatalog.lessonsByID[id]?.title ?? "Lesson"
        }
    }
}
