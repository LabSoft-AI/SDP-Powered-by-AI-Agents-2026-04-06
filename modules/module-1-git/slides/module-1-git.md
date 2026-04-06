# Module 1: Git

## Slide 1: Module 1: Git
**Type:** title
**Content:**
Module 1: Git
Software Development Processes Powered by AI Agents

**Notes:**
Welcome to Module 1. Today we cover Git — the foundation of every collaborative software project.
By the end of this module you'll understand Git workflows, conventions, and you'll build your first Kiro CLI agent that automates Git operations.

---

## Slide 2: The Origin of Git
**Type:** storytelling
**Content:**
In 2005, Linus Torvalds — the creator of Linux — had a problem. The Linux kernel had thousands of contributors worldwide, and their version control tool (BitKeeper) revoked its free license. In just 10 days, Torvalds built Git from scratch. His goals: speed, distributed design, and the ability to handle massive projects with thousands of parallel branches. Within months, Git replaced every alternative. Today it is the universal standard for professional software development — not because it's simple, but because no other tool handles collaboration at scale as well.

**Notes:**
Linus Torvalds created Git in 2005 out of necessity. The Linux kernel project lost access to BitKeeper, and no existing tool met their needs: thousands of developers, millions of lines of code, hundreds of parallel branches.
He built the first version in 10 days. The design priorities were speed, data integrity, and support for distributed workflows — every developer gets a full copy of the repository.
Today, Git is not optional in professional software development. GitHub alone hosts over 400 million repositories. Every company, every open source project, every serious developer uses Git. It's the foundation everything else is built on — CI/CD, code review, deployment pipelines — all assume Git underneath.

---

## Slide 3: What You'll Learn
**Type:** content
**Content:**
- What You'll Learn
- Understand Git fundamentals and why version control matters
- Use a branching strategy in a team setting
- Write structured commit messages that link to issues
- Create GitHub Issues and Pull Requests following a convention
- Configure pre-commit hooks as a local quality safeguard
- Build a Kiro CLI agent that automates Git operations

**Notes:**
These are our learning objectives. Notice the last one — you're not just learning Git, you're building an AI agent that does Git operations for you.
This is the pattern for the entire course: learn the process, then automate it with an agent.

---

## Slide 4: Part 1
**Type:** section
**Content:**
Part 1
Theory: Git Essentials

**Notes:**
Let's start with the theory. Even if you've used Git before, pay attention to the conventions — they matter when working in teams.

---

## Slide 5: What Is Git?
**Type:** content
**Content:**
- What Is Git?
- Distributed version control system — every developer has a full copy
- Work offline, commit locally, no single point of failure
- Branching and merging are fast and cheap
- Key concepts: repository, commit, branch, merge, remote, clone, pull, push

**Notes:**
Git is distributed. That means every clone is a full backup. If GitHub goes down, you still have the entire history on your machine.
The key insight is that branches are cheap. Creating a branch takes milliseconds. This is what makes the branching strategy we'll discuss next actually practical.

---

## Slide 6: Branching Strategy
**Type:** content
**Content:**
- Branching Strategy
- `main` — production-ready code (auto-deploy to Staging)
- `feature/*` — new functionality (auto-deploy to Development)
- `fix/*` — bug fixes (auto-deploy to Development)
- `hotfix/*` — urgent production fixes (auto-deploy to Development)
- `chore/*` — maintenance tasks (auto-deploy to Development)
- `v*` tags — production releases (manual deploy)

**Notes:**
A branching strategy defines how a team uses branches. Without one, you get chaos — developers overwriting each other, broken main branches, no clear path to production.
Notice the naming convention: lowercase with hyphens, short but descriptive. No issue numbers in branch names — we reference issues in commits instead.

---

## Slide 7: ⚠️
**Type:** big_number
**Content:**
⚠️
Integration Hell
Long-lived branches diverge from main. Conflicts pile up. Merging becomes painful, risky, and time-consuming.
Keep branches short-lived: merge within 1–2 days. Sync with main daily.

**Notes:**
This is one of the most common mistakes in teams. Someone creates a branch, works on it for two weeks, and then tries to merge. By that point, main has moved so far ahead that the merge is a nightmare.
The fix is simple: keep branches short-lived and sync daily. If your feature takes longer than two days, break it into smaller issues.

---

## Slide 8: Syncing with Main
**Type:** code
**Content:**
```bash
# Fetch latest changes from remote
git fetch origin

# Merge main into your feature branch
git merge origin/main

# If conflicts: resolve, then
git add <resolved-files>
git merge --continue
```

