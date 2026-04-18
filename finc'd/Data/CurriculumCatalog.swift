//
//  CurriculumCatalog.swift
//  finc'd
//

import Foundation
import SwiftUI

enum CurriculumCatalog {
    static let courses: [Course] = [
        Course(
            id: "tvm",
            title: "Time Value",
            subtitle: "Rates, annuities, perpetuities, and loan payments.",
            order: 1,
            tint: .blue,
            symbol: "timer"
        ),
        Course(
            id: "valuation",
            title: "Valuation",
            subtitle: "Bonds, dividends, growth, and price intuition.",
            order: 2,
            tint: .teal,
            symbol: "chart.line.uptrend.xyaxis"
        ),
        Course(
            id: "risk",
            title: "Risk & Portfolios",
            subtitle: "Returns, variance, correlation, diversification, Sharpe.",
            order: 3,
            tint: .green,
            symbol: "point.3.connected.trianglepath.dotted"
        ),
        Course(
            id: "capm",
            title: "CAPM",
            subtitle: "Beta, the market premium, SML, and performance measures.",
            order: 4,
            tint: .indigo,
            symbol: "function"
        ),
        Course(
            id: "wacc",
            title: "Cost of Capital",
            subtitle: "Cost of debt, equity, preference shares, WACC, and FCF.",
            order: 5,
            tint: .orange,
            symbol: "building.columns"
        )
    ]

    static let units: [Unit] = [
        Unit(id: "tvm.rates", courseID: "tvm", title: "Rates Before Formulas", subtitle: "Make the time period match the cash flow.", order: 1),
        Unit(id: "tvm.annuities", courseID: "tvm", title: "Annuities Without Timing Traps", subtitle: "PV, FV, PMT, due, and deferred cash flows.", order: 2),
        Unit(id: "tvm.perpetuities", courseID: "tvm", title: "Finite vs Forever", subtitle: "Perpetuities, growth, and sanity checks.", order: 3),

        Unit(id: "valuation.bonds", courseID: "valuation", title: "Bond Building Blocks", subtitle: "Face value, coupons, yield, and maturity.", order: 1),
        Unit(id: "valuation.equity", courseID: "valuation", title: "Equity Cash Flows", subtitle: "Dividends, growth, terminal value, and PVGO.", order: 2),

        Unit(id: "risk.returns", courseID: "risk", title: "Return and Risk", subtitle: "Expected return, variance, standard deviation.", order: 1),
        Unit(id: "risk.portfolios", courseID: "risk", title: "Portfolios", subtitle: "Weights, correlation, diversification, and Sharpe.", order: 2),

        Unit(id: "capm.inputs", courseID: "capm", title: "CAPM Inputs", subtitle: "Spot r_f, beta, and the market risk premium first.", order: 1),
        Unit(id: "capm.interpret", courseID: "capm", title: "Equilibrium and Performance", subtitle: "SML direction, alpha, Treynor, and Sharpe.", order: 2),

        Unit(id: "wacc.inputs", courseID: "wacc", title: "Component Costs", subtitle: "Debt, equity, preference shares, and tax shields.", order: 1),
        Unit(id: "wacc.wacc", courseID: "wacc", title: "WACC and Free Cash Flow", subtitle: "Market weights and project risk.", order: 2)
    ]

