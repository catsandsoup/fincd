# Stage 3 Lesson Interaction Brief

## Purpose

Stage 3 should move finc'd from a clean question screen toward a question-first micro-interaction learning workspace.

The goal is not to make finance feel exciting through game mechanics. The goal is to make quantitative finance feel structured, active, finishable, and calm by turning each lesson into a sequence of small, meaningful actions.

Core principle:

> Do not ask the learner to swallow a full problem all at once. Ask them to identify, classify, match, choose, place, fill, order, compute, and interpret one cognitive step at a time.

This matters most in topics where errors usually happen before arithmetic:

- Time value problems require the interest-rate period to match the cash-flow interval.
- CAPM problems require separating the risk-free rate, beta, market return, and market risk premium.
- Cost of capital problems require separating debt, equity, tax effects, and market-value weights.

## Current App Read

The existing app already has several strong foundations:

- `LessonRunnerView` owns a stable lesson rhythm: prompt, answer, check, feedback, continue.
- `LessonWorkspaceView` already gives lightweight "Before you answer" support with steps, symbol help, and a reminder.
- `CurriculumCatalog` already breaks the course into recognition, mapping, execution, interpretation, and transfer skills.
- Current lessons already include strong topic names such as "Match the Period", "Spot the Inputs", "Beta Scales the Premium", and "Weights Use Market Values".

The main Stage 3 opportunity is not a visual redesign. It is to make the answer area itself more interactive so that learners do the setup work before the final calculation or interpretation.

## Product Intent

finc'd should help learners feel:

1. I know what kind of problem this is.
2. I know what information matters.
3. I know what to do next.
4. I can check one step at a time.
5. I can recover if I get stuck.

The interface should remain calm, mature, and native to macOS. Avoid hearts, streaks, badges, mascots, quests, social loops, and decorative game-map thinking.

## Lesson Rhythm

Keep one consistent loop:

1. See task.
2. Answer one small step.
3. Check.
4. Read concise feedback.
5. Continue or retry.

Every Stage 3 interaction should preserve:

- selected answer persistence after Check
- clear correct and incorrect states
- visible step count, such as "Step 2 of 6"
- one primary action at a time
- optional help that starts small and expands only when requested

## Progressive Support

Support should be layered:

1. No help visible beyond the default nudge.
2. Small hint.
3. Stronger scaffold.
4. Worked reasoning.

The existing `LessonWorkspaceView` can evolve into this structure:

- Default: one actionable nudge.
- Expanded support: remaining setup steps and symbol meanings.
- Worked reasoning: available only after an attempt or explicit request.

Do not show all explanation layers at once. The learner should first act, then ask for help if needed.

## Recommended Lesson Architecture

Most quantitative lessons should be built as a short sequence of micro-steps:

1. What kind of problem is this?
2. What values are given?
3. Do the periods or units match?
4. Which method or formula belongs?
5. What is the next step?
6. Compute or interpret.
7. Sense-check the answer.

This supports the core course traps:

- Annuities and perpetuities: match the rate period to the cash-flow interval before formulas.
- CAPM: identify the risk-free rate, beta, and market risk premium before substitution.
- WACC: separate debt and equity values, component costs, and the tax treatment before weighting.

## Core Interaction Templates

Stage 3 should start with five reusable templates. These are enough to make Modules 3, 6, and 7 feel meaningfully more active without redesigning the whole app.

### 1. Identify Inputs

Best for:

- CAPM
- WACC
- annuities
- bond valuation

Learner action:

- Select or tag the number that corresponds to a named input.
- Example: choose which number is beta, the risk-free rate, the market risk premium, PMT, face value, or the tax rate.

Answer shape:

- A short set of candidate values from the problem statement.
- One target slot at a time.
- Optional "why this matters" feedback after Check.

Good prompts:

- "Which number is beta?"
- "Which value is the market risk premium?"
- "Which cash flow is PMT?"
- "Which input belongs in `ke = rf + beta x MRP`?"

Why it matters:

Learners often fail because they do not know what the numbers represent. This template makes mapping explicit before computation.

### 2. Choose Method

Best for:

- ordinary annuity vs annuity due vs deferred annuity
- premium, par, or discount bond logic
- CAPM vs dividend-growth equity cost
- after-tax debt vs before-tax debt
- portfolio beta vs single-stock beta

Learner action:

- Choose the method, classification, or model before any calculation.

