//
//  ReviewNotebookView.swift
//  finc'd
//

import SwiftUI

struct ReviewNotebookView: View {
    @Binding var selection: SidebarSelection?
    let attempts: [AttemptRecord]

    private var reviewItems: [AttemptRecord] {
        attempts.filter { !$0.isCorrect }
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
                        "Notebook Empty",
                        systemImage: "checkmark.circle",
                        description: Text("Questions that need another look will appear here.")
                    )
                    .frame(maxWidth: .infinity, minHeight: 320)
                } else {
                    tagStrip
                    reviewRows
                }
            }
            .padding(28)
            .frame(maxWidth: 980, alignment: .leading)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notebook")
                .font(.largeTitle.weight(.semibold))
            Text("Review ideas by pattern, then return to the lesson that introduced them.")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }

    private var tagStrip: some View {
        FlowLayout(spacing: 8) {
            ForEach(groupedTags, id: \.0) { tag, count in
                Text("\(tag.replacingOccurrences(of: "_", with: " ")) \(count)")
                    .font(.caption.weight(.medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.quaternary.opacity(0.22), in: .capsule)
            }
        }
    }

    private var reviewRows: some View {
        LazyVStack(spacing: 10) {
            ForEach(reviewItems) { attempt in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(attempt.prompt)
                            .font(.headline)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        if let tag = attempt.diagnosisTag {
                            Text(tag.replacingOccurrences(of: "_", with: " "))
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack(alignment: .top, spacing: 18) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Answer")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(attempt.givenAnswer)
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Expected")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(attempt.correctAnswer)
                        }
                    }

                    Text(attempt.feedback)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Button {
                        selection = .lesson(attempt.lessonID)
                    } label: {
                        Label("Retry Lesson", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(QuietGlassButtonStyle())
                }
                .padding(16)
                .background(.thinMaterial, in: .rect(cornerRadius: 14))
            }
        }
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