**Notes:**
This is the daily habit. Fetch, merge main into your branch. If there are conflicts, they'll be small and easy to resolve because you're doing this every day.
We use merge instead of rebase in this course because merge is safer for beginners — it doesn't rewrite history, so there's no risk of losing work.

---

## Slide 9: Commit Convention
**Type:** content
**Content:**
- Commit Convention
- Format: `#<issue> <type>(<scope>): <description>`
- Types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`, `ci`
- Scope is mandatory and lowercase
- Subject line in imperative mood: "add", not "added"
- Reference the GitHub issue number at the start

**Notes:**
Commits are the atomic unit of your project history. A good commit message tells the team what changed and why — without reading the code.
We use Conventional Commits with GitHub issue references. The scope is mandatory — it tells you which part of the codebase changed. The issue number links the commit to the work item.

---

## Slide 10: Good vs Bad Commits
**Type:** code
**Content:**
```bash
# Bad — no issue, no type, no scope, vague
git commit -m "fix stuff"

# Good — traceable, typed, scoped, descriptive
git commit -m "#42 feat(auth): add OAuth2 login endpoint"

# With body to auto-close issue
git commit -m "#42 feat(auth): add OAuth2 login endpoint

Closes #42"
```

**Notes:**
Look at the difference. The bad commit tells you nothing. The good commit tells you: it's related to issue 42, it's a new feature, it's in the auth module, and it adds an OAuth2 login endpoint.
The Closes keyword in the body will automatically close the issue when this commit is merged to main.

---

## Slide 11: GitHub Issues
**Type:** content
**Content:**
- GitHub Issues
- Every piece of work starts with an issue
- Type prefixes: `[FEAT]`, `[BUG]`, `[DOCS]`, `[INFRA]`
- Required sections: Description, Problem/Goal, Proposed Solution
- Acceptance Criteria with checkboxes = Definition of Done
- Labels: type, component, priority

**Notes:**
Issues are how you plan and track work. The acceptance criteria checkboxes serve as a Definition of Done — the issue is complete only when all boxes are checked.
This is important because it makes "done" unambiguous. No more "I think it's done" — either all boxes are checked or they're not.

---

## Slide 12: Issue Template
**Type:** code
**Content:**
```markdown
[FEAT] Brief descriptive title

## 📋 Description
What needs to be done.

## 🎯 Problem/Goal
Why this matters.

## 💡 Proposed Solution
How to approach it.

## ✅ Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## 🏷️ Labels
- Type: enhancement
- Component: backend
- Priority: priority/high
```

**Notes:**
This is the template. Every issue follows this format. The emojis are optional but they make scanning issues much faster.
Notice the acceptance criteria — these are checkboxes. When you're working on the issue, you check them off as you complete each one.

---

## Slide 13: Pull Requests
**Type:** content
**Content:**
- Pull Requests
- A request to merge your branch into `main`
- Where code review happens
- Must link to issue with `Closes #N`
- Keep PRs small and focused — one feature or fix
- Only add reviewers after CI/CD checks pass

**Notes:**
Pull requests are the quality gate. No code goes to main without a PR and at least one review.
The key rule: keep PRs small. A 50-line PR gets a thorough review. A 2000-line PR gets a rubber stamp. Small PRs are always better.

---

## Slide 14: PR Template
**Type:** code
**Content:**
```markdown
#42 [FEAT] Brief descriptive title

## Related Issue
Closes #42

## Changes
- Change 1
- Change 2

## Testing
- [ ] Tested locally
- [ ] Tests pass
- [ ] Pre-commit hooks pass
```

**Notes:**
This is the PR template. The title references the issue. The body links to it with Closes. The testing section is a checklist you complete before requesting review.
Never add reviewers to a failing PR. Fix it first, then ask for review.

---

## Slide 15: Why Monorepo?
**Type:** content
**Content:**
- Why Monorepo?
- Single source of truth — all code, config, and docs in one place
- Atomic changes — one commit updates API + frontend + docs
- Shared tooling — one set of linting rules, CI/CD, pre-commit hooks
- Easier refactoring — rename across projects in one PR
- Consistent standards — everyone follows the same conventions

**Notes:**
A monorepo is a single repository containing multiple projects. The alternative is one repo per service, called polyrepo.
Monorepo wins for teams that need consistency. One set of rules, one CI/CD pipeline, one place to look. The tradeoff is repo size and CI complexity, but path-based triggers solve that.

---

