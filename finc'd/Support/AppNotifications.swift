//
//  AppNotifications.swift
//  finc'd
//

import Foundation

extension Notification.Name {
    static let continueRecommendedLesson = Notification.Name("continueRecommendedLesson")
    static let startReview = Notification.Name("startReview")
    static let showLessonHint = Notification.Name("showLessonHint")
    static let checkLessonAnswer = Notification.Name("checkLessonAnswer")
    static let advanceLessonStep = Notification.Name("advanceLessonStep")
    static let openHome = Notification.Name("openHome")
    static let openProgress = Notification.Name("openProgress")
    static let openNotebook = Notification.Name("openNotebook")
}
