//
//  LearningCopy.swift
//  finc'd
//

import Foundation

enum LearningCopy {
    static func skillGuidance(for skill: Skill, mastery: SkillMastery?) -> String {
        skillGuidance(for: skill, mastery: mastery, level: mastery?.level ?? 0)
    }

    static func skillGuidance(for skill: Skill, mastery: SkillMastery?, level: Int) -> String {
        switch level {
        case 0:
            return "Start by naming the inputs in plain language."
        case 1...2:
            return "Revisit the setup, then solve one line carefully."
        case 3:
            return "Try a check question and watch the units."
        default:
            return "Keep this in light review while you build the next idea."
        }
    }

    static func patternTitle(for diagnosisTag: String?) -> String {
        guard let diagnosisTag else { return "Needs another pass" }

        switch diagnosisTag {
        case "period_mismatch":
            return "Time periods are mixed"
        case "symbol_confusion":
            return "Symbols need naming"
        case "wrong_tool":
            return "Method choice needs a check"
        case "timing_offset":
            return "Cash-flow timing is shifted"
        case "period_count":
            return "Payment count needs care"
        case "ggm_d0_d1":
            return "Next cash flow, not last cash flow"
        case "ggm_invalid":
            return "Growth assumption breaks the model"
        case "premium_discount_flip":
            return "Price direction is reversed"
        case "weights_unnormalised":
            return "Weights need to sum correctly"
        case "cov_sign":
            return "Movement direction needs care"
        case "cross_term_missing":
            return "Diversification term is missing"
        case "beta_as_return":
            return "Beta is being read as a return"
        case "beta_vs_rho":
            return "Beta and correlation are mixed"
        case "capm_slot_swap":
            return "CAPM inputs are swapped"
        case "sml_direction":
            return "Security Market Line direction is flipped"
        case "measure_swap":
            return "Performance measure needs matching"
        case "book_proxy_overused":
            return "Market data should lead"
        case "book_vs_market_E":
            return "Market value beats book value here"
        case "fcf_vs_ni":
            return "Cash flow is not accounting profit"
        case "divisional_wacc":
            return "Discount rate should match project risk"
        case "number_format":
            return "Answer format needs a quick check"
        case "calculation_check":
            return "Calculation needs another pass"
        default:
            return diagnosisTag
                .replacingOccurrences(of: "_", with: " ")
                .capitalized
        }
    }

    static func patternGuidance(for diagnosisTag: String?) -> String {
        guard let diagnosisTag else {
            return "Revisit the setup, name the quantities, and try the first step again."
        }

        switch diagnosisTag {
        case "period_mismatch":
            return "Find the cash-flow interval first, then convert the rate to that same interval."
        case "symbol_confusion":
            return "Write the symbol name in plain language before putting it into a formula."
        case "wrong_tool":
            return "Pause before calculating and choose the model that matches the cash-flow pattern."
        case "timing_offset":
            return "Ask where the formula places the value, then shift it to today if needed."
        case "ggm_d0_d1":
            return "For a price today, use the next dividend or cash flow in the numerator."
        case "premium_discount_flip":
            return "Compare coupon rate with yield before pricing: higher yield means lower price."
        case "cross_term_missing":
            return "In portfolio risk, the correlation term carries the diversification effect."
        case "beta_as_return", "beta_vs_rho":
            return "Read beta as market sensitivity, not as a percentage return or correlation."
        case "capm_slot_swap":
            return "CAPM adds the risk-free rate once, then beta scales only the market premium."
        case "book_vs_market_E":
            return "WACC weights should reflect current market values when they are available."
        case "fcf_vs_ni":
            return "Start from operating profit, then rebuild cash by adjusting non-cash and investment items."
        case "number_format":
            return "Check whether the answer should be entered as dollars, percent, decimals, or rounded units."
        case "calculation_check":
            return "Keep the setup, then recompute one line at a time and watch the units."
        default:
            return "Return to the concept, name the quantities, and retry the smallest step."
        }
    }

    static func lessonPath(for lesson: Lesson) -> String {
        let unit = CurriculumCatalog.unit(id: lesson.unitID)
        let course = unit.flatMap { CurriculumCatalog.course(id: $0.courseID) }
        return [course?.title, unit?.title]
            .compactMap { $0 }
            .joined(separator: " / ")
    }
}