    static let skills: [Skill] = [
        Skill(id: "S1.1-R", unitID: "tvm.rates", title: "Recognise when rates need conversion", tag: .recognition, prereqSkillIDs: []),
        Skill(id: "S1.1-M", unitID: "tvm.rates", title: "Map nominal rate and compounding frequency", tag: .mapping, prereqSkillIDs: ["S1.1-R"]),
        Skill(id: "S1.1-E", unitID: "tvm.rates", title: "Compute an effective periodic rate", tag: .execution, prereqSkillIDs: ["S1.1-M"]),
        Skill(id: "S1.2-R", unitID: "tvm.annuities", title: "Recognise an ordinary annuity", tag: .recognition, prereqSkillIDs: ["S1.1-E"]),
        Skill(id: "S1.2-M", unitID: "tvm.annuities", title: "Identify PMT, n, and i", tag: .mapping, prereqSkillIDs: ["S1.2-R"]),
        Skill(id: "S1.2-E", unitID: "tvm.annuities", title: "Compute present value of an annuity", tag: .execution, prereqSkillIDs: ["S1.2-M"]),
        Skill(id: "S1.3-E", unitID: "tvm.annuities", title: "Solve for a loan payment", tag: .execution, prereqSkillIDs: ["S1.2-E"]),
        Skill(id: "S1.4-R", unitID: "tvm.annuities", title: "Distinguish ordinary, due, and deferred timing", tag: .recognition, prereqSkillIDs: ["S1.2-R"]),
        Skill(id: "S1.4-E", unitID: "tvm.annuities", title: "Shift a deferred cash-flow value to today", tag: .execution, prereqSkillIDs: ["S1.4-R"]),
        Skill(id: "S1.5-R", unitID: "tvm.perpetuities", title: "Recognise forever cash flows", tag: .recognition, prereqSkillIDs: ["S1.2-R"]),
        Skill(id: "S1.5-M", unitID: "tvm.perpetuities", title: "Separate next cash flow from current cash flow", tag: .mapping, prereqSkillIDs: ["S1.5-R"]),
        Skill(id: "S1.5-E", unitID: "tvm.perpetuities", title: "Compute perpetuity and growth values", tag: .execution, prereqSkillIDs: ["S1.5-M"]),

        Skill(id: "S2.1-M", unitID: "valuation.bonds", title: "Identify face value, coupon, yield, and maturity", tag: .mapping, prereqSkillIDs: ["S1.2-M"]),
        Skill(id: "S2.1-E", unitID: "valuation.bonds", title: "Compute coupon dollars per period", tag: .execution, prereqSkillIDs: ["S2.1-M"]),
        Skill(id: "S2.2-R", unitID: "valuation.bonds", title: "Classify premium, discount, and par bonds", tag: .recognition, prereqSkillIDs: ["S2.1-E"]),
        Skill(id: "S2.2-M", unitID: "valuation.bonds", title: "Match coupon and yield frequency", tag: .mapping, prereqSkillIDs: ["S2.1-E"]),
        Skill(id: "S2.2-E", unitID: "valuation.bonds", title: "Price a bond as coupons plus face value", tag: .execution, prereqSkillIDs: ["S2.2-M"]),
        Skill(id: "S2.6-M", unitID: "valuation.equity", title: "Choose D1 instead of D0", tag: .mapping, prereqSkillIDs: ["S1.5-M"]),
        Skill(id: "S2.6-E", unitID: "valuation.equity", title: "Compute a constant-growth stock price", tag: .execution, prereqSkillIDs: ["S2.6-M"]),
        Skill(id: "S2.7-E", unitID: "valuation.equity", title: "Discount a terminal value from the right year", tag: .execution, prereqSkillIDs: ["S2.6-E"]),

        Skill(id: "S3.1-E", unitID: "risk.returns", title: "Compute expected return", tag: .execution, prereqSkillIDs: []),
        Skill(id: "S3.2-E", unitID: "risk.returns", title: "Compute variance and standard deviation", tag: .execution, prereqSkillIDs: ["S3.1-E"]),
        Skill(id: "S3.2-I", unitID: "risk.returns", title: "Interpret covariance and correlation", tag: .interpretation, prereqSkillIDs: ["S3.2-E"]),
        Skill(id: "S3.4-M", unitID: "risk.portfolios", title: "Check portfolio weights", tag: .mapping, prereqSkillIDs: ["S3.1-E"]),
        Skill(id: "S3.4-E", unitID: "risk.portfolios", title: "Compute portfolio expected return", tag: .execution, prereqSkillIDs: ["S3.4-M"]),
        Skill(id: "S3.5-M", unitID: "risk.portfolios", title: "Identify the diversification cross term", tag: .mapping, prereqSkillIDs: ["S3.4-E"]),
        Skill(id: "S3.5-E", unitID: "risk.portfolios", title: "Compute two-stock portfolio risk", tag: .execution, prereqSkillIDs: ["S3.5-M"]),

        Skill(id: "S4.1-I", unitID: "capm.inputs", title: "Interpret beta as market sensitivity", tag: .interpretation, prereqSkillIDs: ["S3.2-I"]),
        Skill(id: "S4.2-M", unitID: "capm.inputs", title: "Identify r_f, beta, and the market premium", tag: .mapping, prereqSkillIDs: ["S4.1-I"]),
        Skill(id: "S4.2-E", unitID: "capm.inputs", title: "Compute expected return with CAPM", tag: .execution, prereqSkillIDs: ["S4.2-M"]),
        Skill(id: "S4.3-I", unitID: "capm.interpret", title: "Read above and below the SML", tag: .interpretation, prereqSkillIDs: ["S4.2-E"]),
        Skill(id: "S4.5-R", unitID: "capm.interpret", title: "Choose Sharpe, Treynor, or Jensen's alpha", tag: .recognition, prereqSkillIDs: ["S4.2-E"]),

        Skill(id: "S5.1-R", unitID: "wacc.inputs", title: "Choose a cost of debt estimate", tag: .recognition, prereqSkillIDs: ["S2.2-E"]),
        Skill(id: "S5.1-E", unitID: "wacc.inputs", title: "Apply the after-tax cost of debt", tag: .execution, prereqSkillIDs: ["S5.1-R"]),
        Skill(id: "S5.3-R", unitID: "wacc.inputs", title: "Choose CAPM or dividend-implied equity cost", tag: .recognition, prereqSkillIDs: ["S4.2-E", "S2.6-E"]),
        Skill(id: "S5.4-M", unitID: "wacc.wacc", title: "Use market values in capital weights", tag: .mapping, prereqSkillIDs: ["S5.1-E"]),
        Skill(id: "S5.4-E", unitID: "wacc.wacc", title: "Compute WACC", tag: .execution, prereqSkillIDs: ["S5.4-M"]),
        Skill(id: "S5.5-E", unitID: "wacc.wacc", title: "Rebuild free cash flow", tag: .execution, prereqSkillIDs: ["S5.4-E"])
    ]

