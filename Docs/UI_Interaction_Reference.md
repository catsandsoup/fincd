# UI Interaction Reference

Stage 2 should translate useful lesson interaction patterns from the Khan Academy and Duolingo math references into finc'd's existing native macOS structure. These screenshots are interaction references only, not branding, layout, color, mascot, streak, heart, social, or share references.

## Current Implementation Read

- `HomeDashboardView` already provides a useful "start here" panel, path summary, and weak-skill revisit list.
- `CourseMapView` already gives course-level continuation and unit lesson rows, but the rows read more like a list than a guided sequence.
- `LessonRunnerView` already owns the core lesson loop: progress, question, answer input, hint, check, feedback, requeue on wrong answers, and continue.
- `LessonWorkspaceView` already provides the right-side scaffolding panel with steps, symbol help, and a concept reminder.
- `ProgressDiagnosticsView` is already more diagnostic than motivational, which fits finc'd.
- `ReviewNotebookView` already captures missed attempts and supports pattern-based review.
- `SidebarView` is correctly native and should stay calm and simple.

## Top Reusable Interaction Patterns

1. Fixed lesson action rhythm
   - User works the prompt, presses Check, sees immediate feedback, then presses Continue or Finish.
   - Stage 2 should make this rhythm more explicit and stable, especially after incorrect answers.

2. Per-question progress and pacing
   - A lightweight progress indicator helps users understand how far they are through the current lesson.
   - Stage 2 should clarify "question X of Y" and preserve the existing progress bar.

3. Inline, optional help
   - Khan exposes hints and calculator only when relevant; Duolingo keeps the primary task uncluttered.
   - Stage 2 should add optional tools without making them required: calculator for numeric finance questions, scratchpad for working notes.

4. Step scaffold beside the task
   - Khan's worked examples show stepwise reasoning; finc'd already has `Before You Answer`.
   - Stage 2 should make the current step scaffold feel actionable by highlighting the active or suggested step during question work.

5. Clear path state
   - Lesson/course maps should tell users what is current, what is practiced, and what is next.
   - Stage 2 should refine existing row states and continue actions, not introduce a game map.

## Smallest Useful Stage 2 Scope

1. Lesson feedback strip
   - Replace or supplement the current inline `FeedbackBanner` area with a bottom feedback state paired with the existing action bar.
   - Correct state: calm success message, Continue/Finish primary action.
   - Incorrect state: concise correction, expected answer where useful, Try Again or Continue depending on current requeue behavior.
   - Keep feedback native and restrained.

2. Lesson pacing label
   - Add a visible "Step X of Y" or "Question X of Y" label near the progress bar in `LessonRunnerView`.
   - Make requeued questions understandable, for example "Review pass" or "Again at end" when a missed question returns.

3. Optional tools in lesson workspace
   - Add a small tool row for eligible questions: Calculator and Scratchpad.
   - Calculator can be a basic local panel for arithmetic and percent/rate conversions; scratchpad can be temporary per question.
   - Keep tools collapsed by default or presented as compact native controls.

4. Stronger answer state handling
   - Keep selected answers visible after Check.
   - For wrong answers, show the chosen answer and correct answer without burying the message below the main content.
   - Numeric questions should preserve the entered answer during feedback.

5. Clearer path progression
   - In `CourseMapView`, mark rows as Current, Done, Review due, or New using subdued status labels and existing confidence data.
   - On Home, rename or reframe "Path" rows only if needed to make the next lesson and review entry points clearer.

## Should Wait For Stage 3

- Full course map redesign or node-based path.
- Locked lesson rules and prerequisite gating.
- Rich worked-solution renderer with multi-step formulas.
- Durable scratchpad history across lessons.
- Advanced finance calculator modes.
- Streaks, hearts, leaderboards, quests, mascots, social sharing, or web-style game loops.
- Major visual restyling of dashboard, sidebar, or progress pages.

## Implementation Boundary

Stage 2 should primarily touch:

- `LessonRunnerView`
- `LessonWorkspaceView`
- small supporting view/model additions for optional tools
- minimal `CourseMapView` row-state refinements

Stage 2 should avoid large rewrites of:

- `HomeDashboardView`
- `ProgressDiagnosticsView`
- `ReviewNotebookView`
- `SidebarView`