Answer shape:

- Usually a restrained native choice list.
- Feedback should diagnose the misconception, not just name the right method.

Good prompts:

- "Is this ordinary annuity, annuity due, or deferred annuity?"
- "Is this asking for cost of equity, cost of debt, or WACC?"
- "Should this use CAPM or dividend growth?"
- "Is the bond likely to trade at a premium, discount, or par?"

Why it matters:

This catches wrong-tool errors before the learner spends effort on the wrong formula.

### 3. Match Period

Best for:

- annuities
- perpetuities
- bond coupons
- loans
- nominal and effective rate conversion

Learner action:

- Match the cash-flow interval to the rate interval.
- Decide whether rate conversion is needed.
- Choose the effective periodic rate that belongs in the formula.

Answer shape:

- A compact matching row or segmented choice.
- Start with labels such as annual, semi-annual, quarterly, monthly, and every 3 years.

Good prompts:

- "The repayment is monthly. What period should the formula rate use?"
- "Coupons are semi-annual. Which yield belongs in each period?"
- "Cash flows arrive every 3 years. Which rate conversion is needed?"
- "Why is using the quoted annual rate directly wrong here?"

Why it matters:

This should become a signature finc'd interaction. Module 3 repeatedly depends on the rule that the compound interest rate per period must match the cash-flow interval.

### 4. Fill Missing Piece

Best for:

- formula comprehension
- partial substitution
- step-by-step calculation

Learner action:

- Fill one missing term in a formula or substitution line.

Answer shape:

- Formula display with one blank.
- Candidate values or short numeric input.
- The blank should represent one concept, not a whole solution.

Good prompts:

- `E(ri) = rf + beta_i x ( ___ )`
- `PV = PMT x [1 - (1+i)^-n] / ___`
- `WACC = wd x kd(1-T) + we x ___`

Why it matters:

This teaches the structure of the formula without asking for a full answer too early.

### 5. Reorder Steps

Best for:

- multi-step setup
- WACC
- bond pricing
- CAPM logic
- annuity setup

Learner action:

- Put process steps in the correct order.

Answer shape:

- Four to six concise steps.
- Use plain language, not source-content labels.
- The correct order should reflect the underlying method.

Good sequences:

- Identify interval -> convert rate -> choose formula -> substitute -> compute.
- Price debt -> calculate market value of debt -> calculate market value of equity -> find weights -> compute WACC.
- Identify CAPM inputs -> calculate market risk premium if needed -> multiply by beta -> add risk-free rate -> compare to actual return.

Why it matters:

This teaches process, not just answer recall.

## Later Interaction Templates

These should follow after the five core templates are stable.

### Timeline Placement

Best for annuity due, deferred annuities, bond coupon timing, retirement cash flows, and terminal value discounting.

Learner action:

- Place the first payment, last payment, valuation point, or terminal value on a simple timeline.

Use this when timing is the main source of error.

### Weighted Logic

Best for portfolio beta, expected return, WACC, and performance measures.

Learner action:

- Allocate weights, assign values to weighted slots, or identify which weight must rise to move the result.

Use this after input identification and method selection are in place.

### Interpretation

Best for beta, SML, alpha, Sharpe, Treynor, Jensen's alpha, and bond premium/discount intuition.

Learner action:

- Translate a result into financial meaning.

Good prompts:

- "Beta above 1 means what?"
- "If coupon rate is below yield, how should the bond trade?"
- "If actual return exceeds the CAPM-predicted return, what does alpha say?"
- "Which performance metric belongs if this is the only risky fund?"

## Topic Direction

### Financial Mathematics II

Relevant concepts:

- ordinary annuity
- annuity due
- deferred annuity
- perpetuity
- growing perpetuity
- period matching

Best interaction types:

- Match Period
- Choose Method
- Timeline Placement
- Fill Missing Piece
- Reorder Steps

Signature lesson ideas:

- "Match the Period"
- "Ordinary or Due?"
- "Where Does the First Payment Fall?"
- "Convert Before You Compute"
- "Timeline First, Formula Second"

### CAPM

Relevant concepts:

- systematic vs unsystematic risk
- beta
- portfolio beta
- CAPM
- Security Market Line
- alpha, Sharpe, Treynor, and Jensen's alpha

Best interaction types:

- Identify Inputs
- Fill Missing Piece
- Weighted Logic
- Interpretation
- Choose Method