    static let lessons: [Lesson] = [
        Lesson(id: "tvm.rate.start", unitID: "tvm.rates", title: "Match the Period", kind: .lesson, skillIDs: ["S1.1-R", "S1.1-M"], order: 1, estimatedSeconds: 120, questionIDs: ["q.tvm.rate.1", "q.tvm.rate.2", "q.tvm.rate.3"]),
        Lesson(id: "tvm.rate.compute", unitID: "tvm.rates", title: "Convert Before Comparing", kind: .practice, skillIDs: ["S1.1-E"], order: 2, estimatedSeconds: 160, questionIDs: ["q.tvm.rate.4", "q.tvm.rate.5"]),
        Lesson(id: "tvm.annuity.basics", unitID: "tvm.annuities", title: "Timeline First, Formula Second", kind: .lesson, skillIDs: ["S1.2-R", "S1.2-M", "S1.2-E"], order: 3, estimatedSeconds: 210, questionIDs: ["q.tvm.annuity.1", "q.tvm.annuity.2", "q.tvm.annuity.3", "q.tvm.annuity.4", "q.tvm.annuity.5"]),
        Lesson(id: "tvm.deferred", unitID: "tvm.annuities", title: "Shifted Cash Flows", kind: .boss, skillIDs: ["S1.4-R", "S1.4-E", "S1.2-E"], order: 4, estimatedSeconds: 300, questionIDs: ["q.tvm.defer.1", "q.tvm.defer.2", "q.tvm.defer.3"]),
        Lesson(id: "tvm.forever", unitID: "tvm.perpetuities", title: "Forever Needs Next Period", kind: .lesson, skillIDs: ["S1.5-R", "S1.5-M", "S1.5-E"], order: 5, estimatedSeconds: 180, questionIDs: ["q.tvm.perp.1", "q.tvm.perp.2", "q.tvm.perp.3"]),

        Lesson(id: "valuation.bond.anatomy", unitID: "valuation.bonds", title: "Bond Terms First", kind: .lesson, skillIDs: ["S2.1-M", "S2.1-E"], order: 1, estimatedSeconds: 130, questionIDs: ["q.bond.1", "q.bond.2", "q.bond.3"]),
        Lesson(id: "valuation.bond.price", unitID: "valuation.bonds", title: "Price Direction Before Price", kind: .practice, skillIDs: ["S2.2-R", "S2.2-M", "S2.2-E"], order: 2, estimatedSeconds: 240, questionIDs: ["q.bond.4", "q.bond.5", "q.bond.6"]),
        Lesson(id: "valuation.equity.ggm", unitID: "valuation.equity", title: "Next Dividend, Not Last Dividend", kind: .lesson, skillIDs: ["S2.6-M", "S2.6-E"], order: 3, estimatedSeconds: 190, questionIDs: ["q.equity.1", "q.equity.2", "q.equity.3"]),

        Lesson(id: "risk.expected", unitID: "risk.returns", title: "Expected Return", kind: .lesson, skillIDs: ["S3.1-E"], order: 1, estimatedSeconds: 120, questionIDs: ["q.risk.1", "q.risk.2"]),
        Lesson(id: "risk.variance", unitID: "risk.returns", title: "Variance Is Squared", kind: .practice, skillIDs: ["S3.2-E", "S3.2-I"], order: 2, estimatedSeconds: 180, questionIDs: ["q.risk.3", "q.risk.4"]),
        Lesson(id: "risk.portfolio", unitID: "risk.portfolios", title: "Where Diversification Lives", kind: .boss, skillIDs: ["S3.4-M", "S3.4-E", "S3.5-M", "S3.5-E"], order: 3, estimatedSeconds: 300, questionIDs: ["q.port.1", "q.port.2", "q.port.3"]),

        Lesson(id: "capm.inputs", unitID: "capm.inputs", title: "Spot the Inputs", kind: .lesson, skillIDs: ["S4.1-I", "S4.2-M"], order: 1, estimatedSeconds: 150, questionIDs: ["q.capm.1", "q.capm.2", "q.capm.3"]),
        Lesson(id: "capm.compute", unitID: "capm.inputs", title: "Beta Scales the Premium", kind: .practice, skillIDs: ["S4.2-E"], order: 2, estimatedSeconds: 160, questionIDs: ["q.capm.4", "q.capm.5"]),
        Lesson(id: "capm.sml", unitID: "capm.interpret", title: "Read the Security Market Line", kind: .check, skillIDs: ["S4.3-I", "S4.5-R"], order: 3, estimatedSeconds: 190, questionIDs: ["q.capm.6", "q.capm.7"]),

        Lesson(id: "wacc.debt", unitID: "wacc.inputs", title: "Debt Costs Less After Tax", kind: .lesson, skillIDs: ["S5.1-R", "S5.1-E"], order: 1, estimatedSeconds: 140, questionIDs: ["q.wacc.1", "q.wacc.2"]),
        Lesson(id: "wacc.weight", unitID: "wacc.wacc", title: "Weights Use Market Values", kind: .practice, skillIDs: ["S5.3-R", "S5.4-M", "S5.4-E"], order: 2, estimatedSeconds: 220, questionIDs: ["q.wacc.3", "q.wacc.4", "q.wacc.5"]),
        Lesson(id: "wacc.fcf", unitID: "wacc.wacc", title: "Free Cash Flow Is Not Profit", kind: .boss, skillIDs: ["S5.5-E", "S5.4-E"], order: 3, estimatedSeconds: 260, questionIDs: ["q.wacc.6", "q.wacc.7"])
    ]

