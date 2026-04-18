//
//  FormulaView.swift
//  finc'd
//

import SwiftUI

struct FormulaView: View {
    let formula: FormulaDisplay
    @AppStorage("showFormulaSource") private var showFormulaSource = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Formula", systemImage: "function")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(FormulaFormatter.display(from: formula.latex))
                .font(.system(.title2, design: .serif, weight: .semibold))
                .textSelection(.enabled)
                .accessibilityLabel(formula.spoken)
                .fixedSize(horizontal: false, vertical: true)

            if showFormulaSource {
                Text(formula.latex)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 6)
    }
}