Signature lesson ideas:

- "Name the Moving Parts of CAPM"
- "Build a Portfolio Beta of 1.0"
- "What Does Beta Mean?"
- "Which Return Is Predicted by CAPM?"
- "Which Performance Metric Belongs?"

CAPM screenshot translation:

- A static "correctly priced, underpriced, or overpriced" question should become a short sequence:
  1. Identify `rf`, `E(rm)`, beta, and actual return.
  2. Compute the CAPM-predicted return.
  3. Compare actual return to predicted return.
  4. Interpret above or below the Security Market Line.

### Cost of Capital

Relevant concepts:

- before-tax debt
- after-tax debt
- preference share cost
- ordinary share cost
- dividend-growth equity cost
- CAPM equity cost
- WACC
- free cash flow

Best interaction types:

- Identify Inputs
- Choose Method
- Fill Missing Piece
- Reorder Steps
- Weighted Logic

Signature lesson ideas:

- "Which Cost Is This?"
- "Tax-Adjust Debt, Not Equity"
- "Build WACC From Parts"
- "Market Value, Not Book Guesswork"
- "Choose CAPM or Dividend Growth?"

## Example Lesson Flow: Annuities

Lesson title:

- "Timeline First, Formula Second"

Learning goal:

- Learner can classify the annuity timing, match the rate period, and choose the first calculation before computing.

Step 1 of 6: Choose Method

- Prompt: "Payments are equal and arrive at the end of each month for five years. What kind of cash-flow pattern is this?"
- Expected action: choose ordinary annuity.
- Feedback: "End of each month means the first payment is one month from today, so this is ordinary timing."

Step 2 of 6: Identify Inputs

- Prompt: "Which value is the repeated payment?"
- Expected action: select PMT from the story values.
- Feedback: "PMT is one repeated cash flow, not the total value of the loan or investment."

Step 3 of 6: Match Period

- Prompt: "Payments are monthly. What period should the formula rate use?"
- Expected action: choose monthly effective rate.
- Feedback: "The annuity formula needs a rate per payment period."

Step 4 of 6: Fill Missing Piece

- Prompt: `PV = PMT x [1 - (1+i)^-n] / ___`
- Expected action: fill `i`.
- Feedback: "The denominator is the periodic rate."

Step 5 of 6: Compute

- Prompt: "Now compute the present value using the matched monthly rate."
- Expected action: numeric entry.
- Feedback: concise calculation check.

Step 6 of 6: Sense-Check

- Prompt: "Should the present value be more or less than the total undiscounted payments?"
- Expected action: choose less than.
- Feedback: "Future payments are discounted, so present value should sit below the simple total."

## Example Lesson Flow: CAPM

Lesson title:

- "From Inputs to Security Market Line"

Learning goal:

- Learner can identify CAPM inputs, calculate predicted return, and interpret whether actual return is above or below the Security Market Line.

Step 1 of 7: Identify Inputs

- Prompt: "Which number is beta?"
- Expected action: select the beta value from the problem.
- Feedback: "Beta measures sensitivity to market movement. It is not a return."

Step 2 of 7: Identify Inputs

- Prompt: "Which number is the risk-free rate?"
- Expected action: select `rf`.
- Feedback: "The risk-free rate is the baseline return before adding market-risk compensation."

Step 3 of 7: Fill Missing Piece

- Prompt: `E(ri) = rf + beta_i x ( ___ )`
- Expected action: fill market risk premium or `E(rm) - rf`.
- Feedback: "CAPM pays beta-scaled compensation for market risk."

Step 4 of 7: Compute

- Prompt: "Compute the CAPM-predicted return."
- Expected action: numeric entry.
- Feedback: show the substitution in one line.

Step 5 of 7: Compare

- Prompt: "The share is priced to provide 13%. Is actual return above, below, or equal to the CAPM-predicted return?"
- Expected action: choose above, below, or equal.
- Feedback: "This comparison determines the Security Market Line interpretation."

Step 6 of 7: Interpret

- Prompt: "If actual return is above the CAPM-predicted return, where does the share sit?"
- Expected action: choose above the Security Market Line.
- Feedback: "Above the line means the return is high for its beta."

Step 7 of 7: Sense-Check

- Prompt: "Does above the Security Market Line imply underpriced or overpriced?"
- Expected action: choose underpriced.
- Feedback: "The return is higher than required for the risk, so price is too low relative to the model."

