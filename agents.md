# AGENTS.md

## Mission
finc’d is a fully native macOS learning app built in Swift and SwiftUI.

Every change should reinforce these core constraints:
- local-only
- SwiftData-based
- no cloud/server dependencies
- no React, JavaScript, TypeScript, Tailwind, or web-app remnants
- calm, native macOS presentation
- beginner-friendly finance learning experience

The goal is not to imitate web learning products visually.
The goal is to build a serious, elegant, Apple-native learning app with excellent interaction design.

---

## Non-negotiable product rules
Always preserve these unless the user explicitly instructs otherwise:

- Swift and SwiftUI only
- Local storage only
- No cloud sync
- No server features
- No React/JS/TS/Tailwind patterns or leftovers
- No admin-facing or internal delivery language in the UI
- No wording such as:
  - lecture
  - workshop
  - module
  - generated
  - to your spec
  - what your lecturer expects

This is a user-facing product, not an academic delivery shell.

---

## Platform rules
Prefer native macOS behavior over web-style composition.

Follow these principles:
- Use native macOS hierarchy, spacing, grouping, alignment, and semantic backgrounds
- Use Liquid Glass for controls, navigation, and action chrome where appropriate
- Do not use large glass cards as the default content treatment
- Prefer restrained surfaces over stacked panels
- Prefer low cognitive load over decorative complexity
- Prefer semantic colors and system conventions over custom visual noise
- Preserve strong accessibility in light mode, dark mode, and increased contrast
- Prefer keyboard-friendly interactions where reasonable for macOS

Do not make the UI feel like a browser dashboard transplanted into SwiftUI.

---

## Swift / SwiftUI rules
When editing code:

- Write idiomatic Swift
- Follow Swift API Design Guidelines
- Prefer clarity at the point of use
- Prefer Swift concurrency (`async/await`, actors, `@MainActor`) where appropriate
- Keep UI-facing state main-actor safe
- Reuse existing models, services, view models, and modifiers before introducing new abstractions
- Avoid force unwraps unless truly necessary and justified
- Avoid unnecessary type erasure such as `AnyView`
- Avoid broad architecture rewrites unless explicitly requested
- Preserve working local patterns unless they clearly block the task

Prefer the smallest correct change over a sweeping refactor.

---

## Learning design rules
finc’d is for learners who may not yet understand finance shorthand.

Always assume:
- users may not know abbreviations immediately
- users may confuse similar finance terms
- users benefit from structure before calculation
- users need one clear task at a time

Therefore:
- break questions into digestible steps
- do not assume learners already understand symbols like FV, PV, coupon rate, yield, beta, or discount rate
- prefer scaffolding before computation
- make formulas readable first
- allow LaTeX source only as an optional secondary detail if the app already supports that behavior
- do not expose source-content categories such as “lecture questions” or “workshop questions” in the user experience

When designing lesson interactions, prioritize:
- identifying inputs
- choosing the method
- matching units/periods
- solving one step at a time
- checking understanding before advancing complexity

---

## Interaction design reference rule
When external learning-product screenshots are provided, extract only:
- interaction patterns
- lesson pacing
- progression cues
- feedback timing
- optional helper tools
- useful exercise archetypes

Do not copy directly:
- branding
- mascots
- hearts/lives/streak systems
- social/share affordances
- childish tone
- browser/web-product chrome
- mobile-first layout decisions

Translate useful patterns into calm native macOS behavior appropriate for finc’d.

The intended synthesis is:
- Khan Academy for structure
- Duolingo for interaction pacing
- Apple for presentation

---

## Task interpretation rule
When the user writes a wish-like or aesthetic request, convert it internally into an engineering contract before acting.

Examples of vague requests:
- make this feel more native
- clean this up
- make this calmer
- improve the lesson flow
- reduce dashboard clutter
- make this more Apple-like

Internally restate as:
1. Goal
2. Relevant files to inspect
3. Constraints
4. Smallest sensible implementation scope
5. Verification steps
6. Report format

Do not respond to vague prompts with a broad redesign.
Inspect the codebase first and define the smallest coherent change.

---

## Planning rule
For non-trivial UI or workflow changes:

1. Inspect the relevant files first
2. Summarize what is already working
3. Identify what still feels web-like, overly boxed, overly metric-heavy, or cognitively noisy
4. Propose the smallest sensible scope
5. Only then implement

Do not jump directly into code if visual diagnosis or interaction structure matters.

Protect the strongest existing parts of the app.
Do not redesign a screen just because it can be changed.

---

## Visual refinement rule
When refining UI:

- identify the strongest existing screen and preserve it
- prioritize removing obvious non-native residue
- prefer fewer, better surfaces
- reduce chip clutter, dashboard clutter, and reporting-software tone
- keep one primary action per screen where possible
- prefer quiet progression cues over noisy status systems
- be restrained

The goal is not “more designed.”
The goal is “more native, clearer, calmer, and easier to use.”

---

## Lesson workspace rule
The lesson experience is the core of the product.

When working on lesson screens:
- preserve a strong title hierarchy
- preserve a clear single primary action
- preserve beginner-first scaffolding
- preserve formula readability
- prefer one clear task at a time
- integrate guidance naturally rather than boxing everything into separate cards
- make the screen feel like a learning workspace, not a dashboard or generic quiz shell

Useful interaction directions include:
- identify the relevant inputs
- choose the correct interpretation
- match period/frequency/unit before calculating
- fill one missing part of a formula
- order the next step
- reveal explanation after attempt
- support optional helper tools such as calculator or scratchpad where appropriate

