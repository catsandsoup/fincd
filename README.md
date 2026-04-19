<img width="1624" height="988" alt="Screenshot 2026-04-19 at 10 43 10 am" src="https://github.com/user-attachments/assets/f5cd5e59-bf9e-4cbd-8581-f905810f2fab" />
<img width="1624" height="988" alt="Screenshot 2026-04-19 at 10 43 03 am" src="https://github.com/user-attachments/assets/449214ed-7793-4126-bcb8-d9f1f7c370a2" />

# finc'd — Release 1

finc'd is a native macOS learning app for finance that breaks difficult quantitative topics into smaller, clearer steps.

Release 1 establishes the local-first macOS foundation for the product:
- Swift + SwiftUI only
- local-only storage with SwiftData
- no cloud or server dependency
- no React, JavaScript, TypeScript, or Tailwind remnants
- calm, native macOS interface focused on clarity and low cognitive load

## What it does

finc'd helps learners work through finance topics by slowing down the setup before the arithmetic.

Instead of jumping straight into dense formula problems, the app focuses on:
- naming the inputs
- matching the period
- choosing the method
- solving the next step
- revisiting weak spots without dashboard clutter

Current topic areas include:
- Time Value
- Valuation
- Risk & Portfolios
- CAPM
- Cost of Capital

## Release 1 highlights

### Native macOS foundation
Release 1 ports the product fully into SwiftUI for macOS with a local-first architecture.

### Calmer learning shell
The app uses a quiet sidebar, focused lesson workspace, course path views, progress guidance, and a notebook for revisit work.

### Beginner-first structure
Lessons are designed to reduce common setup mistakes before calculation, especially in timing-heavy and formula-heavy topics.

### Local progress and review
Progress, lesson state, and review flows stay on device.

## Design direction

finc'd is guided by a few core principles:
- structure before arithmetic
- one short task at a time
- progressive support
- visible but calm progress
- question-first lesson design
- color and motion used for meaning, not decoration

## Current state of the product

Release 1 is the foundation release.

It includes:
- the native macOS shell
- course navigation
- progress and notebook views
- a question-first lesson workspace
- early micro-step lesson direction
- support for formula display and guided learning copy

It does not aim to be feature-complete yet. This release is about building the product on the right native and pedagogical foundation.

## Planned direction

Future releases are intended to expand:
- micro-interaction lesson templates
- step-based finance workflows
- richer feedback states
- progressive scaffolding
- more topic-specific learning interactions for annuities, CAPM, WACC, and valuation

## Tech

- Swift
- SwiftUI
- SwiftData
- macOS local-first architecture

## Status

Release 1 is an early native foundation release focused on product direction, learning experience, and platform quality.
