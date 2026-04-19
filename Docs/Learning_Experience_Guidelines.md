# Learning Experience Guidelines

## Purpose

finc'd should feel calm, structured, active, and finishable.

The product should not try to make finance exciting through spectacle. It should make finance manageable by turning difficult topics into small, meaningful steps that reduce uncertainty and reward progress with clarity.

This document sits above the interaction-template specs. It governs the broader learning experience:
- how lessons are introduced
- how support appears
- how feedback lands
- how progress is framed
- how color and motion are used
- how the product avoids feeling dead without becoming childish

It complements:
- `UI_Interaction_Reference.md`
- `Stage_3_Lesson_Interaction_Brief.md`

---

## 1. Product intent

finc'd should feel:

- calm
- structured
- active
- finishable
- mature
- Apple-native

It should not feel:

- childish
- gamified for its own sake
- lecturer/admin-facing
- like reporting software
- overdecorated
- emotionally noisy

The goal is not to copy Duolingo or Khan Academy visually.  
The goal is to borrow the best parts of learning-product design while preserving a native macOS feel.

---

## 2. Core learning principles

### 2.1 Structure before arithmetic
Many finance mistakes happen before calculation:
- the learner picks the wrong method
- mismatches the period
- confuses what a number represents
- applies a formula before understanding the setup

The interface should therefore teach setup first.

**Rule:** learners should often identify, classify, match, and choose before they calculate.

### 2.2 Break work into smaller chunks
Lessons should be broken into short, cognitively distinct steps:

- one short task
- one clear decision
- one immediate check
- one next step

Do not ask the learner to swallow a whole problem blob all at once.

### 2.3 Make progress feel finite
Hard quantitative topics feel lighter when they feel bounded.

Use:
- step counts
- short lesson runs
- visible progress
- clear transitions into the next idea

A learner should frequently feel:
> I only need to do this one step now.

### 2.4 Learners should act frequently
The product should minimize long passive reading stretches.

Prefer:
- tapping
- selecting
- matching
- filling one slot
- ordering steps
- choosing methods
- placing items on a timeline

over:
- long explanatory paragraphs
- static MCQ everywhere
- giant formula walls before interaction

### 2.5 Support should not compete with the task
Help should reduce uncertainty, not steal the screen.

The task is primary.  
Support is secondary.  
Worked reasoning is tertiary.

---

## 3. Learning-plan model

Every topic should move through a recognisable progression.

Recommended learning plan:

1. Recognition
2. Input mapping
3. Method choice
4. Period/unit matching
5. Execution
6. Interpretation
7. Transfer

This makes progress feel meaningful and consistent across topics.

### Example mapping

**Time Value**
- recognise timing type
- identify PMT, rate, periods
- match compounding period
- choose annuity/perpetuity method
- compute
- sense-check

**CAPM**
- identify `rf`, beta, and market premium
- choose CAPM
- compute expected return
- compare with actual return
- interpret SML / alpha meaning

**WACC**
- separate debt vs equity inputs
- identify which cost belongs where
- apply tax only to debt
- use market-value weights
- compute WACC
- interpret it

---

## 4. Lesson rhythm

Every lesson should preserve one stable rhythm:

**See task → answer → check → feedback → continue**

This rhythm should stay consistent across lesson types.

### Required properties
- one primary action at a time
- selected answer persists after Check
- feedback is concise
- the next move is obvious
- the lesson always feels in motion

### Good rhythm feels like
- low friction
- fast recovery
- visible progress
- no dead pauses
- no confusion about what happens next

---

## 5. Progressive support

Support should be layered, not dumped up front.

### Support stack
1. **Default nudge**  
   One short directional sentence.
2. **Hint**  
   A slightly stronger clue.
3. **Scaffold**  
   Setup steps, term meanings, partial guidance.
4. **Worked reasoning**  
   Only after attempt or explicit request.

### Rules
- Do not show every support layer at once.
- Do not let support overshadow the problem.
- Support should open progressively and smoothly.
- Worked reasoning should not appear before the learner has tried unless the lesson is explicitly a teaching/demo step.

### Good default support
- “Match the period before choosing the formula.”
- “Name the inputs before calculating.”
- “Decide what kind of problem this is first.”

### Bad default support
- long teaching paragraph
- full worked solution visible immediately
- dense formula panel that competes with the task

---

## 6. Visual hierarchy

Lesson screens should be ordered by attention:

1. task
2. answer area
3. support
4. chrome

The learner’s eye should land on the problem first.

### Rules
- The question should dominate the screen.
- The answer area should feel central and actionable.
- Support should feel adjacent, not equally important.
- Navigation, controls, and analytics should stay quiet during task work.

### Anti-goal
A lesson screen should not feel like:
- a dashboard with a question inserted into it
- a web layout with separate boxes fighting for attention

---

## 7. Progress and motivation

Progress should feel like study guidance, not analytics and not gamification.

### Motivation should come from:
- clarity
- momentum
- finishable steps
- visible movement
- good recovery from mistakes

### Not from:
- streaks
- hearts/lives
- reward currencies
- mascots
- overcelebration

### Good progress copy
- “Work on next”
- “First pass”
- “Ready to revisit”
- “Next: Match the period”
- “You’ve locked in the setup. Now solve.”

### Bad progress copy
- “38% mastery”
- “XP”
- “combo”
- “hot streak”
- “crushed it” for trivial actions

---

## 8. Color guidelines

Color should communicate meaning, not personality.

### Use color for:
- selected state
- current step
- current lesson
- confirmed success
- incorrect state
- review-due state
- primary action

### Do not use color for:
- making neutral content feel less boring
- decorating every content panel
- replacing hierarchy
- adding energy to a weak interaction

