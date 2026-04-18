//
//  FormulaView.swift
//  finc'd
//

import SwiftUI

struct FormulaView: View {
    let formula: FormulaDisplay
    @AppStorage("showFormulaSource") private var showFormulaSource = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(FormulaFormatter.display(from: formula.latex))
                .font(.system(.title3, design: .serif, weight: .semibold))
                .textSelection(.enabled)
                .accessibilityLabel(formula.spoken)

            if showFormulaSource {
                Text(formula.latex)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }
        }
        .padding(.vertical, 6)
    }
}