## Slide 16: Everything as Code
**Type:** content
**Content:**
- Everything as Code
- **Documentation as Code** — Markdown files next to your source code, versioned together
- **Infrastructure as Code** — CloudFormation, SAM, Terraform in the same repo
- **Configuration as Code** — CI/CD pipelines, linter rules, deploy configs
- **Diagrams as Code** — PlantUML, Mermaid committed alongside architecture docs
- **Test Reports as Code** — test results generated from code, tracked in version control
- One commit = code + docs + infra + config, always in sync

**Notes:**
This is why Git matters more than ever. The everything-as-code movement means your documentation lives in Markdown files right next to your code. Your infrastructure is defined in YAML templates. Your CI/CD pipelines are code. Your architecture diagrams are PlantUML files.
When everything is code, everything is versioned together. You change an API endpoint, update the docs, adjust the infrastructure, and modify the CI pipeline — all in one commit. There's no drift between what's documented and what's deployed, because they're versioned together.
This is the real power of Git in modern development. It's not just version control for source code — it's version control for your entire system.

---

## Slide 17: 🛡️
**Type:** big_number
**Content:**
🛡️
Pre-commit Hooks
Local quality safeguard. Catches problems before code reaches CI/CD.
Saves CI/CD minutes (real money) and gives instant feedback (< 5 seconds).

**Notes:**
Pre-commit hooks are the unsung hero of code quality. They run automatically before every commit and catch problems instantly.
Without hooks, you commit bad code, push, wait 2-5 minutes for CI to fail, fix, push again, wait again. With hooks, you know in 5 seconds. That's the difference between a 10-second fix and a 10-minute round trip.

---

## Slide 18: What Hooks Check
**Type:** content
**Content:**
- What Pre-commit Hooks Check
- Trailing whitespace and end-of-file fixes
- YAML, JSON, TOML validation
- Large file and merge conflict detection
- **Black** — Python code formatting
- **isort** — Python import ordering
- **Ruff** — Python linting (replaces flake8 + pylint)
- **Bandit** — security scanning
- **detect-secrets** — hardcoded API keys or passwords

**Notes:**
This is the full stack of hooks we'll set up. Black and isort handle formatting automatically — you never argue about code style again. Ruff catches bugs and bad patterns. Bandit finds security issues. detect-secrets prevents you from accidentally committing API keys.
The critical rule: never bypass hooks with git commit --no-verify. If a hook fails, fix the issue. The hook exists for a reason.

---

## Slide 19: Part 2
**Type:** section
**Content:**
Part 2
Exercise: Manual Setup

**Notes:**
Now let's put theory into practice. In Part 1 of the exercise, you'll set everything up manually — GitHub account, repository, pre-commit hooks, and your first issue.

---

## Slide 20: Exercise Part 1 Steps
**Type:** content
**Content:**
- Exercise Part 1: Manual Setup
- Step 1: Create GitHub account (if needed)
- Step 2: Create public repo: `sdp-powered-by-ai-agents-name-surname`
- Step 3: Set up pre-commit hooks (Black, isort, Ruff, Bandit, detect-secrets)
- Step 4: Manually create GitHub Issue for building the Git agent

**Notes:**
This is the manual part. You do everything by hand first so you understand what the agent will automate later.
The repository name includes your name so we can find your work. The pre-commit hooks match what we use in production — same tools, same config.

---

## Slide 21: Part 3
**Type:** section
**Content:**
Part 3
Exercise: Use Your Agent

**Notes:**
Now the fun part. You'll build the Git agent and use it to automate everything you just did manually.

---

## Slide 22: Exercise Part 2 Steps
**Type:** content
**Content:**
- Exercise Part 2: Use Your Agent
- Step 1: Build the Git agent (`.kiro/agents/git-agent.json`)
- Step 2: Use agent to create issues for Modules 2–5
- Step 3: Use agent to create a feature branch
- Step 4: Create course README with progress checkboxes
- Step 5: Commit, push, create PR (all via agent)
- Step 6: Merge to main

**Notes:**
This is where you see the power of the agent. Instead of manually typing issue templates and PR descriptions, the agent does it for you — correctly, every time.
The starter config gives you the issue template. You need to add the commit convention, branch naming, and PR template yourself. That's the learning exercise.

---

## Slide 23: 🎯
**Type:** big_number
**Content:**
🎯
Key Takeaway
Learn the process first, then automate it with an AI agent.
This is the pattern for the entire course.

**Notes:**
This is the core philosophy of the course. You can't automate what you don't understand. That's why we do things manually first, then build agents to do them for us.
Next module, we'll apply the same pattern to software architecture — learn arc42 and C4, then build an agent that generates architecture documents.
