//
//  QuestionScaffolding.swift
//  finc'd
//

import Foundation

struct FormulaTerm: Identifiable, Hashable {
    let symbol: String
    let meaning: String

    var id: String { symbol }
}

struct LessonStep: Identifiable, Hashable {
    let id: Int
    let title: String
    let detail: String
    let systemImage: String
}

enum QuestionScaffolding {
    static func steps(for question: Question) -> [LessonStep] {
        if let interaction = question.interaction {
            return interactionSteps(for: interaction)
        }

        switch question.kind {
        case .choice, .formulaMapping:
            return [
                LessonStep(id: 1, title: "Read the situation", detail: "Name the cash flow, rate, time, or decision before choosing a formula.", systemImage: "text.magnifyingglass"),
                LessonStep(id: 2, title: "Match the idea", detail: conceptPrompt(for: question), systemImage: "point.topleft.down.curvedto.point.bottomright.up"),
                LessonStep(id: 3, title: "Choose deliberately", detail: "Pick the answer that keeps the units and timing consistent.", systemImage: "checkmark.circle")
            ]
        case .numeric:
            return [
                LessonStep(id: 1, title: "Name the inputs", detail: "Write down what each number represents before calculating.", systemImage: "number.square"),
                LessonStep(id: 2, title: "Set the period", detail: "Make the rate, cash flow, and number of periods speak the same language.", systemImage: "calendar.badge.clock"),
                LessonStep(id: 3, title: "Compute and check", detail: "Calculate, then ask whether the size and unit make sense.", systemImage: "equal.circle")
            ]
        }
    }

    static func terms(for question: Question) -> [FormulaTerm] {
        var terms: [FormulaTerm] = []
        let formulaText = question.formula?.latex ?? ""
        let text = [
            formulaText,
            question.context,
            question.prompt
        ].joined(separator: " ")

        addIfPresent("PMT", "One repeated payment per period, not the whole loan or whole investment.", in: text, to: &terms)
        addIfPresent("PV", "Present value: what the cash flows are worth at the valuation date.", in: text, to: &terms)
        addIfPresent("FV", "Future value in time value problems. In bond problems, face value is usually written as F.", in: text, to: &terms)
        addIfPresent("F", "Face value: the bond principal repaid at maturity.", in: formulaText, to: &terms)
        addIfContains("face value", symbol: "F", meaning: "Face value: the bond principal repaid at maturity.", in: text, to: &terms)
        addIfPresent("C", "Coupon dollars paid each coupon period.", in: formulaText, to: &terms)
        addIfContains("coupon", symbol: "C", meaning: "Coupon dollars paid each coupon period.", in: text, to: &terms)
        addIfPresent("D_0", "The dividend already paid.", in: text, to: &terms)
        addIfPresent("D_1", "The next dividend. Constant-growth prices use this in the numerator.", in: text, to: &terms)
        addIfPresent("r_f", "Risk-free rate: the base return before adding risk compensation.", in: text, to: &terms)
        addIfPresent("β", "Beta: sensitivity to market movement, not a percentage return.", in: FormulaFormatter.display(from: text), to: &terms)
        addIfPresent("g", "Growth rate. In a forever model, it must be below the required return.", in: formulaText, to: &terms)
        addIfContains("growth", symbol: "g", meaning: "Growth rate. In a forever model, it must be below the required return.", in: text, to: &terms)
        addIfPresent("m", "Compounding periods per year.", in: formulaText, to: &terms)
        addIfPresent("n", "Number of cash-flow periods in the formula.", in: formulaText, to: &terms)
        addIfPresent("i", "Effective rate per cash-flow period.", in: formulaText, to: &terms)
        addIfPresent("r", "Required return or discount rate. Convert it to the cash-flow period when needed.", in: formulaText, to: &terms)
        addIfContains("yield", symbol: "r", meaning: "Yield or required return used to discount the cash flows.", in: text, to: &terms)

        if terms.isEmpty {
            return fallbackTerms(for: question)
        }

        return Array(terms.prefix(6))
    }