    static let questions: [Question] = [
        choice("q.tvm.rate.1", "tvm.rate.start", "S1.1-R", "A loan payment happens monthly. The quoted loan rate is 4.8% per year compounded daily.", "Before using an annuity formula, what should you do first?", nil, [
            option("Convert the daily-compounded annual rate into an effective monthly rate.", true, nil, "Yes. The cash-flow interval is monthly, so the rate used in the formula must be monthly."),
            option("Use 4.8% directly because it is already annual.", false, "period_mismatch", "The annuity formula needs the rate per cash-flow period, not the quoted annual rate."),
            option("Divide 4.8% by 30 because months have about 30 days.", false, "period_mismatch", "Daily compounding needs compounding math, not a rough day count.")
        ], ["Find the cash-flow interval before touching the formula.", "A monthly repayment needs a monthly effective rate."], "The formula can wait until the period is matched."),

        choice("q.tvm.rate.2", "tvm.rate.start", "S1.1-M", "A deposit advertises 4.9% per year compounded semi-annually.", "In the nominal-rate conversion, what is m?", nil, [
            option("2", true, nil, "Correct. Semi-annually means two compounding periods per year."),
            option("6", false, "symbol_confusion", "Six months is the length of each period. m is the number of compounding periods per year."),
            option("4.9", false, "symbol_confusion", "4.9% is the quoted rate. m is the compounding frequency.")
        ], ["m counts periods per year.", "Semi-annually is twice per year."], "m = 2 for semi-annual compounding."),

        choice("q.tvm.rate.3", "tvm.rate.start", "S1.1-R", "Two bank accounts quote different compounding frequencies.", "Which rate is better for comparing them?", nil, [
            option("Effective annual rate", true, nil, "Correct. EAR puts both offers on a common annual basis."),
            option("The one with the bigger quoted rate", false, "wrong_tool", "A lower quoted rate can win if it compounds more often."),
            option("The monthly repayment rate", false, "wrong_tool", "Monthly rates help loan payments, but deposits quoted for annual comparison need EAR.")
        ], ["Comparisons need a common unit.", "Use one annual effective rate for each option."], "EAR makes the comparison fair."),

        numeric("q.tvm.rate.4", "tvm.rate.compute", "S1.1-E", "Option B pays 4.9% per year compounded semi-annually.", "Compute the effective annual rate as a percent.", FormulaDisplay(latex: "EAR = (1 + r_{nom}/m)^m - 1", spoken: "EAR equals one plus nominal rate over m, raised to m, minus one."), 4.960, 0.6, "%", ["Semi-annual means m=2.", "Use (1 + 0.049 / 2)^2 - 1."], "Yes. This is about 4.96% effective per year."),

        numeric("q.tvm.rate.5", "tvm.rate.compute", "S1.1-E", "A loan is quoted at 4.8% per year compounded daily, but repayments are monthly.", "What effective monthly rate should enter the annuity formula? Give a percent.", FormulaDisplay(latex: "i_{month} = (1 + 0.048/365)^{365/12} - 1", spoken: "Monthly rate equals daily growth accumulated over one twelfth of a year."), 0.401, 1.0, "%", ["Do not use 4.8% as the period rate.", "Accumulate the daily rate over 365/12 days."], "Right. The monthly rate is about 0.401%."),

        templateChoice("q.tvm.annuity.1", "tvm.annuity.basics", "S1.2-R", .chooseMethod, "Timing words", "Classify the cash-flow pattern before choosing a formula.", "A renter pays the same amount at the end of every month for five years.", "What kind of cash-flow pattern is this?", nil, [
            option("Ordinary annuity", true, nil, "Correct. Equal cash flows at the end of each regular period."),
            option("Annuity due", false, "timing_offset", "An annuity due pays at the beginning of each period."),
            option("Growing perpetuity", false, "wrong_tool", "This has a fixed number of payments and no growth.")
        ], ["Look for equal amounts and regular timing.", "End of period means ordinary."], "Ordinary annuities pay at period end."),

        templateChoice("q.tvm.annuity.2", "tvm.annuity.basics", "S1.2-M", .identifyInputs, "PMT", "Select the repeated cash flow, not the total or the rate.", "You will receive $500 at the end of each month for five years. The effective monthly rate is 0.5%.", "Which value is PMT?", nil, [
            option("$500", true, nil, "Correct. PMT is one repeated monthly cash flow."),
            option("0.5%", false, "symbol_confusion", "That is the monthly rate, usually written as i."),
            option("Five years", false, "period_count", "That helps find the number of payments, but it is not PMT.")
        ], ["PMT means one repeated payment.", "Do not use the total of all payments as PMT."], "PMT is the $500 paid each month."),

        templateChoice("q.tvm.annuity.3", "tvm.annuity.basics", "S1.2-M", .matchPeriod, "Formula rate must match the monthly payment interval.", "Match the rate period to the payment period before calculating.", "Payments arrive monthly. The annual quote has already been converted to 0.5% effective per month.", "Which rate belongs in the annuity formula?", nil, [
            option("0.5% per month", true, nil, "Correct. The formula rate must match the monthly payment period."),
            option("6% per year", false, "period_mismatch", "That annual rate does not match the monthly cash-flow interval."),
            option("30% over five years", false, "period_mismatch", "The formula needs a rate per payment period, not a whole-horizon rate.")
        ], ["Find the payment interval first.", "Monthly payments need a monthly formula rate."], "Use the monthly rate in the formula."),

        numeric("q.tvm.annuity.4", "tvm.annuity.basics", "S1.2-E", "You receive $500 at the end of each month for five years. The effective monthly rate is 0.5%.", "What is the present value of the payments?", FormulaDisplay(latex: "PV = PMT \\times \\frac{1 - (1+i)^{-n}}{i}", spoken: "Present value equals payment times one minus one plus i to the negative n, divided by i."), 25862.83, 0.5, "$", ["Five years of monthly payments gives n = 60.", "Use i = 0.005, not 0.06."], "Correct. The present value is about $25,863."),

        choice("q.tvm.annuity.5", "tvm.annuity.basics", "S1.2-E", "The undiscounted payments total $30,000.", "Should the present value be more or less than the simple total?", nil, [
            option("Less than $30,000", true, nil, "Correct. Future payments are discounted, so their value today is below the simple total."),
            option("Exactly $30,000", false, "discounting_ignored", "That ignores the time value of money."),
            option("More than $30,000", false, "discounting_direction", "Discounting future payments reduces their value today.")
        ], ["Compare today's value with the future dollars added together.", "A positive discount rate pulls future cash flows below the simple total."], "Present value should be below the undiscounted total."),

        choice("q.tvm.defer.1", "tvm.deferred", "S1.4-R", "A project pays $1m every 3 years. The first cash flow is in 1.5 years.", "Which description fits best?", nil, [
            option("A deferred annuity", true, nil, "Yes. The equal cash flows exist, but the first one is shifted away from a normal period boundary."),
            option("An ordinary annuity starting today", false, "timing_offset", "No cash flow happens today."),
            option("A growing perpetuity", false, "wrong_tool", "The cash flows do not grow and there are only 15 of them.")
        ], ["The payments are equal and finite.", "The first cash flow is shifted."], "This is a deferred annuity problem."),

        numeric("q.tvm.defer.2", "tvm.deferred", "S1.1-E", "A rate is 8.5% per year compounded monthly. Cash flows arrive every 3 years.", "What effective 3-year rate should be used? Give a percent.", FormulaDisplay(latex: "i_{3y} = (1 + 0.085/12)^{36} - 1", spoken: "Three-year rate equals the monthly growth factor raised to 36 months, minus one."), 28.943, 0.7, "%", ["Three years has 36 monthly compounding periods.", "Raise the monthly growth factor to 36."], "Correct. The 3-year effective rate is about 28.94%."),

        choice("q.tvm.defer.3", "tvm.deferred", "S1.4-E", "You have valued the 15 cash flows at the point just before the first cash flow. The first cash flow is 1.5 years from today.", "What is the final timing move?", nil, [
            option("Discount the value back 1.5 years to today.", true, nil, "Correct. The value still sits in the future, so bring it back to today."),
            option("Compound it forward 1.5 years.", false, "timing_offset", "That moves farther away from today."),
            option("Do nothing because the annuity formula already gives today's value.", false, "timing_offset", "The annuity formula valued the stream at its own start point, not necessarily today.")
        ], ["Ask: where does the formula place the value?", "If the value is in the future, discount it back."], "A shifted annuity needs a timing shift after the annuity value."),

        choice("q.tvm.perp.1", "tvm.forever", "S1.5-R", "A preferred share pays $1.20 every year forever.", "Which model is the cleanest fit?", nil, [
            option("Perpetuity", true, nil, "Correct. Equal cash flows continue forever."),
            option("Ordinary annuity", false, "wrong_tool", "An annuity has a finite number of payments."),
            option("Growing annuity", false, "wrong_tool", "The cash flow does not grow, and it does not end.")
        ], ["Forever is the key word.", "Equal and forever means simple perpetuity."], "A level forever cash flow is a perpetuity."),

        choice("q.tvm.perp.2", "tvm.forever", "S1.5-M", "A share paid a $1.00 dividend yesterday and dividends grow at 4% forever.", "Which dividend belongs in the growing-perpetuity numerator for today's price?", nil, [
            option("$1.04", true, nil, "Correct. The numerator is next period's dividend."),
            option("$1.00", false, "ggm_d0_d1", "That is the dividend already paid. Use the next dividend."),
            option("4%", false, "symbol_confusion", "Growth is in the denominator, not the cash-flow numerator.")
        ], ["The numerator is the next cash flow.", "Multiply yesterday's dividend by 1 + g."], "Growing perpetuity uses the next cash flow."),

        numeric("q.tvm.perp.3", "tvm.forever", "S1.5-E", "A constant $80 cash flow arrives every year forever. The required return is 10%.", "What is the present value?", FormulaDisplay(latex: "PV = PMT / i", spoken: "Present value equals payment divided by the required return."), 800, 0.5, "$", ["Use the decimal rate, 0.10.", "80 divided by 0.10."], "Correct. A level perpetuity worth $80 per year at 10% is $800."),

        choice("q.bond.1", "valuation.bond.anatomy", "S2.1-M", "A bond has a $100 face value, 9% annual coupon rate, 5 years to maturity, and 11% yield.", "Which number is the face value?", nil, [
            option("$100", true, nil, "Correct. Face value is the principal repaid at maturity."),
            option("9%", false, "symbol_confusion", "That is the coupon rate."),
            option("11%", false, "symbol_confusion", "That is the market required yield.")
        ], ["Face value is a dollar amount.", "It is repaid at maturity."], "Face value is the promised principal."),

        numeric("q.bond.2", "valuation.bond.anatomy", "S2.1-E", "A $100 face value bond pays a 9% annual coupon in two equal payments per year.", "How many dollars is each coupon payment?", FormulaDisplay(latex: "C = coupon\\ rate \\times F / m", spoken: "Coupon dollars per period equal coupon rate times face value divided by payment frequency."), 4.50, 0.2, "$", ["Annual coupon dollars are 9% of $100.", "Split the annual coupon into two payments."], "Correct. The bond pays $4.50 every six months."),

        choice("q.bond.3", "valuation.bond.anatomy", "S2.1-M", "A bond's yield to maturity is the market's required return for that bond.", "Where does the yield go in the pricing formula?", nil, [
            option("It is the discount rate per coupon period.", true, nil, "Yes. Convert it to the coupon period before discounting."),
            option("It is the coupon dollar payment.", false, "symbol_confusion", "The coupon comes from coupon rate times face value."),
            option("It is the face value paid at maturity.", false, "symbol_confusion", "Face value is the principal amount, not the yield.")
        ], ["Yield prices the cash flows.", "Coupon rate creates cash flows; yield discounts them."], "Yield is the discount rate."),

        choice("q.bond.4", "valuation.bond.price", "S2.2-R", "A bond's coupon rate is 6%. Its yield to maturity is 8%.", "Before pricing, how should it trade relative to face value?", nil, [
            option("Discount", true, nil, "Correct. Investors require more than the coupon pays, so price must fall below face value."),
            option("Premium", false, "premium_discount_flip", "Premium happens when the coupon rate is above the yield."),
            option("Par", false, "premium_discount_flip", "Par happens when coupon rate and yield match.")
        ], ["Compare coupon rate to yield.", "If yield is higher, price is lower."], "Yield above coupon means discount."),

        choice("q.bond.5", "valuation.bond.price", "S2.2-M", "Coupons are semi-annual and the yield is 11% per year compounded semi-annually.", "What per-period yield belongs in the bond formula?", nil, [
            option("5.5%", true, nil, "Correct. Divide the quoted semi-annual compounded annual yield by two."),
            option("11%", false, "period_mismatch", "11% is annual. Each six-month period uses half of it."),
            option("22%", false, "period_mismatch", "That doubles in the wrong direction.")
        ], ["Coupon period is six months.", "Semi-annual compounding gives two periods per year."], "Use 5.5% per six-month period."),

        numeric("q.bond.6", "valuation.bond.price", "S2.2-E", "A $100 face value bond pays $4.50 every six months for 5 years. The six-month yield is 5.5%.", "What is the approximate bond price?", FormulaDisplay(latex: "P = C\\frac{1-(1+r)^{-n}}{r} + \\frac{F}{(1+r)^n}", spoken: "Price equals the coupon annuity plus the present value of face value."), 92.46, 0.8, "$", ["There are 10 six-month periods.", "Price coupons as an annuity, then add the discounted face value."], "Correct. It trades below face value because the yield is above the coupon rate."),

        choice("q.equity.1", "valuation.equity.ggm", "S2.6-M", "A company paid a $1.23 dividend yesterday. Dividends are expected to grow at 9% per year.", "For today's constant-growth price, which dividend is D1?", nil, [
            option("$1.34", true, nil, "Correct. D1 is the next dividend: $1.23 x 1.09."),
            option("$1.23", false, "ggm_d0_d1", "That was already paid. Price today uses the next dividend."),
            option("9%", false, "symbol_confusion", "That is the growth rate, not the dividend.")
        ], ["D0 was yesterday.", "D1 is one growth step after D0."], "The next dividend goes in the numerator."),

        numeric("q.equity.2", "valuation.equity.ggm", "S2.6-E", "Next year's dividend is $1.34, the required return is 15%, and growth is 9%.", "What is the stock price?", FormulaDisplay(latex: "P_0 = D_1 / (r_e - g)", spoken: "Price equals next dividend divided by required return minus growth."), 22.33, 0.8, "$", ["Use decimal rates: 0.15 and 0.09.", "Divide 1.34 by 0.06."], "Correct. Constant growth turns a growing dividend stream into one price."),

        choice("q.equity.3", "valuation.equity.ggm", "S2.6-E", "A model has required return 8% and perpetual growth 10%.", "What should you do?", nil, [
            option("Stop. The constant-growth formula does not apply.", true, nil, "Correct. A forever growth rate above the required return makes the model break."),
            option("Use 8% - 10% in the denominator anyway.", false, "ggm_invalid", "That gives a negative denominator for a growing dividend stream."),
            option("Use 10% - 8% because the bigger number should go first.", false, "ggm_invalid", "Changing the formula hides the problem rather than fixing it.")
        ], ["Check r > g before computing.", "Forever growth cannot outrun the required return in this model."], "Always sanity-check r and g."),

        numeric("q.risk.1", "risk.expected", "S3.1-E", "A stock returns 31% with probability 0.1, 13% with 0.3, 12% with 0.4, and -9% with 0.2.", "What is the expected return?", FormulaDisplay(latex: "E(r) = \\sum p_i r_i", spoken: "Expected return is the probability-weighted average return."), 9.9, 0.6, "%", ["Multiply each return by its probability.", "Add the weighted returns."], "Correct. The probability-weighted return is 9.9%."),

        choice("q.risk.2", "risk.expected", "S3.1-E", "Probabilities in a return table are 0.2, 0.3, and 0.6.", "What should you notice before computing expected return?", nil, [
            option("They sum to 1.1, so something must be fixed first.", true, nil, "Correct. Probabilities need to sum to 1."),
            option("The largest probability should be ignored.", false, "weights_unnormalised", "All valid states matter; the problem is the total probability."),
            option("Expected return can still be computed normally.", false, "weights_unnormalised", "Using probabilities that do not sum to 1 distorts the weighted average.")
        ], ["Check the weights first.", "Probabilities must sum to 1."], "Always check the probability total."),

        numeric("q.risk.3", "risk.variance", "S3.2-E", "Returns are 10% and 20%, each with probability 0.5. The expected return is 15%.", "What is the variance, in percent-squared units?", FormulaDisplay(latex: "\\sigma^2 = \\sum p_i(r_i - E(r))^2", spoken: "Variance is the probability-weighted squared deviation."), 25, 1.0, "%^2", ["Each deviation is 5 percentage points.", "Square the deviations before weighting."], "Correct. The variance is 25 percent-squared, so the standard deviation is 5%."),

        choice("q.risk.4", "risk.variance", "S3.2-I", "Two securities usually move in opposite directions.", "What sign would you expect for covariance?", nil, [
            option("Negative", true, nil, "Correct. Opposite movement usually gives negative covariance."),
            option("Positive", false, "cov_sign", "Positive covariance means they tend to move together."),
            option("Impossible to be below zero", false, "cov_sign", "Covariance can be negative.")
        ], ["Together means positive.", "Opposite means negative."], "Covariance direction matters before the number."),

        choice("q.port.1", "risk.portfolio", "S3.4-M", "A portfolio invests 25% in X and 75% in Y.", "What should you check before computing return?", nil, [
            option("The weights sum to 100%.", true, nil, "Correct. Portfolio weights must sum to one whole portfolio."),
            option("The standard deviations are equal.", false, "wrong_tool", "Equal standard deviations are not required."),
            option("The correlation is positive.", false, "wrong_tool", "Correlation matters for risk, not for expected return.")
        ], ["Weights come before formulas.", "25% + 75% = 100%."], "Valid weights keep the portfolio calculation grounded."),

        numeric("q.port.2", "risk.portfolio", "S3.4-E", "Share X has expected return 10%; share Y has expected return 30%. You invest 25% in X and 75% in Y.", "What is the portfolio expected return?", FormulaDisplay(latex: "E(R_p) = \\sum w_i E(R_i)", spoken: "Portfolio expected return is the weighted average of expected returns."), 25, 0.5, "%", ["Compute 0.25 x 10 plus 0.75 x 30.", "Expected return is a weighted average."], "Correct. The portfolio expected return is 25%."),

        choice("q.port.3", "risk.portfolio", "S3.5-M", "Two-stock variance has two own-risk terms and one cross term.", "Which term captures how the two assets move together?", nil, [
            option("2 x w1 x w2 x rho x sigma1 x sigma2", true, nil, "Correct. That cross term is where diversification enters."),
            option("w1 squared x sigma1 squared", false, "cross_term_missing", "That is only stock X's own contribution."),
            option("w2 squared x sigma2 squared", false, "cross_term_missing", "That is only stock Y's own contribution.")
        ], ["Own-risk terms are not enough.", "Look for rho, the correlation."], "The cross term carries the correlation effect."),

        choice("q.capm.1", "capm.inputs", "S4.1-I", "A stock has beta 1.4.", "What does that mean?", nil, [
            option("It tends to move more than the market for a given market move.", true, nil, "Correct. Beta is market sensitivity."),
            option("It is expected to return 1.4%.", false, "beta_as_return", "Beta is not a return percentage."),
            option("Its correlation is impossible because beta is above 1.", false, "beta_vs_rho", "Correlation is bounded by -1 and 1. Beta can be above 1.")
        ], ["Beta is sensitivity.", "It is not a return."], "Beta describes exposure to market risk."),

        choice("q.capm.2", "capm.inputs", "S4.2-M", "The 10-year government bond yield is 3.8%, the expected market return is 9.2%, and beta is 1.3.", "Which value is r_f?", nil, [
            option("3.8%", true, nil, "Correct. The government bond yield is the risk-free rate proxy here."),
            option("9.2%", false, "capm_slot_swap", "That is the expected market return."),
            option("1.3", false, "beta_vs_rho", "That is beta.")
        ], ["r_f is the risk-free rate.", "Look for the government bond yield."], "Spot the inputs before computing."),

        choice("q.capm.3", "capm.inputs", "S4.2-M", "Expected market return is 9.2% and the risk-free rate is 3.8%.", "What is the market risk premium?", nil, [
            option("5.4%", true, nil, "Correct. The premium is 9.2% - 3.8%."),
            option("9.2%", false, "capm_slot_swap", "That is the full market return, not the premium over r_f."),
            option("13.0%", false, "capm_slot_swap", "The premium is a difference, not a sum.")
        ], ["Premium means extra over risk-free.", "Subtract r_f from expected market return."], "The market risk premium is 5.4%."),

        numeric("q.capm.4", "capm.compute", "S4.2-E", "r_f is 3.8%, beta is 1.3, and the market risk premium is 5.4%.", "What expected return does CAPM give?", FormulaDisplay(latex: "E(r_i) = r_f + \\beta_i(E(r_m) - r_f)", spoken: "Expected return equals risk-free rate plus beta times the market premium."), 10.82, 0.5, "%", ["Do not multiply beta by the full market return.", "Compute 3.8 + 1.3 x 5.4."], "Correct. CAPM gives 10.82%."),

        choice("q.capm.5", "capm.compute", "S4.2-E", "A worked solution says: E(r) = 3.8% + 1.3 x 9.2%.", "What is wrong?", nil, [
            option("Beta should multiply the market risk premium, not the full market return.", true, nil, "Correct. Use beta x (E(r_m) - r_f)."),
            option("The risk-free rate should be multiplied by beta.", false, "capm_slot_swap", "The risk-free rate is added once."),
            option("CAPM cannot use beta above 1.", false, "beta_vs_rho", "Beta above 1 is valid.")
        ], ["CAPM pays risk-free plus a scaled premium.", "Find what beta is multiplying."], "Beta scales the premium."),

        choice("q.capm.6", "capm.sml", "S4.3-I", "A security plots above the security market line.", "What does that imply?", nil, [
            option("It offers more return than CAPM requires for its beta.", true, nil, "Correct. Above the SML means undervalued in this framing."),
            option("It is overpriced because it is above the line.", false, "sml_direction", "Above the line means return is high for the risk, so price is low relative to value."),
            option("Its beta must be negative.", false, "wrong_tool", "Position above the line is about return relative to required return, not beta sign.")
        ], ["Above means actual expected return is higher than required.", "High expected return for the same risk points to undervaluation."], "Above the SML means undervalued."),

        choice("q.capm.7", "capm.sml", "S4.5-R", "You compare diversified funds using return per unit of total volatility.", "Which measure fits?", nil, [
            option("Sharpe ratio", true, nil, "Correct. Sharpe uses excess return over total standard deviation."),
            option("Treynor ratio", false, "measure_swap", "Treynor uses beta, not total volatility."),
            option("Dividend growth rate", false, "wrong_tool", "That is an equity valuation input, not a performance measure.")
        ], ["Total volatility points to standard deviation.", "Sharpe uses standard deviation."], "Sharpe matches excess return to total risk."),

        choice("q.wacc.1", "wacc.debt", "S5.1-R", "A company has traded bonds with observable yields.", "Which cost of debt estimate is usually most direct?", nil, [
            option("The yield on the traded debt", true, nil, "Correct. Market yield directly reflects the required return on that debt."),
            option("Book interest expense only", false, "book_proxy_overused", "A book proxy can help when market data is missing, but traded yields are more direct."),
            option("The dividend yield", false, "wrong_tool", "Dividend yield is about equity, not debt.")
        ], ["Use market information when available.", "Traded debt gives a market yield."], "Market yield is the direct debt cost input."),

        numeric("q.wacc.2", "wacc.debt", "S5.1-E", "The before-tax cost of debt is 10% and the corporate tax rate is 30%.", "What is the after-tax cost of debt?", FormulaDisplay(latex: "k_d(1 - T)", spoken: "After-tax cost of debt equals pre-tax cost times one minus the tax rate."), 7, 0.4, "%", ["Interest tax deductibility reduces the effective cost.", "Compute 10% x (1 - 0.30)."], "Correct. After tax, 10% debt costs 7%."),

        choice("q.wacc.3", "wacc.weight", "S5.3-R", "You have beta, the risk-free rate, and the market risk premium.", "Which method estimates the cost of equity from those inputs?", nil, [
            option("CAPM", true, nil, "Correct. CAPM uses r_f, beta, and the market premium."),
            option("Cost of preference shares", false, "wrong_tool", "Preference share cost uses dividend divided by price."),
            option("Book cost of debt", false, "wrong_tool", "Debt cost is not equity cost.")
        ], ["Beta is the clue.", "CAPM prices equity risk using beta."], "CAPM estimates cost of equity from market risk."),

        choice("q.wacc.4", "wacc.weight", "S5.4-M", "A company has market value of equity $60m and book equity $40m.", "Which equity value belongs in WACC weights?", nil, [
            option("$60m market value", true, nil, "Correct. WACC weights use market values."),
            option("$40m book equity", false, "book_vs_market_E", "Book values can be stale. WACC uses market values for capital weights."),
            option("The average of both", false, "book_vs_market_E", "Do not average book and market values for WACC weights.")
        ], ["WACC weights reflect current market financing.", "Use market value when available."], "Market values drive WACC weights."),

        numeric("q.wacc.5", "wacc.weight", "S5.4-E", "Debt is $10m, equity is $10m, after-tax debt cost is 7%, and equity cost is 16%.", "What is WACC?", FormulaDisplay(latex: "WACC = k_d(1-T)D/V + k_eE/V", spoken: "WACC is the weighted average of after-tax debt cost and equity cost."), 11.5, 0.4, "%", ["D/V and E/V are both 0.5.", "Compute 0.5 x 7% + 0.5 x 16%."], "Correct. Equal weights give an 11.5% WACC."),

        choice("q.wacc.6", "wacc.fcf", "S5.5-E", "A free cash-flow build starts from EBIT.", "Which item is added back because it is non-cash?", nil, [
            option("Depreciation and amortisation", true, nil, "Correct. D&A reduced accounting profit but did not use cash in the period."),
            option("Capital expenditure", false, "fcf_vs_ni", "CapEx is a cash outflow, so it is subtracted."),
            option("Increase in net working capital", false, "fcf_vs_ni", "More working capital ties up cash, so it is subtracted.")
        ], ["Non-cash charges are added back.", "D&A is the common add-back."], "D&A is added back in FCF."),

        choice("q.wacc.7", "wacc.fcf", "S5.4-E", "A project is much riskier than the company's existing business.", "Should the company-wide WACC be used without adjustment?", nil, [
            option("No. Use a project or divisional discount rate that reflects the higher risk.", true, nil, "Correct. A company-wide WACC can understate risk for a riskier project."),
            option("Yes. WACC is always the same for every project.", false, "divisional_wacc", "Different project risk can require a different discount rate."),
            option("Only if the project has no debt.", false, "divisional_wacc", "The issue is operating risk, not only financing.")
        ], ["Discount rates should match risk.", "A riskier division needs a risk-adjusted rate."], "WACC must match project risk.")
    ]

