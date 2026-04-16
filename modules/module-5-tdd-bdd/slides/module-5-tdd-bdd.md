# Module 5: TDD/BDD

## Slide 1: Module 5: TDD/BDD
**Type:** title
**Content:**
Module 5: TDD/BDD
Software Development Processes Powered by AI Agents

**Notes:**
Welcome to Module 5 — the most important module in the course. Today you learn Test-Driven Development and Behavior-Driven Development, and you build the most complex agent: one that implements your kata using strict RED-GREEN-REFACTOR discipline.
This module draws heavily from real industry experience at major European automotive OEMs and aerospace projects.

---

## Slide 2: The Punch Card Origin
**Type:** storytelling
**Content:**
TDD was invented in the 1950s, when programming meant punching holes in cards. Computer time was incredibly expensive — you might wait days for a 30-minute slot. So engineers developed a discipline: first, punch an output card with the expected result. Then punch the program cards. Then compare. They specified expectations before implementation. They were doing Test-Driven Development before the term existed. The constraint of expensive feedback forced them to think before coding. Today we have instant feedback, but many developers have lost that discipline. TDD brings it back.

**Notes:**
This story comes from Kent Beck's research into the history of TDD. The punch card era teaches us something profound: when feedback is expensive, you design before you code and specify expectations before you verify.
Today, we have instant feedback — we can run tests in seconds. But paradoxically, many developers have lost the discipline of thinking first. TDD restores it. Not because computer time is scarce, but because good design thinking is scarce.

---

## Slide 3: What You'll Learn
**Type:** content
**Content:**
- What You'll Learn
- Understand the Red-Green-Refactor cycle and why tests come first
- Know the difference between TDD (bottom-up) and BDD (top-down)
- Write testable acceptance criteria using GIVEN-WHEN-THEN
- Apply Green Bar patterns: Fake It, Triangulate, Obvious Implementation
- Know when and how to refactor safely
- Build a Kiro CLI agent that implements your kata with strict TDD discipline

**Notes:**
The key deliverable is a working TDD agent that implements your kata one test at a time. This is the most complex agent in the course because it needs to follow a strict cycle: write test, run, implement, run, refactor, commit.

---

## Slide 4: Part 1
**Type:** section
**Content:**
Part 1
The Red-Green-Refactor Cycle

**Notes:**
Let's start with the core of TDD — the three-step cycle that drives everything.

---

## Slide 5: 3
**Type:** big_number
**Content:**
3
The Red-Green-Refactor Cycle
🔴 RED: Write a failing test
✅ GREEN: Make it pass with the simplest code
♻️ REFACTOR: Improve code quality while tests protect you

**Notes:**
This is the heartbeat of TDD. Three steps, repeated for every piece of functionality. RED means you write a test that fails — this proves the test actually tests something. GREEN means you write the minimum code to pass — no over-engineering. REFACTOR means you clean up while tests protect you.
The key insight: you write ONE test at a time. You do not move to the next test until you are satisfied with how your code looks.

---

## Slide 6: The Automotive Platform Story
**Type:** storytelling
**Content:**
In 2022, at a major European automotive OEM, we were building a next-generation software platform. Multiple teams across countries, different vehicle models, long-term maintainability required. Early on, we noticed problems: high coupling, low cohesion, hidden dependencies, difficult testing. We mandated TDD for all new components. Something remarkable happened. Component interfaces became cleaner. Dependencies became explicit. Design discussions improved. Integration problems decreased. Teams that adopted TDD delivered 40% faster with 35% fewer defects. A senior developer told me: "I used to think TDD was about catching bugs. Now I realize it's about not creating bugs in the first place."

**Notes:**
This is the key lesson from that automotive platform project: TDD is not primarily a testing technique — it's a design technique. The tests are valuable, but the real value is in the thinking process TDD forces you through.
When you write the test first, you think about behavior before implementation, you consider the interface before the internals, you identify dependencies before they become entangled, you design for testability which means designing for modularity.

---

## Slide 7: One Test at a Time
**Type:** content
**Content:**
- The Most Important Rule
- Write only **ONE** test at a time
- Implement only **ONE** test at a time
- Do NOT write three tests then implement all three
- Do NOT implement more than what's needed to pass the test
- Once a test is GREEN → **commit immediately**
- Your Git history should show the RED-GREEN-REFACTOR rhythm