    static func conceptNote(for question: Question) -> String {
        if let interaction = question.interaction {
            switch interaction.template {
            case .identifyInputs:
                return "Most finance mistakes start with a number in the wrong role. Name the input before calculating."
            case .chooseMethod:
                return "The method comes from the wording of the cash flows or return question. Classify first, then compute."
            case .matchPeriod:
                return "The rate used in a formula must match the cash-flow interval. Convert before substituting."
            }
        }

        switch question.primarySkillID {
        case let id where id.hasPrefix("S1.1"):
            return "A quoted annual rate is often not the rate that belongs in the formula. First match the rate period to the cash-flow period."
        case let id where id.hasPrefix("S1.2") || id.hasPrefix("S1.3"):
            return "PMT is one repeated payment. n counts payments, not calendar years unless the payments are yearly."
        case let id where id.hasPrefix("S1.4"):
            return "A deferred cash flow usually needs two moves: value the stream at its own start point, then shift that value to today."
        case let id where id.hasPrefix("S1.5") || id.hasPrefix("S2.6"):
            return "Forever formulas use the next cash flow in the numerator. A dividend already paid does not price the share today."
        case let id where id.hasPrefix("S2.1"):
            return "Face value is the bond principal repaid at maturity. It is not the same idea as future value from compound interest."
        case let id where id.hasPrefix("S2.2"):
            return "Before pricing a bond, compare coupon rate with yield. That tells you whether a premium or discount is sensible."
        case let id where id.hasPrefix("S3."):
            return "Portfolio risk is not just a weighted average of risks. Correlation changes how much diversification helps."
        case let id where id.hasPrefix("S4."):
            return "Beta measures sensitivity to the market. A higher beta raises required return only through the market risk premium."
        case let id where id.hasPrefix("S5."):
            return "Cost of capital work starts by identifying whose money is being priced: debt, equity, preference shares, or the whole firm."
        default:
            return "Start by naming the finance idea in plain language, then use the formula as a check."
        }
    }

    private static func conceptPrompt(for question: Question) -> String {
        if question.primarySkillID.contains("-R") {
            return "Decide what kind of problem this is before touching the arithmetic."
        }
        if question.primarySkillID.contains("-M") {
            return "Map each symbol to a real quantity from the story."
        }
        if question.primarySkillID.contains("-E") {
            return "Use the mapped inputs in the smallest calculation that answers the question."
        }
        if question.primarySkillID.contains("-I") {
            return "Translate the result back into a financial sentence."
        }
        return "Connect the story to the next useful finance move."
    }

    private static func interactionSteps(for interaction: QuestionInteraction) -> [LessonStep] {
        switch interaction.template {
        case .identifyInputs:
            return [
                LessonStep(id: 1, title: "Find the target", detail: "You are looking for \(interaction.target). Read the wording around each number.", systemImage: "scope"),
                LessonStep(id: 2, title: "Ignore nearby distractors", detail: "Rates, periods, totals, and payments can sit close together in the story.", systemImage: "line.3.horizontal.decrease.circle"),
                LessonStep(id: 3, title: "Select one role", detail: "Choose the number that plays this exact role in the formula.", systemImage: "checkmark.circle")
            ]
        case .chooseMethod:
            return [
                LessonStep(id: 1, title: "Classify the situation", detail: "Use the timing and wording before choosing a formula.", systemImage: "list.bullet.rectangle"),
                LessonStep(id: 2, title: "Check the trigger words", detail: "Beginning, end, forever, market, debt, and equity words usually point to the method.", systemImage: "text.magnifyingglass"),
                LessonStep(id: 3, title: "Choose the tool", detail: "Pick the method that fits the structure of the problem.", systemImage: "checkmark.circle")
            ]
        case .matchPeriod:
            return [
                LessonStep(id: 1, title: "Name the cash-flow interval", detail: "Start with when each payment or coupon arrives.", systemImage: "calendar"),
                LessonStep(id: 2, title: "Name the rate interval", detail: "A quoted annual rate may need conversion before the formula.", systemImage: "percent"),
                LessonStep(id: 3, title: "Make them match", detail: interaction.target, systemImage: "equal.circle")
            ]
        }
    }

    private static func fallbackTerms(for question: Question) -> [FormulaTerm] {
        switch question.primarySkillID {
        case let id where id.hasPrefix("S2.1"):
            return [
                FormulaTerm(symbol: "F", meaning: "Face value: principal repaid at maturity."),
                FormulaTerm(symbol: "C", meaning: "Coupon dollars paid each coupon period."),
                FormulaTerm(symbol: "r", meaning: "Yield or required return used to discount the bond.")
            ]
        case let id where id.hasPrefix("S4."):
            return [
                FormulaTerm(symbol: "r_f", meaning: "Risk-free rate."),
                FormulaTerm(symbol: "β", meaning: "Market sensitivity."),
                FormulaTerm(symbol: "E(r_m) - r_f", meaning: "Market risk premium.")
            ]
        default:
            return []
        }
    }

    private static func addIfPresent(
        _ symbol: String,
        _ meaning: String,
        in text: String,
        to terms: inout [FormulaTerm]
    ) {
        guard text.localizedStandardContains(symbol), !terms.contains(where: { $0.symbol == symbol }) else {
            return
        }
        terms.append(FormulaTerm(symbol: symbol, meaning: meaning))
    }

    private static func addIfContains(
        _ phrase: String,
        symbol: String,
        meaning: String,
        in text: String,
        to terms: inout [FormulaTerm]
    ) {
        guard text.localizedStandardContains(phrase), !terms.contains(where: { $0.symbol == symbol }) else {
            return
        }
        terms.append(FormulaTerm(symbol: symbol, meaning: meaning))
    }
}
