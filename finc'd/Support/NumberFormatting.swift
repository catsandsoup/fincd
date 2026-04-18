//
//  NumberFormatting.swift
//  finc'd
//

import Foundation

enum NumberFormatting {
    static func percent(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...1))) + "%"
    }

    static func confidence(_ value: Double) -> String {
        (value * 100).formatted(.number.precision(.fractionLength(0))) + "%"
    }

    static func confidenceStatus(_ value: Double) -> String {
        switch value {
        case ..<0.05:
            "Not started"
        case ..<0.35:
            "First pass"
        case ..<0.7:
            "Practicing"
        case ..<0.95:
            "Ready"
        default:
            "Secure"
        }
    }

    static func masteryStatus(level: Int) -> String {
        switch level {
        case 0:
            "New"
        case 1:
            "Introduced"
        case 2:
            "Practicing"
        case 3:
            "Ready"
        default:
            "Secure"
        }
    }

    static func duration(seconds: Int) -> String {
        let minutes = max(1, Int(ceil(Double(seconds) / 60.0)))
        return "\(minutes) min"
    }
}