**Notes:**
This is the hardest rule to follow and the most important. The temptation is to write several tests at once, or to implement more than needed. Resist it.
One test. Run it. It fails. Implement. Run it. It passes. Refactor. Commit. Next test. This rhythm creates a clean Git history where every commit represents a working, tested increment.

---

## Slide 8: Part 2
**Type:** section
**Content:**
Part 2
Behavior-Driven Development

**Notes:**
BDD is the top-down complement to TDD's bottom-up approach. While TDD starts with unit tests, BDD starts with user behavior.

---

## Slide 9: BDD = Better TDD
**Type:** content
**Content:**
- Behavior-Driven Development
- A better way to talk about TDD — focus on **behavior**, not implementation
- Test method names should be **sentences** describing behavior
- Ask: "What's the next most important thing the system doesn't do?"
- Requirements are behavior — acceptance criteria are scenarios
- **GIVEN-WHEN-THEN** DSL by Dan North and Chris Matts
- Scenarios become executable specifications

**Notes:**
BDD was created by Dan North as a way to improve how people learn and practice TDD. The key insight: instead of thinking about "testing", think about "specifying behavior". Instead of test names like test_calculate_1, use names like test_withdrawal_reduces_balance.
The GIVEN-WHEN-THEN format from Module 3 maps directly to test code. GIVEN is setup, WHEN is the action, THEN is the assertion.

---

## Slide 10: GIVEN-WHEN-THEN = Test Code
**Type:** code
**Content:**
```python
def test_withdrawal_reduces_balance():
    # GIVEN
    account = Account(balance=100)

    # WHEN
    account.withdraw(30)

    # THEN
    assert account.balance == 70
```

**Notes:**
Look at how clean this is. The test name is a sentence. The GIVEN-WHEN-THEN comments make the structure obvious. Anyone can read this test and understand what behavior it verifies.
This is the template for every test you write. GIVEN sets up the preconditions. WHEN performs the action. THEN asserts the expected outcome.

---

## Slide 11: Part 3
**Type:** section
**Content:**
Part 3
Properties of Good Tests

**Notes:**
Not all tests are created equal. Let's look at what makes a test good.

---

## Slide 12: Good Test Properties
**Type:** content
**Content:**
- Properties of Good Tests
  - **Understandable** — anyone can read it and know what it verifies
  - **Maintainable** — changing implementation doesn't break unrelated tests
  - **Repeatable** — same result every time, no external dependencies
  - **Necessary** — every test verifies a distinct behavior
  - **Granular** — one test = one behavior = one reason to fail
  - **Fast** — full suite runs in seconds, not minutes

**Notes:**
These properties come from Kent Beck's Test Driven Development by Example. The most important one for beginners is Granular — one test should test one thing. If a test fails, you should immediately know what's broken.
Isolated tests are critical: tests should not affect one another. One broken test should expose one problem. Tests must be order-independent.

---

## Slide 13: Three Types of Tests
**Type:** content
**Content:**
- Three Types of Tests in TDD
- Test a **return value** or exception
  - `assert calculate_tax(100) == 10`
- Test a **change in state**
  - `account.withdraw(30)` then `assert account.balance == 70`
- Test an **interaction** (mock/spy)
  - `assert email_service.send.called_once_with("user@example.com")`

**Notes:**
Most of your kata tests will be type 1 (return value) and type 2 (state change). Type 3 (interaction) is used when you need to verify that your code calls an external dependency correctly — that's where mocking comes in.

---

## Slide 14: Part 4
**Type:** section
**Content:**
Part 4
Green Bar Patterns

**Notes:**
When your test is RED, how do you make it GREEN? Kent Beck identified three patterns.

---

## Slide 15: Fake It
**Type:** code
**Content:**
```python
# Test expects: calculate_tax(100) == 10

# Fake It — return a constant
def calculate_tax(amount):
    return 10  # Works! But only for this one case

# Later, Triangulate with a second test:
# calculate_tax(200) == 20
# Now you MUST generalize:
def calculate_tax(amount):
    return amount * 0.10
```

**Notes:**
Fake It is the safest pattern. Return a constant. The test goes GREEN immediately. Then add a second test that forces you to generalize.
Why is this powerful? Two effects. Psychological: having a green bar feels completely different from red. You know where you stand. Scope control: you prevent yourself from prematurely solving problems you don't have yet.

---

## Slide 16: Three Green Bar Patterns
**Type:** content
**Content:**
- Green Bar Patterns
- **Fake It** — return a constant, generalize later with Triangulation
  - Safest. Use when unsure about the abstraction.
