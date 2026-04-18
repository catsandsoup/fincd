# finc'd Curriculum Quick Reference

This note condenses the design spec plus the lecture and workshop PDFs now in `Docs/`.
Treat any old "FinDuo" wording as `finc'd`.

## Product Direction

finc'd is a local-first macOS finance learning app. It should feel like a native Apple learning workspace, not a web app inside a window. There is no account, server, sync, Supabase, React, TypeScript, or Tailwind layer. Progress, attempts, and mastery live in local SwiftData only.

The learner is assumed to be capable but not already fluent in finance notation. Lessons should name concepts before formulas, define symbols before calculations, and move from recognition to mapping to execution to interpretation to transfer.

## Course Progression

1. Time Value of Money
   - Effective vs nominal rates.
   - Ordinary annuities, future value, present value, and loan payments.
   - Annuity due, deferred annuities, perpetuities, and growing perpetuities.
   - Core traps: period mismatch, off-by-one timing, using the wrong cash flow in the numerator.

2. Valuation
   - Bond anatomy: face value, coupon rate, coupon dollars, yield, maturity.
   - Bond price as coupon annuity plus discounted face value.
   - Premium, discount, and par classification before pricing.
   - Dividend discount model, Gordon growth, two-stage growth, and PVGO.
   - Core traps: confusing face value with future value, using D0 instead of D1, discounting terminal value from the wrong year.

3. Risk and Portfolios
   - Holding period return, expected return, variance, standard deviation.
   - Arithmetic vs geometric mean.
   - Covariance, correlation, diversification, and portfolio expected return.
   - Sharpe ratio and systematic vs unsystematic risk.
   - Core traps: probabilities that do not sum to one, forgetting the variance cross term, treating diversification as removing all risk.

4. CAPM
   - Beta definition and interpretation.
   - CAPM inputs: risk-free rate, beta, expected market return, market risk premium.
   - Security Market Line, CML boundary, Jensen's alpha, Sharpe, and Treynor.
   - APT and Fama-French as multi-factor extensions.
   - Core traps: reading beta as a return, confusing correlation with beta, reversing above/below SML interpretation.

5. Cost of Capital
   - Cost of debt, preference shares, and equity.
   - After-tax WACC with market value weights.
   - CAPM-implied cost of equity and dividend-implied cost of equity.
   - Free cash flow and divisional WACC.
   - Core traps: using book weights, applying tax shield to equity, treating accounting profit as free cash flow.

## Lesson Rules

- Do not label content as lecture questions or workshop questions.
- Do not expose source-file/module wording in the app.
- Start every concept with plain language and only then add notation.
- Keep each question focused on one skill unless it is a deliberate challenge.
- Prefer "What should you do first?" before "Calculate the answer" when a learner might choose the wrong tool.
- Explain symbols in context. Example: in bonds, `F` means face value, the principal repaid at maturity. It is not the same idea as `FV` in compound interest.
- For formulas, show readable notation and keep the LaTeX source available as an optional setting.
- Feedback should diagnose the misconception, not just say wrong.

## Micro-Skill Tags

- Recognition: identify the kind of problem.
- Mapping: map story quantities to formula symbols.
- Execution: calculate the next step.
- Interpretation: explain what the result means.
- Transfer: apply the idea in a messier mixed setting.

## Formula Reference

Rate conversion:

```latex
EAR = (1 + r_{nom}/m)^m - 1
i_{period} = (1 + r_{nom}/m)^{m / periodsPerYear} - 1
```

Annuities and perpetuities:

```latex
PV = PMT * [1 - (1+i)^{-n}] / i
FV = PMT * [(1+i)^n - 1] / i
PV = PMT / i
PV_t = PMT_{t+1} / (i - g)
```

Bonds:

```latex
C = coupon rate * F / m
P = C * [1 - (1+r)^{-n}] / r + F / (1+r)^n
```

Equity:

```latex
P_0 = D_1 / (r_e - g)
g = (D_t / D_0)^{1/t} - 1
P = EPS_1 / r + PVGO
```

Risk and portfolios:

```latex
E(r) = sum p_i r_i
sigma^2 = sum p_i(r_i - E(r))^2
rho = cov(i,j) / (sigma_i sigma_j)
E(R_p) = sum w_i mu_i
sigma_p^2 = w_1^2 sigma_1^2 + w_2^2 sigma_2^2 + 2w_1w_2 rho sigma_1 sigma_2
Sharpe = (E(R_p) - r_f) / sigma_p
```

CAPM:

```latex
beta_i = Cov(R_m, R_i) / sigma_m^2
E(r_i) = r_f + beta_i * (E(r_m) - r_f)
beta_p = sum w_i beta_i
```

WACC and FCF:

```latex
WACC = k_d(1-T) * D/V + k_e * E/V
r_ps = d / P_0
r_e = D_1/P_0 + g
FCF = EBIT(1-T) + D&A - DeltaNWC - CapEx
```