    static var questionsByID: [String: Question] {
        Dictionary(uniqueKeysWithValues: questions.map { ($0.id, $0) })
    }

    static var lessonsByID: [String: Lesson] {
        Dictionary(uniqueKeysWithValues: lessons.map { ($0.id, $0) })
    }

    static func course(id: String) -> Course? {
        courses.first { $0.id == id }
    }

    static func unit(id: String) -> Unit? {
        units.first { $0.id == id }
    }

    static func skill(id: String) -> Skill? {
        skills.first { $0.id == id }
    }

    static func units(for courseID: String) -> [Unit] {
        units.filter { $0.courseID == courseID }.sorted { $0.order < $1.order }
    }

    static func lessons(for unitID: String) -> [Lesson] {
        lessons.filter { $0.unitID == unitID }.sorted { $0.order < $1.order }
    }

    static func lessons(forCourse courseID: String) -> [Lesson] {
        let unitIDs = Set(units(for: courseID).map(\.id))
        return lessons.filter { unitIDs.contains($0.unitID) }.sorted { $0.order < $1.order }
    }

    static func questions(for lesson: Lesson) -> [Question] {
        let lookup = questionsByID
        return lesson.questionIDs.compactMap { lookup[$0] }
    }

    static func nextLesson(after lessonID: String) -> Lesson? {
        guard let index = lessons.firstIndex(where: { $0.id == lessonID }) else { return nil }
        return lessons.dropFirst(index + 1).first
    }

