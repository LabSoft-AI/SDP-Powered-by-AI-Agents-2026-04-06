# Module 5: TDD/BDD

## Table of Contents

- [Learning Objectives](#learning-objectives)
- [1. Theory: Test-Driven Development](#1-theory-test-driven-development)
  - [1.1 Why TDD?](#11-why-tdd)
  - [1.2 The Red-Green-Refactor Cycle](#12-the-red-green-refactor-cycle)
  - [1.3 TDD Is a Design Technique](#13-tdd-is-a-design-technique)
  - [1.4 Behavior-Driven Development (BDD)](#14-behavior-driven-development-bdd)
  - [1.5 Properties of Good Tests](#15-properties-of-good-tests)
  - [1.6 Green Bar Patterns](#16-green-bar-patterns)
  - [1.7 Refactoring: The Third Step](#17-refactoring-the-third-step)
  - [1.8 Implementation Order: INFRA → BE → FE → E2E](#18-implementation-order-infra--be--fe--e2e)
  - [1.9 One Test at a Time](#19-one-test-at-a-time)
- [2. Prerequisite: Fix Requirements and INFRA Stories](#2-prerequisite-fix-requirements-and-infra-stories)
- [3. Exercise Part 1: Manual TDD Cycle](#3-exercise-part-1-manual-tdd-cycle)
- [4. Exercise Part 2: Build and Use the TDD/BDD Agent](#4-exercise-part-2-build-and-use-the-tddbdd-agent)
- [References](#references)

## Learning Objectives

By the end of this module you will:

- Understand the Red-Green-Refactor cycle and why tests come first
- Know the difference between TDD (bottom-up) and BDD (top-down)
- Write testable acceptance criteria using GIVEN-WHEN-THEN
- Apply Green Bar patterns: Fake It, Triangulate, Obvious Implementation
- Know when and how to refactor safely
- Build a Kiro CLI agent that implements your kata using strict TDD discipline

## 1. Theory: Test-Driven Development

### 1.1 Why TDD?

TDD was invented in the punch card era of the 1950s. Computer time was
scarce and expensive — you might wait days for your 30-minute slot. So
engineers developed a discipline: **specify the expected output first**
(punch an output card), **then write the program** (punch input cards),
**then verify** (compare cards).

They were doing Test-Driven Development before the term existed. The
constraint of expensive feedback forced them to think before coding.

Today we have instant feedback, but many developers have lost that
discipline. TDD brings it back — not because computer time is scarce,
but because **good design thinking is scarce**.

At BMW, with 500 million lines of code and 160,000 CI jobs per day,
TDD was the only way 2,000+ developers could work on the same codebase
without breaking each other's work. At Volkswagen, teams that adopted
TDD delivered **40% faster** with **35% fewer defects**.

### 1.2 The Red-Green-Refactor Cycle

The heartbeat of TDD:

```text
🔴 RED     → Write a failing test
✅ GREEN   → Write just enough code to make it pass
♻️ REFACTOR → Improve the code while tests protect you
```

**Rules:**

1. Write **one** test. Run it. It must fail (RED).
2. Write the **simplest** code that makes the test pass (GREEN).
3. Look for refactoring opportunities. Clean up. Run tests again.
4. Repeat.

You write **one test at a time**. You do not move to the next test
until you are satisfied with how your code looks.

### 1.3 TDD Is a Design Technique

TDD is not primarily a testing technique — it's a **design technique**.
The tests are valuable, but the real value is in the thinking process
TDD forces you through.

When you write the test first:

- You think about **behavior** before implementation
- You consider the **interface** before the internals
- You identify **dependencies** before they become entangled
- You design for **testability**, which means designing for modularity

A senior developer at VW told me: *"I used to think TDD was about
catching bugs. Now I realize it's about not creating bugs in the first
place by forcing better design."*

### 1.4 Behavior-Driven Development (BDD)

BDD is the top-down complement to TDD's bottom-up approach. While TDD
starts with unit tests and builds upward, BDD starts with **user
behavior** and works downward.

BDD uses the **GIVEN-WHEN-THEN** format from Module 3:

```text
GIVEN the account balance is €100
WHEN the customer withdraws €30
THEN the balance should be €70
```

This maps directly to test code:

```python
def test_withdrawal_reduces_balance():
    # GIVEN
    account = Account(balance=100)

    # WHEN
    account.withdraw(30)

    # THEN
    assert account.balance == 70
```

**BDD key principles:**

- Test method names should be **sentences** describing behavior
- Ask: *"What's the next most important thing the system doesn't do?"*
- Requirements are behavior — acceptance criteria are scenarios
- Scenarios become executable specifications

### 1.5 Properties of Good Tests

| Property | Meaning |
|----------|---------|
| **Understandable** | Anyone can read the test and know what it verifies |
| **Maintainable** | Changing implementation doesn't break unrelated tests |
| **Repeatable** | Same result every time, no external dependencies |
| **Necessary** | Every test verifies a distinct behavior |
| **Granular** | One test = one behavior = one reason to fail |
| **Fast** | The full suite runs in seconds, not minutes |

**Isolated tests:** Tests should not affect one another. One broken test
should expose one problem. Tests must be order-independent.

**Three types of tests in TDD:**

1. Test a **return value** or exception
2. Test a **change in state**
3. Test an **interaction** (mock/spy)

### 1.6 Green Bar Patterns

When the test is RED, use these patterns to make it GREEN:

**Fake It ('Til You Make It)** — Return a constant. Having something
running is better than not having something running. The duplication
between test and fake implementation drives abstraction.

```python
def calculate_tax(amount):
    return 10  # Fake it — we know the test expects 10
```

**Triangulate** — Abstract only when you have two or more examples.
Use triangulation when you're unsure about the correct abstraction.

```python
# Test 1: calculate_tax(100) == 10
# Test 2: calculate_tax(200) == 20
# Now you MUST generalize: return amount * 0.10
```

**Obvious Implementation** — When you're sure you know how to implement
it, go ahead. But if you're surprised by red bars, fall back to Fake It.
Keep track of how often you're surprised — that tells you when to slow
down.

### 1.7 Refactoring: The Third Step

Refactoring means changing software to **improve its internal structure**
while preserving its behavior.

**When to refactor:**

- Only during the GREEN stage — never refactor on RED
- When it becomes hard to write the next test
- When resolving technical debt
- When code readability can be improved

**Principles:**

- Refactor in **small steps**
- Run tests **frequently** — they're your safety net
- Eliminate **duplicated code**
- Use **meaningful variable names**
- Apply the **Two Hats** rule: one hat for adding functionality, one
  hat for improving design — never both at the same time

**When NOT to refactor:**

- The code doesn't work (fix it first)
- It's cheaper to rewrite from scratch
- You're close to a deadline (note the tech debt, move on)

### 1.8 Implementation Order: INFRA → BE → FE → E2E

From Module 3, your stories are decomposed into sub-stories. The
implementation order matters:

```text
1. INFRA stories → Deploy infrastructure (Docker, configs)
2. BE stories    → Implement business logic, API endpoints
3. FE stories    → Build UI components (if applicable)
4. E2E tests     → Verify the full flow works end-to-end
```

You can't build a UI for an API that doesn't exist. You can't deploy
code without infrastructure. Follow the order.

For your kata, INFRA means your Docker setup (from Module 4). BE means
your core logic and tests. FE and E2E may not apply depending on your
kata.

### 1.9 One Test at a Time

This is the most important rule and the hardest to follow:

> **Write only ONE test at a time. Implement only ONE test at a time.**

Do not write three tests and then implement all three. Do not write a
test and then implement more than what's needed to pass it.

The cycle is:

1. Pick the next scenario from your user story
2. Write ONE test for that scenario
3. Run it — confirm RED
4. Write just enough code to make it GREEN
5. Run ALL tests — confirm no regressions
6. Refactor if needed
7. Commit (test is GREEN = safe to commit)
8. Move to the next scenario

**Once a test is GREEN, commit.** Your Git history should show the
RED-GREEN-REFACTOR rhythm clearly.

---

## 2. Prerequisite: Fix Requirements and INFRA Stories

Before implementing with TDD, you need to update your Module 3 output:

### Step 1: Update Requirements Agent

Your requirements agent (Module 3) generated INFRA stories that assumed
AWS deployment. Since your kata runs locally in Docker (Module 4), you
need to update the agent to generate **Docker-based INFRA stories**
instead.

Update your `requirements-agent.json` to force local deployment:

- INFRA stories should reference Docker containers, not Lambda/DynamoDB
- The deployment target is `docker build` + `docker run`, not SAM/CloudFormation
- Test execution happens inside Docker via `pytest`

### Step 2: Regenerate INFRA Stories

Use your updated requirements agent to regenerate the INFRA sub-stories
for your kata. The new INFRA stories should cover:

- [ ] Dockerfile builds successfully
- [ ] Test suite runs inside Docker container
- [ ] Dependencies are installed correctly
- [ ] Project structure supports pytest discovery

### Step 3: Verify INFRA Stories Pass

Your Module 4 pipeline should already satisfy these INFRA stories. Run
your CI pipeline to confirm:

```bash
docker build -t kata-tests .
docker run --rm kata-tests
```

If this passes, your INFRA stories are GREEN and you can move to BE
stories.

---

## 3. Exercise Part 1: Manual TDD Cycle

### Goal

Practice the RED-GREEN-REFACTOR cycle manually on one BE scenario from
your kata before automating it with an agent.

### Step 1: Pick a Scenario

Choose one BE scenario from your user stories (Module 3). It should be
simple enough to implement in one sitting.

### Step 2: Write the Test (RED)

Write a single test for that scenario using pytest and GIVEN-WHEN-THEN:

```python
def test_scenario_name():
    # GIVEN
    # ... setup

    # WHEN
    # ... action

    # THEN
    assert ...  # expected outcome
```

Run it. Confirm it fails.

### Step 3: Make It Pass (GREEN)

Write the **simplest** code that makes the test pass. Don't over-engineer.
Fake It if needed.

Run the test. Confirm it passes. Run ALL tests. Confirm no regressions.

### Step 4: Refactor

Look at your code. Can you improve naming? Remove duplication? Simplify?

Make changes. Run tests after each change.

### Step 5: Commit

```bash
git add .
git commit -m "#<issue> feat(<scope>): implement <scenario description>"
```

---

## 4. Exercise Part 2: Build and Use the TDD/BDD Agent

### Goal

Build a Kiro CLI agent that implements your kata using strict TDD
discipline — one test at a time, RED-GREEN-REFACTOR, commit on GREEN.

This is the most complex agent in the course. Use the
[Kiro CLI agent creation guide](https://kiro.dev/docs/cli/custom-agents/creating/)
and [configuration reference](https://kiro.dev/docs/cli/custom-agents/configuration-reference/)
to build it.

### Step 1: Build the TDD/BDD Agent

Create `.kiro/agents/tdd-bdd-agent.json` using the starter template at
[starter/tdd-bdd-agent.json](starter/tdd-bdd-agent.json).

The agent must follow this strict cycle for each scenario:

1. **Write the test** for the selected user story scenario
2. **Execute** to confirm it is RED
3. **Write just enough implementation** to make the test pass
4. **Execute** the test to confirm it is GREEN
5. **Execute all tests** to confirm no regressions
6. **Check for refactoring** opportunities to improve code quality while preserving behavior
7. **Commit** (test is GREEN = safe to commit)
8. **Move to next scenario**

**Critical rules:**

- Write only **ONE** test at a time
- Implement only **ONE** test at a time
- Execution order: INFRA → BE → FE → E2E
- Once a test is GREEN, commit immediately
- Use GIVEN-WHEN-THEN comments in every test
- Reference the Story ID and Scenario ID in test names

### Step 2: Configure the Agent

The TDD/BDD agent needs more capabilities than previous agents. Use the
[configuration reference](https://kiro.dev/docs/cli/custom-agents/configuration-reference/)
to configure:

- **`tools`** — `read`, `write`, `shell` (for running tests)
- **`allowedTools`** — `read` (auto-approve reads for speed)
- **`resources`** — load your user stories from `docs/user-stories/`
- **`hooks`** — consider `postToolUse` hooks to auto-run tests after writes

Example resource configuration:

```json
{
  "resources": [
    "file://docs/user-stories/**/*.md"
  ]
}
```

Example hook to run tests after every file write:

```json
{
  "hooks": {
    "postToolUse": [
      {
        "matcher": "fs_write",
        "command": "docker run --rm -v $(pwd):/app -w /app kata-tests pytest tests/ -v --tb=short 2>&1 | tail -20"
      }
    ]
  }
}
```

### Step 3: Use the Agent

```bash
kiro-cli --agent tdd-bdd-agent

> Read my user stories at docs/user-stories/
> Start with the first BE scenario of the first core story
> Follow strict RED-GREEN-REFACTOR — one test at a time
```

The agent should:

1. Read the scenario from your user stories
2. Write ONE test → run it → confirm RED
3. Write implementation → run it → confirm GREEN
4. Run ALL tests → confirm no regressions
5. Suggest refactoring if needed
6. Commit with story/scenario reference
7. Ask which scenario to do next

### Step 4: Verify TDD Discipline in Git History

Your Git log should show the RED-GREEN-REFACTOR rhythm:

```bash
git log --oneline
# Each commit should be a GREEN test
# No commits with failing tests
```

### Step 5: Commit via Git Agent

```bash
kiro-cli --agent git-agent

> Create a branch for the TDD implementation issue
> Create a PR closing the issue
```

### Step 6: Add Instructor as Reviewer and Merge

```bash
gh pr edit --add-reviewer momokrunic
```

Wait for approval, then merge:

```bash
gh pr merge --squash
```

### Acceptance Criteria

- [ ] Requirements agent updated to generate Docker-based INFRA stories
- [ ] INFRA stories pass (Docker build + test run)
- [ ] Agent config exists at `.kiro/agents/tdd-bdd-agent.json`
- [ ] Agent reads user stories and follows INFRA → BE → FE → E2E order
- [ ] Agent writes ONE test at a time
- [ ] Agent confirms RED before implementing
- [ ] Agent confirms GREEN after implementing
- [ ] Agent runs ALL tests to check for regressions
- [ ] Agent suggests refactoring opportunities
- [ ] Agent commits on GREEN with story/scenario reference
- [ ] Git history shows RED-GREEN-REFACTOR rhythm
- [ ] PR created via Git agent with instructor as reviewer

---

## References

- [Test Driven Development: By Example (Kent Beck)](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)
- [Refactoring (Martin Fowler)](https://refactoring.com/)
- [BDD Introduction (Dan North)](https://dannorth.net/introducing-bdd/)
- [GIVEN-WHEN-THEN (Cucumber)](https://cucumber.io/docs/gherkin/reference/)
- [pytest Documentation](https://docs.pytest.org/)
- [pytest-bdd](https://pytest-bdd.readthedocs.io/)
- [Kiro CLI Agent Creation](https://kiro.dev/docs/cli/custom-agents/creating/)
- [Kiro CLI Agent Configuration Reference](https://kiro.dev/docs/cli/custom-agents/configuration-reference/)
- [Coding Dojo Kata Catalogue](https://codingdojo.org/kata/)