### Recommended approach
- neutral content surfaces by default
- one restrained accent for primary action and active state
- green only for confirmed success / settled progress
- red only for wrong/error states
- optional topic colors, but soft and secondary

### Practical finc'd rules
- most lesson surfaces remain neutral
- the progress indicator may carry topic tint
- selected answer state should be clearer than neutral
- correct/incorrect state should be unmistakable
- avoid multiple competing accent systems on one screen

---

## 9. Motion guidelines

Motion should confirm change of state, not entertain.

### Good motion moments
- answer selection
- check result reveal
- continue transition
- progress-bar advance
- support disclosure opening
- entering a new subtopic
- step completion confirmation

### Bad motion moments
- constant pulsing
- bouncing decoration
- unrelated flourish
- loud celebration after minor actions
- motion that competes with concentration

### Motion principles
- short
- subtle
- responsive
- informative
- optionality-aware
- respectful of reduced-motion settings

### Rule
Motion should make the app feel alive, not busy.

---

## 10. Visual feedback rules

This is where the app should “pop” most.

Not by becoming loud, but by making state changes obvious and satisfying.

### 10.1 Selection state
When an answer is selected:
- the row should feel clearly activated
- the learner should feel “my choice has registered”
- use contrast, accent, and subtle motion

### 10.2 Check state
When Check is pressed:
- the system should respond immediately
- the chosen answer should remain visible
- the outcome should be unambiguous

### 10.3 Correct state
Correct state should:
- confirm success
- highlight the right choice clearly
- reinforce momentum toward Continue
- avoid long victory speeches

### 10.4 Incorrect state
Incorrect state should:
- preserve the learner’s choice
- show the correct answer when useful
- explain the misconception briefly
- make retry/recovery obvious

### 10.5 Step-complete state
When a step is completed:
- progress should visibly advance
- the next step should feel unlocked
- the learner should feel movement, not reset

### 10.6 New-topic state
When a new topic/subtopic begins:
- the app should acknowledge it
- the learner should feel oriented
- the screen should briefly frame what this next section is about

Example:
- “You’re now in Bond Building Blocks.”
- “Next: Price Direction Before Price.”
- “Now move from setup to calculation.”

---

## 11. What makes Duolingo “pop” — and what to borrow

Duolingo “pops” because:
- tasks are short
- the next action is obvious
- lessons are highly chunked
- feedback is immediate
- completion happens often
- progress feels continuous
- the learner rarely faces a long unstructured unit

### What finc'd should borrow
- short lesson units
- strong state feedback
- clearer selected/correct/incorrect states
- more frequent completion moments
- finite step counts
- more obvious transitions between small wins

### What finc'd should not borrow
- hearts/lives
- streak obsession
- mascots
- candy-colored saturation
- juvenile copy
- constant reward theatrics

The goal is:
**Duolingo’s pacing, Apple’s presentation, finc’d’s seriousness.**

---

## 12. Welcome moments and transitions

The app should sometimes acknowledge forward movement.

These moments should be:
- quiet
- mature
- structured
- purposeful

### Good welcome moments
- entering a new topic
- starting a new lesson family
- completing a setup section
- moving from recognition to execution
- finishing first pass and entering revisit mode

### Good copy patterns
- “You’re now in Valuation.”
- “Start with Bond Terms First.”
- “Setup complete. Now compute.”
- “You’ve matched the period. Next, choose the method.”

### Rule
These moments should feel like orientation, not celebration theatre.

---

## 13. Feedback copy guidelines

Feedback should be:
- brief
- useful
- specific
- recoverable
- supportive

### Correct feedback should:
- confirm the principle
- keep momentum
- avoid overexplaining

Example:
- “Yes — today’s price uses the next dividend.”
- “Correct. Face value is the amount repaid at maturity.”

### Incorrect feedback should:
- explain the trap
- not sound punitive
- show what to notice next time

Example:
- “Not quite. `$1.00` was paid yesterday, but today’s price uses the next dividend.”
- “11% is the yield, not the face value.”

### Avoid
- “Oopsie!”
- “Amazing!!!”
- vague “Try again”
- robotic “Your answer is incorrect”
- shame-coded phrasing

---

## 14. Anti-patterns

Avoid:

- giant text blobs
- support panels louder than the question
- static MCQ for everything
- giant empty canvas with weak interaction emphasis
- too many chips, badges, and labels
- dashboard-style metrics inside lessons
- decorative motion
- bright gamified palette systems
- overcelebration for tiny progress
- showing all explanation before attempt
- using color instead of hierarchy

---

## 15. Screenshot review checklist

Before approving a new screen, ask:

### Task focus
- Does the eye land on the task first?
- Is the answer area clearly central?
- Is support secondary?

### Cognitive load
- Is the task broken down enough?
- Is the next action obvious?
- Is there too much explanation visible too early?

### Progress
- Does the learner know where they are?
- Does the lesson feel finite?
- Does the app communicate what comes next?

### Feedback
- Is selection clear?
- Is correct/incorrect state obvious?
- Does feedback help recovery?

### Visual tone
- Is color meaningful and restrained?
- Is the screen calm but not dead?
- Is motion doing useful work?
- Does this feel Apple-native and learner-first?

---

## 16. Practical application to finc'd

For finc'd specifically:

- keep the app shell calm and native
- make the lesson area more active
- use micro-step interactions to reduce boredom
- use color to mark meaning, not to add energy
- use motion to confirm progress, not to decorate
- make new topics feel introduced, not just listed
- make wrong answers feel recoverable, not terminal

### Summary rule
The app should not become louder.

It should become:
- clearer
- more responsive
- more structured
- more stateful
- more finishable
