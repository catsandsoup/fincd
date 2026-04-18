//
//  SettingsView.swift
//  finc'd
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("showFormulaSource") private var showFormulaSource = false

    var body: some View {
        Form {
            Toggle("Show formula source", isOn: $showFormulaSource)
        }
        .formStyle(.grouped)
        .scenePadding()
        .frame(width: 360)
    }
}
