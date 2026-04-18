//
//  ReviewNotebookView.swift
//  finc'd
//

import SwiftUI

struct ReviewNotebookView: View {
    @Binding var selection: SidebarSelection?
    let attempts: [AttemptRecord]

    @State private var selectedTag: String?
    @State private var searchText = ""

    private var reviewItems: [AttemptRecord] {
        attempts.filter { !$0.isCorrect }
    }

    private var filteredItems: [AttemptRecord] {
        reviewItems.filter { attempt in
            (selectedTag == nil || attempt.diagnosisTag == selectedTag)
            && (
                searchText.isEmpty
                || attempt.prompt.localizedStandardContains(searchText)
                || attempt.feedback.localizedStandardContains(searchText)
                || attempt.givenAnswer.localizedStandardContains(searchText)
                || attempt.correctAnswer.localizedStandardContains(searchText)
                || LearningCopy.patternTitle(for: attempt.diagnosisTag).localizedStandardContains(searchText)
            )
        }
    }

    private var groupedTags: [(String, Int)] {
        let counts = Dictionary(grouping: reviewItems.compactMap(\.diagnosisTag), by: { $0 })
            .mapValues { $0.count }
        return counts.sorted { $0.value > $1.value }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                if reviewItems.isEmpty {
                    ContentUnavailableView(
                        "Notebook Clear",
                        systemImage: "checkmark.circle",
                        description: Text("Questions that need another look will appear here.")
                    )
                    .frame(maxWidth: .infinity, minHeight: 320)
                } else {
                    filterBar
                    reviewRows
                }
            }
            .padding(28)
            .frame(maxWidth: 1040, alignment: .leading)
        }
        .searchable(text: $searchText, prompt: "Search notebook")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notebook")
                .font(.largeTitle.weight(.semibold))
            Text("Return to ideas that need another pass, one pattern at a time.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(reviewItems.count == 1 ? "1 idea to revisit" : "\(reviewItems.count) ideas to revisit")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }

    private var filterBar: some View {
        HStack(spacing: 12) {
            Text("Review pattern")
                .font(.headline)

            Picker("Review pattern", selection: $selectedTag) {
                Text("All patterns (\(reviewItems.count))")
                    .tag(nil as String?)

                ForEach(groupedTags, id: \.0) { tag, count in
                    Text("\(LearningCopy.patternTitle(for: tag)) (\(count))")
                        .tag(tag as String?)
                }
            }
            .labelsHidden()
            .frame(maxWidth: 340)

            Spacer()
        }
    }

    private var reviewRows: some View {
        LazyVStack(spacing: 0) {
            if filteredItems.isEmpty {
                ContentUnavailableView(
                    "No Matching Notes",
                    systemImage: "magnifyingglass",
                    description: Text("Try a different pattern or search term.")
                )
                .frame(maxWidth: .infinity, minHeight: 260)
            } else {
                ForEach(filteredItems) { attempt in
                    NotebookReviewRow(attempt: attempt) {
                        selection = .lesson(attempt.lessonID)
                    }

                    if attempt.id != filteredItems.last?.id {
                        Divider()
                    }
                }
            }
        }
    }
}

private struct NotebookReviewRow: View {
    let attempt: AttemptRecord
    let retry: () -> Void

    @State private var showsDetails = false

    private var question: Question? {
        CurriculumCatalog.questionsByID[attempt.questionID]
    }

    private var lesson: Lesson? {
        CurriculumCatalog.lessonsByID[attempt.lessonID]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(LearningCopy.patternTitle(for: attempt.diagnosisTag))
                    .font(.headline)

                Spacer()

                Text(attempt.attemptedAt.formatted(.dateTime.month(.abbreviated).day().hour().minute()))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(LearningCopy.patternGuidance(for: attempt.diagnosisTag))
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if let lesson {
                Label(LearningCopy.lessonPath(for: lesson), systemImage: lesson.kind.systemImage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(attempt.prompt)
                .font(.title3.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)

            if let formula = question?.formula {
                FormulaView(formula: formula)
                    .padding(.vertical, 2)
            }

            Button(action: retry) {
                Label("Practice This", systemImage: "arrow.clockwise")
            }
            .buttonStyle(QuietGlassButtonStyle())

            DisclosureGroup("Answer details", isExpanded: $showsDetails) {
                VStack(alignment: .leading, spacing: 12) {
                    ViewThatFits {
                        HStack(alignment: .top, spacing: 18) {
                            answerBlock(title: "Your answer", value: cleaned(attempt.givenAnswer))
                            answerBlock(title: "Expected answer", value: cleaned(attempt.correctAnswer))
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            answerBlock(title: "Your answer", value: cleaned(attempt.givenAnswer))
                            answerBlock(title: "Expected answer", value: cleaned(attempt.correctAnswer))
                        }
                    }

                    Text(attempt.feedback)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 8)
            }
            .font(.callout)
        }
        .padding(.vertical, 16)
    }

    private func answerBlock(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func cleaned(_ value: String) -> String {
        value.isEmpty ? "No answer" : value
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        arrangeSubviews(
            proposal: proposal,
            subviews: subviews
        ).size
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let arrangement = arrangeSubviews(proposal: proposal, subviews: subviews)
        for item in arrangement.items {
            subviews[item.index].place(
                at: CGPoint(x: bounds.minX + item.frame.minX, y: bounds.minY + item.frame.minY),
                proposal: ProposedViewSize(item.frame.size)
            )
        }
    }

    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> Arrangement {
        let maxWidth = proposal.width ?? 600
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var items: [Arrangement.Item] = []

        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            if x > 0, x + size.width > maxWidth {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }

            let frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
            items.append(Arrangement.Item(index: index, frame: frame))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return Arrangement(size: CGSize(width: maxWidth, height: y + rowHeight), items: items)
    }

    private struct Arrangement {
        struct Item {
            let index: Int
            let frame: CGRect
        }

        let size: CGSize
        let items: [Item]
    }
}