- **Triangulate** — add a second example to force generalization
  - Use when you need two data points to see the pattern.
- **Obvious Implementation** — go ahead if you're confident
  - Fastest. But if surprised by RED, fall back to Fake It.
  - Keep track of how often you're surprised — that tells you when to slow down.

**Notes:**
These three patterns give you a toolkit for any situation. Unsure? Fake It. Need to generalize? Triangulate. Confident? Obvious Implementation. The key is honesty with yourself — if Obvious Implementation keeps surprising you with red bars, slow down and use Fake It.

---

## Slide 17: Part 5
**Type:** section
**Content:**
Part 5
Refactoring

**Notes:**
The third step of RED-GREEN-REFACTOR. Often skipped, always important.

---

## Slide 18: What Is Refactoring?
**Type:** content
**Content:**
- Refactoring
- Changing software to **improve internal structure** while preserving behavior
- Only refactor during GREEN — never on RED
- The **Two Hats** rule:
  - Hat 1: Adding functionality (write test + implementation)
  - Hat 2: Improving design (refactor)
  - Never wear both hats at the same time

**Notes:**
Refactoring is not rewriting. It's small, safe improvements to code structure while tests protect you. The Two Hats metaphor is from Martin Fowler: when you're adding functionality, don't improve design. When you're improving design, don't add functionality. Mixing them leads to bugs.

---

## Slide 19: Refactoring Checklist
**Type:** content
**Content:**
- When to Refactor
- When it becomes **hard to write the next test**
- When you see **duplicated code**
- When **variable names** are unclear
- When **conditional logic** is complex
- When a function does **too many things**
- After EVERY green test — ask: "Can I improve this?"
- Run tests after **every** refactoring change

**Notes:**
The refactoring step is what separates TDD practitioners from TDD beginners. Beginners skip it. Practitioners know it's where the real design improvement happens.
Remember: refactor in small steps. Change one thing, run tests. Change another thing, run tests. If a test breaks, you know exactly which change caused it.

---

## Slide 20: When NOT to Refactor
**Type:** content
**Content:**
- When NOT to Refactor
- The code **doesn't work** — fix it first
- It's **cheaper to rewrite** from scratch
- You're **close to a deadline** — note the tech debt, move on
- You don't have **tests** — write tests first, then refactor
- Legacy code = code without tests

**Notes:**
The last point is critical: legacy code is code without tests. If you don't have tests, you can't refactor safely. Write tests first — even if they're just characterization tests that capture current behavior — then refactor.

---

## Slide 21: Part 6
**Type:** section
**Content:**
Part 6
Implementation Order

**Notes:**
From Module 3, your stories are decomposed into layers. The order you implement them matters.

---

## Slide 22: INFRA → BE → FE → E2E
**Type:** content
**Content:**
- Implementation Order
- **INFRA** → Docker setup (Module 4 — already done)
- **BE** → Business logic and tests (this module)
- **FE** → UI components (if applicable)
- **E2E** → Full flow verification
- You can't build a UI for an API that doesn't exist
- You can't deploy code without infrastructure
- For your kata: INFRA is Docker, BE is your core logic

**Notes:**
This is the backend-first mandate. Infrastructure first, then business logic, then frontend, then end-to-end tests. Each layer depends on the one below it.
For your kata, INFRA should already be done from Module 4 — your Dockerfile and CI pipeline. Now you focus on BE stories: the actual business logic of your kata, implemented one test at a time.

---

## Slide 23: Part 7
**Type:** section
**Content:**
Part 7
Prerequisite: Fix INFRA Stories

**Notes:**
Before you start TDD, you need to update your Module 3 output. Your requirements agent generated AWS-based INFRA stories, but your kata runs in Docker.

---

## Slide 24: Fix Requirements Agent
**Type:** content
**Content:**
- Prerequisite: Update Requirements Agent
- Module 3 generated INFRA stories for AWS (Lambda, DynamoDB)
- Your kata runs locally in Docker (Module 4)
- Update `requirements-agent.json` to force Docker-based INFRA stories
- Regenerate INFRA sub-stories
- Verify they pass: `docker build` + `docker run`
- Once INFRA is GREEN → move to BE stories

**Notes:**
This is an important lesson: requirements change. Your Module 3 agent assumed AWS deployment, but your kata uses Docker. You need to update the agent and regenerate. This is normal in real projects — requirements evolve as you learn more about the system.

---

