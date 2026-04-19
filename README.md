<img width="1512" height="982" alt="time_value_course2" src="https://github.com/user-attachments/assets/221164b9-82da-44d9-abe1-a9a851aaf1e3" />
<img width="1512" height="982" alt="activated" src="https://github.com/user-attachments/assets/00caa15b-9519-4b2e-accf-02a42f895339" />
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