Do not let the lesson experience become cluttered, overly analytical, or visually fragmented.

---

## Home / Progress / Notebook bias
When making product-level refinements:

- Home should feel like a calm starting point for study
- Progress should feel like study guidance, not reporting software
- Notebook should feel personal and useful, not diagnostic or punitive
- Sidebar should remain simple, native, and stable

Reduce:
- metric-strip thinking
- dashboard grids
- chip-heavy status communication
- unnecessary reporting language
- content-card sprawl

---

## Copy rules
All copy should be:
- user-facing
- supportive
- plain-language
- mature
- concise

Avoid:
- academic delivery language
- internal system language
- developer language
- overexplaining
- robotic “AI product” phrasing

The app should sound like a thoughtful learning product, not a course shell and not an autogenerated prototype.

---

## Scope control rule
Prefer touching only the files necessary for the task.

Avoid changing unless clearly required:
- models
- SwiftData schema
- storage architecture
- curriculum engine
- lesson engine
- sync/cloud/server logic
- unrelated screens

Do not silently expand scope.

If a requested UI change would require a deeper architectural change, explain that before making broad edits.

---

## File inspection rule
Before editing UI behavior, inspect the likely surrounding files, including:
- the main view
- related view models or controllers
- nearby reusable components
- learning copy / wording helpers
- related tests if present

For lesson bugs or flow issues, inspect both:
- where the learner sees the issue
- where state, sequencing, or correctness is determined

Do not guess architecture if it can be inspected.

---

## Verification rule
Do not claim success without verification.

For this repo:
- use `xcodebuild` for verification
- skip UI tests unless explicitly requested
- if additional project-specific commands are documented in the repo, follow them
- if verification cannot run, explain why clearly

Prefer evidence over assumption.

---

## Reporting rule
After completing work, report using this structure:

### Summary
What changed and why.

### Files changed
List each edited file with a one-line purpose.

### Verification
State what command was run and the result.

### Notes
Call out remaining risks, edge cases, or follow-up suggestions.

### Next recommendation
Suggest the next smallest valuable pass, not a grand redesign.

---

## Behavior guardrails
Do not:
- over-engineer
- perform broad stylistic rewrites without permission
- import web-dashboard habits into SwiftUI
- imitate the tone of emotional user instructions literally
- produce generic “AI refactor” patterns
- add unnecessary abstractions
- replace working code just because another pattern is theoretically cleaner

Do:
- inspect first
- preserve what is strongest
- make the smallest coherent improvement
- keep the app calm, native, and learner-first

## Colour and style rule
Use colour to support meaning, not to create product personality.

Prefer:
- semantic system colours
- neutral content surfaces
- restrained accent use
- built-in SwiftUI styles where appropriate
- hierarchy through spacing, typography, grouping, and alignment

Avoid:
- bright gamified palettes
- multiple competing accents
- tinted dashboard cards
- heavy badge/chip styling
- using Liquid Glass as the default content surface

## Apple HIG / SwiftUI addendum

### Native container rule
Prefer built-in macOS and SwiftUI containers before custom shells.

Default to:
- NavigationSplitView for app structure
- native sidebars, toolbars, inspectors, search, menus, and buttons
- framework-provided controls and list styles before custom chrome

Only build custom containers when the product clearly needs behavior the system views cannot provide.

### Liquid Glass rule
Use Liquid Glass mainly for:
- navigation
- toolbars
- controls
- action surfaces
- lightweight overlays where it improves focus

Do not use Liquid Glass as the default treatment for the main content layer.
Main lesson and study content should usually sit on calmer native surfaces with semantic backgrounds, spacing, grouping, and separators.

Be restrained with custom glass effects.
Do not stack multiple glass-heavy surfaces just because the APIs make it possible.

### Color and materials rule
Prefer semantic and system colors over hard-coded brand color decisions.

Use colors and materials that:
- adapt to light mode and dark mode
- remain legible with vibrancy
- remain usable in accessibility-adjusted appearances
- keep control labels and navigation readable

If color is added to controls or navigation, use it sparingly.

### Accessibility appearance rule
Design and review changes in:
- light mode
- dark mode
- increased contrast
- larger text / dynamic type where applicable
- reduced transparency or related accessibility-sensitive appearances if relevant

Do not approve a surface treatment or contrast decision based on one appearance only.

### SwiftUI data-flow rule
Keep a clear source of truth.

Prefer:
- local state with `@State` when the view owns it
- bindings when a parent owns it
- Observation / observable model patterns for shared UI-facing model state
- main-actor-safe updates for UI-facing state

Do not scatter duplicated state across multiple views unless there is a clear reason.

### Concurrency rule
Prefer modern Swift concurrency where appropriate:
- `async/await`
- structured tasks
- actor-aware state ownership
- main-actor-safe UI updates

Do not introduce older callback-heavy or GCD-heavy patterns unless required by existing APIs or legacy boundaries.

### SwiftData rule
Model persistence should remain local-first and SwiftData-native.

Prefer:
- SwiftData-backed model persistence across launches
- SwiftUI-friendly model/query patterns
- simple local data flow before any complexity

Do not introduce cloud sync, remote persistence, or server-shaped data decisions unless explicitly requested.

### Design adaptation rule
When adopting newer Apple design APIs:
- first prefer what the framework already gives automatically
- then refine using system APIs
- only then add custom effects where clearly beneficial

This repo should gain polish primarily by leaning harder into native frameworks, not by simulating a web design system in SwiftUI.