## Slide 25: Part 8
**Type:** section
**Content:**
Part 8
Exercise: Build the TDD/BDD Agent

**Notes:**
Now the main event. You'll build the most complex agent in the course — one that follows strict TDD discipline.

---

## Slide 26: The TDD/BDD Agent Cycle
**Type:** content
**Content:**
- TDD/BDD Agent — Strict Cycle
- 1. **Write ONE test** for the selected scenario
- 2. **Execute** → confirm RED
- 3. **Write just enough implementation** to pass
- 4. **Execute** → confirm GREEN
- 5. **Execute ALL tests** → confirm no regressions
- 6. **Check refactoring** opportunities
- 7. **Commit** (GREEN = safe to commit)
- 8. **Move to next scenario**

**Notes:**
This is the exact cycle your agent must follow. No shortcuts. Write one test, confirm it fails, implement, confirm it passes, check for regressions, refactor, commit. Then ask which scenario to do next.
The agent uses a file URI prompt — the prompt lives in a separate markdown file. This is a best practice from the Kiro CLI docs for complex agents.

---

## Slide 27: Agent Configuration
**Type:** code
**Content:**
```json
{
  "name": "tdd-bdd-agent",
  "prompt": "file://./tdd-bdd-prompt.md",
  "tools": ["read", "write", "shell"],
  "allowedTools": ["read"],
  "resources": [
    "file://docs/user-stories/**/*.md"
  ],
  "hooks": {
    "postToolUse": [{
      "matcher": "fs_write",
      "command": "pytest tests/ -v --tb=short"
    }]
  }
}
```

**Notes:**
This agent uses advanced Kiro CLI features. The prompt is in a separate file for readability. Resources auto-load user stories. The postToolUse hook runs pytest after every file write — so the agent gets immediate feedback on whether tests pass.
Students need to complete the TODO sections in the prompt file: test naming convention, GIVEN-WHEN-THEN template, Green Bar pattern rules, refactoring checklist, and commit format.

---

## Slide 28: 6
**Type:** big_number
**Content:**
6
TODOs in the Starter
Test naming convention, GIVEN-WHEN-THEN template, Green Bar patterns, refactoring checklist, commit format, postToolUse hook.
The most complex agent — because TDD is the most disciplined process.

**Notes:**
This agent has six TODO sections — more than any previous module. That's because TDD requires the most discipline. The agent needs to know how to name tests, how to structure them, when to use which Green Bar pattern, what to check during refactoring, and how to format commits.

---

## Slide 29: Using the Agent
**Type:** code
**Content:**
```bash
# Start the TDD/BDD agent
kiro-cli --agent tdd-bdd-agent

> Read my user stories at docs/user-stories/
> Start with the first BE scenario
> Follow strict RED-GREEN-REFACTOR

# Verify TDD discipline in Git history
git log --oneline
# Each commit = one GREEN test
```

**Notes:**
The workflow: start the agent, point it at your user stories, and let it implement one scenario at a time. After each session, check your Git log — it should show a clean sequence of commits, each representing a passing test.

---

## Slide 30: Acceptance Criteria
**Type:** content
**Content:**
- Acceptance Criteria
- [ ] Requirements agent updated for Docker-based INFRA
- [ ] INFRA stories pass (Docker build + test run)
- [ ] Agent config at `.kiro/agents/tdd-bdd-agent.json`
- [ ] Agent writes ONE test at a time
- [ ] Agent confirms RED before implementing
- [ ] Agent confirms GREEN after implementing
- [ ] Agent runs ALL tests for regressions
- [ ] Agent commits on GREEN with story reference
- [ ] Git history shows RED-GREEN-REFACTOR rhythm

**Notes:**
The most important criterion: Git history shows the rhythm. Each commit should be a GREEN test. No commits with failing tests. The story and scenario IDs should be traceable in test names and commit messages.

---

## Slide 31: 🎯
**Type:** big_number
**Content:**
🎯
Key Takeaway
TDD is not about testing. It's about design.
Write the test first. Let it guide your implementation.
One test at a time. Commit on GREEN. Refactor fearlessly.

**Notes:**
After this module, you have all five agents: Git, Architecture, Requirements, CI/CD, and TDD/BDD. In Module 6, you'll use all of them together as a team to build the Subscription Platform.
The TDD agent is the culmination of everything — it reads stories from Module 3, runs tests in the Docker pipeline from Module 4, and commits via the Git conventions from Module 1. All the modules connect.