    static func firstLesson() -> Lesson {
        lessons.sorted { $0.order < $1.order }.first { $0.unitID == "tvm.rates" } ?? lessons[0]
    }

    private static func option(
        _ label: String,
        _ isCorrect: Bool,
        _ diagnosisTag: String?,
        _ feedback: String
    ) -> AnswerOption {
        AnswerOption(
            id: UUID().uuidString,
            label: label,
            isCorrect: isCorrect,
            diagnosisTag: diagnosisTag,
            feedback: feedback
        )
    }

    private static func choice(
        _ id: String,
        _ lessonID: String,
        _ skillID: String,
        _ context: String,
        _ prompt: String,
        _ formula: FormulaDisplay?,
        _ options: [AnswerOption],
        _ hints: [String],
        _ success: String
    ) -> Question {
        Question(
            id: id,
            lessonID: lessonID,
            kind: .choice,
            interaction: nil,
            primarySkillID: skillID,
            context: context,
            prompt: prompt,
            formula: formula,
            options: options,
            numericAnswer: nil,
            tolerancePercent: 0,
            unitSuffix: nil,
            hints: hints,
            successMessage: success
        )
    }

    private static func templateChoice(
        _ id: String,
        _ lessonID: String,
        _ skillID: String,
        _ template: LessonInteractionTemplate,
        _ target: String,
        _ guidance: String,
        _ context: String,
        _ prompt: String,
        _ formula: FormulaDisplay?,
        _ options: [AnswerOption],
        _ hints: [String],
        _ success: String
    ) -> Question {
        Question(
            id: id,
            lessonID: lessonID,
            kind: .choice,
            interaction: QuestionInteraction(
                template: template,
                target: target,
                guidance: guidance
            ),
            primarySkillID: skillID,
            context: context,
            prompt: prompt,
            formula: formula,
            options: options,
            numericAnswer: nil,
            tolerancePercent: 0,
            unitSuffix: nil,
            hints: hints,
            successMessage: success
        )
    }

    private static func numeric(
        _ id: String,
        _ lessonID: String,
        _ skillID: String,
        _ context: String,
        _ prompt: String,
        _ formula: FormulaDisplay?,
        _ answer: Double,
        _ tolerancePercent: Double,
        _ unitSuffix: String?,
        _ hints: [String],
        _ success: String
    ) -> Question {
        Question(
            id: id,
            lessonID: lessonID,
            kind: .numeric,
            interaction: nil,
            primarySkillID: skillID,
            context: context,
            prompt: prompt,
            formula: formula,
            options: [],
            numericAnswer: answer,
            tolerancePercent: tolerancePercent,
            unitSuffix: unitSuffix,
            hints: hints,
            successMessage: success
        )
    }
}
