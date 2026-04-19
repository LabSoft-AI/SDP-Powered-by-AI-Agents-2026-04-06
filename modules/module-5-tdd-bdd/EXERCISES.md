# Module 5: TDD/BDD — Exercise Checklist

## Prerequisite: Fix Requirements and INFRA Stories

### Step 1: Update Requirements Agent

- [ ] Updated `requirements-agent.json` to generate Docker-based INFRA stories
- [ ] INFRA stories reference Docker containers (not Lambda/DynamoDB)
- [ ] Deployment target is `docker build` + `docker run`

### Step 2: Regenerate INFRA Stories

- [ ] Regenerated INFRA sub-stories with updated requirements agent
- [ ] INFRA stories cover: Dockerfile builds, tests run in Docker, dependencies installed

### Step 3: Verify INFRA Stories Pass

- [ ] `docker build -t kata-tests .` succeeds
- [ ] `docker run --rm kata-tests` runs tests
- [ ] CI pipeline from Module 4 is GREEN

---

## Part 1: Manual TDD Cycle

### Step 1: Pick a Scenario

- [ ] Selected one BE scenario from user stories
- [ ] Scenario is simple enough for one sitting

### Step 2: Write the Test (RED)

- [ ] Written ONE test with GIVEN-WHEN-THEN comments
- [ ] Test references Story ID and Scenario ID
- [ ] Ran test locally — observed RED (failing). Do NOT commit on RED.

### Step 3: Make It Pass (GREEN)

- [ ] Written simplest code to make test pass
- [ ] Ran test — confirmed GREEN (passing)
- [ ] Ran ALL tests — confirmed no regressions

### Step 4: Refactor

- [ ] Checked for duplicated code
- [ ] Improved naming if needed
- [ ] Ran ALL tests after refactoring

### Step 5: Commit (only on GREEN!)

- [ ] Committed with story/scenario reference in message

---

## Part 2: Build and Use the TDD/BDD Agent

### Step 1: Build the TDD/BDD Agent

- [ ] Copied `tdd-bdd-agent.json` and `tdd-bdd-prompt.md` to `.kiro/agents/`
- [ ] Completed TODO: Test Naming Convention
- [ ] Completed TODO: GIVEN-WHEN-THEN Test Template
- [ ] Completed TODO: Green Bar Pattern Rules
- [ ] Completed TODO: Refactoring Checklist
- [ ] Completed TODO: Commit Message Format
- [ ] Completed TODO: postToolUse Hook (runs pytest after writes)

### Step 2: Multi-Agent Workflow (repeat for each user story)

For each user story, follow this loop:

> **Switch agent:** `git-agent`
> ```bash
> kiro-cli --agent git-agent
> ```

- [ ] **Git agent:** took highest priority unimplemented story
- [ ] **Git agent:** created GitHub issue with story content and acceptance criteria
- [ ] **Git agent:** created feature branch for the issue

> **Switch agent:** `tdd-bdd-agent`
> ```bash
> kiro-cli --agent tdd-bdd-agent
> ```

- [ ] **TDD/BDD agent:** read the issue and user story scenarios
- [ ] **TDD/BDD agent:** followed INFRA → BE → FE → E2E order
- [ ] For each scenario in the story:
  - [ ] Wrote ONE test → ran locally → observed RED (failing)
  - [ ] Wrote implementation → ran → confirmed GREEN (passing)
  - [ ] Ran ALL tests → no regressions
  - [ ] Checked for refactoring opportunities
  - [ ] **Committed on GREEN** with story/scenario reference (only commit on GREEN!)

> **Switch agent:** `git-agent`
> ```bash
> kiro-cli --agent git-agent
> ```

- [ ] **Git agent:** created PR closing the issue
- [ ] **Git agent:** added instructor as reviewer (`gh pr edit --add-reviewer momokrunic`)

> ♻️ **Repeat from the top** with the next highest priority story.

### Step 3: Verify TDD Discipline

- [ ] Git log shows one commit per GREEN test (each commit = one scenario passing)
- [ ] All commits have passing tests (no RED commits in history)
- [ ] Test names include Story/Scenario IDs
- [ ] All tests have GIVEN-WHEN-THEN comments

### Step 4: Review and Merge

- [ ] PR approved by instructor
- [ ] Merged to main via `gh pr merge --squash`
- [ ] Issue auto-closed
