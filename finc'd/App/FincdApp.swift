//
//  FincdApp.swift
//  finc'd
//

import SwiftData
import SwiftUI

@main
struct FincdApp: App {
    private let modelContainer: ModelContainer

    init() {
        let schema = Schema([
            UserProfile.self,
            SkillMastery.self,
            AttemptRecord.self
        ])

        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Unable to open local learning store: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
                .frame(minWidth: 980, minHeight: 680)
        }
        .windowToolbarStyle(.unified)
        .defaultSize(width: 1220, height: 820)
        .windowResizability(.contentMinSize)
        .commands {
            CommandMenu("Learning") {
                Button("Continue Lesson") {
                    NotificationCenter.default.post(name: .continueRecommendedLesson, object: nil)
                }
                .keyboardShortcut("l", modifiers: [.command])

                Divider()

                Button("Show Hint") {
                    NotificationCenter.default.post(name: .showLessonHint, object: nil)
                }
                .keyboardShortcut("/", modifiers: [.command])

                Button("Check Answer") {
                    NotificationCenter.default.post(name: .checkLessonAnswer, object: nil)
                }
                .keyboardShortcut(.return, modifiers: [.command])

                Button("Next Step") {
                    NotificationCenter.default.post(name: .advanceLessonStep, object: nil)
                }
                .keyboardShortcut(.rightArrow, modifiers: [.command])

                Divider()

                Button("Review") {
                    NotificationCenter.default.post(name: .startReview, object: nil)
                }
                .keyboardShortcut("r", modifiers: [.command])

                Button("Open Notebook") {
                    NotificationCenter.default.post(name: .openNotebook, object: nil)
                }
                .keyboardShortcut("n", modifiers: [.command, .option])
            }

            CommandMenu("Navigate") {
                Button("Home") {
                    NotificationCenter.default.post(name: .openHome, object: nil)
                }
                .keyboardShortcut("1", modifiers: [.command])

                Button("Progress") {
                    NotificationCenter.default.post(name: .openProgress, object: nil)
                }
                .keyboardShortcut("2", modifiers: [.command])

                Button("Notebook") {
                    NotificationCenter.default.post(name: .openNotebook, object: nil)
                }
                .keyboardShortcut("3", modifiers: [.command])
            }
        }

        Settings {
            SettingsView()
        }
    }
}