## Example Lesson Flow: WACC

Lesson title:

- "Build WACC From Parts"

Learning goal:

- Learner can separate debt and equity inputs, apply tax only to debt, use market-value weights, and compute WACC.

Step 1 of 7: Choose Method

- Prompt: "Is this asking for cost of debt, cost of equity, or WACC?"
- Expected action: choose WACC.
- Feedback: "WACC combines component costs using financing weights."

Step 2 of 7: Identify Inputs

- Prompt: "Which values belong to debt?"
- Expected action: select bond count, face value, coupon, maturity, and yield.
- Feedback: "Debt inputs are used to price the bonds and estimate the market value of debt."

Step 3 of 7: Match Period

- Prompt: "Coupons are semi-annual and yield is quoted per year compounded semi-annually. What yield belongs in each coupon period?"
- Expected action: choose the semi-annual yield.
- Feedback: "Bond pricing uses the yield per coupon period."

Step 4 of 7: Reorder Steps

- Prompt: "Put the WACC workflow in order."
- Expected order: price debt, calculate market value of debt, calculate market value of equity, find weights, apply component costs, compute WACC.
- Feedback: "Weights come from market values, so values must be estimated before WACC."

Step 5 of 7: Fill Missing Piece

- Prompt: `WACC = wd x kd(1 - T) + we x ___`
- Expected action: fill `ke`.
- Feedback: "Tax adjustment applies to debt. Equity stays as the required return."

Step 6 of 7: Weighted Logic

- Prompt: "Drag each market value into its weight slot."
- Expected action: debt value into `D / V`, equity value into `E / V`.
- Feedback: "The weights must sum to 1 because they divide by total market value."

Step 7 of 7: Compute and Interpret

- Prompt: "Compute WACC and choose the best interpretation."
- Expected action: numeric entry plus interpretation.
- Feedback: "WACC is the company's blended required return for projects with similar risk."

## Implementation Priorities

### Priority 1: Add Interaction Templates

Add reusable interaction templates for:

- Identify Inputs
- Choose Method
- Match Period
- Fill Missing Piece
- Reorder Steps

The current `QuestionKind` enum has `choice`, `numeric`, and `formulaMapping`. Stage 3 likely needs a more expressive interaction descriptor while preserving simple choice and numeric questions.

Possible direction:

- Keep `Question` as the lesson item.
- Add a `QuestionInteraction` or expand `QuestionKind` with associated template data.
- Keep rendering local to SwiftUI views.
- Keep all progress local in SwiftData.

### Priority 2: Upgrade Pacing

Every micro-step should show visible finite progress:

- "Step X of Y" for a micro-step lesson.
- "Question X of Y" for traditional practice.
- Clear copy when a missed item returns for review.

### Priority 3: Make Support Progressive

Change support from a mostly static companion panel into a layered scaffold:

- one default nudge
- expandable setup steps
- symbols and terms
- worked reasoning after attempt

### Priority 4: Add Timeline Placement

Use this only for timing-heavy lessons first:

- annuity due
- deferred annuity
- retirement cash flows
- terminal value discounting
- bond coupon timing

### Priority 5: Add Weighted Logic

Use this after the five core templates are stable:

- portfolio beta
- expected portfolio return
- WACC weights
- Sharpe, Treynor, and Jensen selection

## UI Behavior Rules

Question-first layout:

- The task and answer area should dominate.
- Support should remain secondary.
- Avoid side-panel sprawl, stacked cards, and dashboard-style metrics.

Answer state:

- Preserve the learner's selected answer after Check.
- Show the correct answer clearly when needed.
- Keep feedback concise.
- Allow immediate Continue after correct answers.
- Allow retry when the mistake is useful to correct in place.

Support:

- Default support should be a quick nudge.
- Deeper support should be explicit and optional.
- Worked reasoning should not compete with the initial task.

Tone:

- Use plain user-facing language.
- Do not expose source-content categories in the product UI.
- Avoid internal, generated, or academic delivery phrasing.

## Success Criteria

Stage 3 succeeds if:

- learners spend less time staring and more time doing
- difficult questions become short step sequences
- setup mistakes are caught before arithmetic
- support appears only when needed
- selected answers persist through feedback
- Module 3, CAPM, and Cost of Capital topics can be taught through reusable templates rather than static multiple-choice screens
- the app remains calm, mature, and Apple-native

