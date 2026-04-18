//
//  FormulaFormatter.swift
//  finc'd
//

import Foundation

enum FormulaFormatter {
    static func display(from latex: String) -> String {
        var text = latex
        let replacements: [(String, String)] = [
            ("\\times", "x"),
            ("\\sum", "Σ"),
            ("\\beta", "β"),
            ("\\sigma", "σ"),
            ("\\rho", "ρ"),
            ("\\frac", "frac"),
            ("\\ rate", " rate"),
            ("\\ ", " ")
        ]

        for (source, target) in replacements {
            text = text.replacingOccurrences(of: source, with: target)
        }

        text = convertFractions(in: text)
        text = text.replacingOccurrences(of: "_{nom}", with: "nom")
        text = text.replacingOccurrences(of: "_{month}", with: "month")
        text = text.replacingOccurrences(of: "_{3y}", with: "3y")
        text = text.replacingOccurrences(of: "_i", with: "i")
        text = text.replacingOccurrences(of: "_m", with: "m")
        text = text.replacingOccurrences(of: "_p", with: "p")
        text = text.replacingOccurrences(of: "_d", with: "d")
        text = text.replacingOccurrences(of: "_e", with: "e")
        text = text.replacingOccurrences(of: "_0", with: "0")
        text = text.replacingOccurrences(of: "_1", with: "1")
        text = text.replacingOccurrences(of: "^2", with: "²")
        text = text.replacingOccurrences(of: "^{-n}", with: "^(-n)")
        text = text.replacingOccurrences(of: "^m", with: "^m")
        text = text.replacingOccurrences(of: "  ", with: " ")
        return text
    }

    private static func convertFractions(in input: String) -> String {
        var text = input
        while let range = text.range(of: "frac{") {
            let numeratorStart = range.upperBound
            guard let numeratorEnd = matchingBrace(in: text, from: numeratorStart) else { break }
            let afterNumerator = text.index(after: numeratorEnd)
            guard afterNumerator < text.endIndex, text[afterNumerator] == "{" else { break }
            let denominatorStart = text.index(after: afterNumerator)
            guard let denominatorEnd = matchingBrace(in: text, from: denominatorStart) else { break }

            let numerator = String(text[numeratorStart..<numeratorEnd])
            let denominator = String(text[denominatorStart..<denominatorEnd])
            text.replaceSubrange(range.lowerBound...denominatorEnd, with: "(\(numerator)) / (\(denominator))")
        }
        return text
    }

    private static func matchingBrace(in text: String, from start: String.Index) -> String.Index? {
        var depth = 0
        var index = start
        while index < text.endIndex {
            let character = text[index]
            if character == "{" {
                depth += 1
            } else if character == "}" {
                if depth == 0 {
                    return index
                }
                depth -= 1
            }
            index = text.index(after: index)
        }
        return nil
    }
}
