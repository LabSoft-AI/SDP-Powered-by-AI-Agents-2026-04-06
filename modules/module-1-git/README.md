# Module 1: Git

## Table of Contents

- [Learning Objectives](#learning-objectives)
- [1. Theory: Git Essentials](#1-theory-git-essentials)
  - [1.1 What Is Git and Why It Matters](#11-what-is-git-and-why-it-matters)
  - [1.2 Branching Strategy](#12-branching-strategy)
  - [1.3 Short-Lived Branches and Avoiding Integration Hell](#13-short-lived-branches-and-avoiding-integration-hell)
  - [1.4 Commit Convention](#14-commit-convention)
  - [1.5 GitHub Issues](#15-github-issues)
  - [1.6 Pull Requests](#16-pull-requests)
  - [1.7 Monorepo Approach](#17-monorepo-approach)
  - [1.8 Pre-commit Hooks: Local Quality Safeguard](#18-pre-commit-hooks-local-quality-safeguard)
- [2. Exercise Part 1: Manual Setup (No Agent)](#2-exercise-part-1-manual-setup-no-agent)
- [3. Exercise Part 2: Use Your Agent](#3-exercise-part-2-use-your-agent)
- [References](#references)

## Learning Objectives

By the end of this module you will:

- Understand Git fundamentals and why version control matters
- Know how to use a branching strategy in a team setting
- Write structured commit messages that link to issues
- Create GitHub Issues and Pull Requests following a convention
- Configure pre-commit hooks as a local quality safeguard
- Build a Kiro CLI agent that automates Git operations

## 1. Theory: Git Essentials

### 1.1 What Is Git and Why It Matters

Git is a distributed version control system. Every developer has a full
copy of the repository history on their machine. This means:

- You can work offline and commit locally
- No single point of failure — if the server goes down, every clone is
  a backup
- Branching and merging are fast and cheap

**Key concepts:**

| Concept | What it is |
|---------|------------|
| Repository | A project folder tracked by Git |
| Commit | A snapshot of changes with a message |
| Branch | An independent line of development |
| Merge | Combining changes from one branch into another |
| Remote | A shared copy of the repo (e.g. on GitHub) |
| Clone | Downloading a remote repository to your machine |
| Pull | Fetching + merging remote changes into your branch |
| Push | Uploading your local commits to the remote |

### 1.2 Branching Strategy

A branching strategy defines how a team uses branches to organize work.
Without one, you get chaos — developers overwriting each other's changes,
broken main branches, and no clear path to production.

**Branch types:**

| Branch | Purpose | Deploys to |
|--------|---------|------------|
| `main` | Production-ready code | Staging (auto) |
| `feature/*` | New functionality | Development (auto) |
| `fix/*` | Bug fixes | Development (auto) |
| `hotfix/*` | Urgent production fixes | Development (auto) |
| `chore/*` | Maintenance tasks | Development (auto) |
| `v*` tags | Production releases | Production (manual) |

**Branch naming rules:**

- Lowercase with hyphens: `feature/add-login-page`
- Short but descriptive
- No issue numbers in branch names (reference issues in commits instead)

**Typical workflow:**

```text
1. Create GitHub Issue describing the work
2. Create branch from main: git checkout -b feature/my-feature
3. Make changes, commit with issue reference
4. Push branch, create Pull Request
5. Code review → approve → merge to main
6. Branch deleted, issue auto-closed
```

### 1.3 Short-Lived Branches and Avoiding Integration Hell

**Integration hell** is what happens when a branch lives too long. The
longer your branch diverges from `main`, the more conflicts pile up.
Merging becomes painful, risky, and time-consuming.

```text
Day 1:  main ──●
               └── feature/big-thing ──●

Day 10: main ──●──●──●──●──●──●──●──●──●──●
               └── feature/big-thing ──●──●──●──●──●──●──●
                                       ↑
                                       Massive merge conflict
```

**Rules for short-lived branches:**

- Aim to merge within **1–2 days**
- If a feature takes longer, break it into smaller issues
- Sync your branch with `main` daily to catch conflicts early
- Small, frequent merges are always safer than one big merge

**How to sync your feature branch with main:**

```bash
# Fetch latest changes from remote
git fetch origin

# Merge main into your feature branch
git merge origin/main
```

If there are conflicts, Git will tell you which files need attention.
Open each file, resolve the conflict markers (`<<<<<<<`, `=======`,
`>>>>>>>`), then:

```bash
# After resolving conflicts in your editor
git add <resolved-files>
git merge --continue
```

**Make this a daily habit.** If you sync every day, conflicts are small
and easy to resolve. If you wait a week, you're in integration hell.

**Why merge (not rebase) for this course:**

Merge preserves history and is safer for beginners — it doesn't rewrite
commits, so there's no risk of losing work. Rebase is a valid alternative
for experienced teams that prefer linear history, but merge is the default
recommendation for this course.

### 1.4 Commit Convention

Commits are the atomic unit of your project history. A good commit message
tells the team what changed and why — without reading the code.

We use **Conventional Commits** with GitHub Issue references:

```text
#<issue-number> <type>(<scope>): <description>

[optional body]
```

**Types:**

| Type | When to use | Example |
|------|-------------|---------|
| `feat` | New feature | `#42 feat(auth): add login endpoint` |
| `fix` | Bug fix | `#23 fix(api): handle null email` |
| `docs` | Documentation | `#80 docs(readme): update setup guide` |
| `test` | Adding tests | `#44 test(auth): add login tests` |
| `refactor` | Code restructuring | `#33 refactor(db): simplify queries` |
| `chore` | Maintenance | `#12 chore(deps): update dependencies` |
| `ci` | CI/CD changes | `#56 ci(deploy): add staging workflow` |

**Rules:**

- Scope is mandatory and lowercase
- Subject line is imperative mood ("add", not "added")
- Reference the GitHub issue number at the start
- Use `Closes #N` in the body to auto-close issues on merge

**Good vs bad:**

```bash
# Bad — no issue, no type, no scope, vague
git commit -m "fix stuff"

# Good — traceable, typed, scoped, descriptive
git commit -m "#42 feat(auth): add OAuth2 login endpoint"
```

### 1.5 GitHub Issues

Issues are how you plan and track work. Every piece of work — feature,
bug, documentation — starts with an issue.

**Issue format:**

```markdown
[TYPE] Brief descriptive title

## 📋 Description
What needs to be done.

## 🎯 Problem/Goal
Why this matters.

## 💡 Proposed Solution
How to approach it.

## ✅ Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## 🏷️ Labels
- Type: enhancement
- Component: backend
- Priority: priority/high
```

**Type prefixes:** `[FEAT]`, `[BUG]`, `[DOCS]`, `[INFRA]`, `[QUESTION]`

The acceptance criteria checkboxes serve as a **Definition of Done** — the
issue is complete only when all boxes are checked.

### 1.6 Pull Requests

A Pull Request (PR) is a request to merge your branch into `main`. It is
the place where code review happens.

**PR format:**

```markdown
#<issue-number> [TYPE] Brief descriptive title

## Related Issue
Closes #<issue-number>

## Changes
- Change 1
- Change 2

## Testing
- [ ] Tested locally
- [ ] Tests pass
- [ ] Pre-commit hooks pass
```

**Rules:**

- Keep PRs small and focused (one feature or fix)
- Link to the issue with `Closes #N`
- Only add reviewers after CI/CD checks pass
- Never force-push during review

### 1.7 Monorepo Approach

A **monorepo** is a single repository containing multiple projects,
services, and configurations. The alternative is **polyrepo** — one
repository per service.

**Why monorepo?**

| Benefit | Explanation |
|---------|-------------|
| Single source of truth | All code, config, and docs in one place |
| Atomic changes | A single commit can update API + frontend + docs |
| Shared tooling | One set of linting rules, CI/CD, pre-commit hooks |
| Easier refactoring | Rename across projects in one PR |
| Consistent standards | Everyone follows the same conventions |
| Simplified onboarding | Clone one repo, get everything |

**Challenges and mitigations:**

| Challenge | Mitigation |
|-----------|------------|
| Repo size grows | Use sparse checkout, path-based CI triggers |
| CI/CD complexity | Path filters in GitHub Actions — only build what changed |
| Permission granularity | Use CODEOWNERS file for per-directory review rules |
| Build times | Incremental builds, caching, parallel jobs |

**Path-based CI example:**

```yaml
on:
  push:
    paths:
      - 'ap/products/my-service/**'
```

This means the workflow only runs when files in `my-service/` change —
other teams' pushes don't trigger your pipeline.

### 1.8 Pre-commit Hooks: Local Quality Safeguard

Pre-commit hooks run automatically before every `git commit`. They catch
problems locally, before code reaches CI/CD.

**Why this matters:**

```text
Without hooks:
  Developer commits bad code → pushes → CI fails (2-5 min wasted)
  → fixes → pushes again → CI runs again (2-5 min wasted)
  → repeat until green

With hooks:
  Developer commits → hook catches issue instantly (< 5 sec)
  → fixes → commits → pushes → CI passes first time
```

Pre-commit hooks save CI/CD minutes, which cost real money on hosted
runners. More importantly, they give instant feedback — you know
something is wrong before you even push.

**What hooks typically check:**

| Hook | What it catches |
|------|-----------------|
| Trailing whitespace | Unnecessary whitespace at end of lines |
| End-of-file fixer | Missing newline at end of file |
| YAML/JSON validation | Syntax errors in config files |
| Large file check | Accidentally committed binaries or data files |
| Merge conflict markers | Leftover `<<<<<<<` markers |
| Black (Python) | Code formatting violations |
| isort (Python) | Import order violations |
| Ruff (Python) | Linting errors (fast replacement for flake8) |
| Commit message format | Enforces conventional commit format |
| Secret detection | Hardcoded API keys or passwords |

**Setup:**

```bash
# Install pre-commit
pip install pre-commit

# Install hooks into your repo
pre-commit install

# Also install commit message validation
pre-commit install --hook-type commit-msg

# Test all hooks against entire codebase
pre-commit run --all-files
```

**Configuration** lives in `.pre-commit-config.yaml` at the repo root:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-added-large-files
      - id: check-merge-conflict

  - repo: https://github.com/psf/black
    rev: 24.1.1
    hooks:
      - id: black

  - repo: https://github.com/pycqa/isort
    rev: 5.13.2
    hooks:
      - id: isort

  - repo: local
    hooks:
      - id: commit-msg-format
        name: Commit message format
        entry: scripts/check-commit-msg.sh
        language: system
        stages: [commit-msg]
```

**Critical rule:** Never bypass hooks with `git commit --no-verify`. If a
hook fails, fix the issue. The hook exists for a reason.

---

## 2. Exercise Part 1: Manual Setup (No Agent)

### Goal

Set up your course repository manually, configure pre-commit hooks, and
create a GitHub Issue for building your first Kiro CLI agent.

### Prerequisites

- **Git** installed (`git --version`)
- **Python 3.12+** installed (`python3 --version`)
- **GitHub CLI** (`gh`) installed:

  ```bash
  # Install (macOS)
  brew install gh

  # Install (Ubuntu/Debian)
  sudo apt install gh
  ```

- **Kiro CLI** installed — see https://kiro.dev

### Step 1: Create a GitHub Account

If you don't have one, create an account at https://github.com/signup.

Then authenticate the GitHub CLI:

```bash
gh auth login
```

### Step 2: Create Your Course Repository

Create a public repository that you'll use for all course exercises:

```bash
gh repo create sdp-powered-by-ai-agents-name-surname --public --clone
cd sdp-powered-by-ai-agents-name-surname
```

Replace `name-surname` with your actual name (e.g.
`sdp-powered-by-ai-agents-marko-petrovic`).

**Invite the instructor as a collaborator:**

```bash
gh api repos/{owner}/{repo}/collaborators/momokrunic --method PUT -f permission=push
```

Replace `{owner}` with your GitHub username and `{repo}` with your
repository name. The instructor needs access to review your PRs.

### Step 3: Set Up Pre-commit Hooks

Initialize Python project and pre-commit hooks:

```bash
# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install pre-commit and Python linters
pip install pre-commit black isort ruff bandit detect-secrets
```

Create `pyproject.toml`:

```bash
cat > pyproject.toml << 'EOF'
[project]
name = "sdp-course"
version = "0.1.0"
requires-python = ">=3.12"

[tool.black]
line-length = 88
target-version = ['py312']

[tool.isort]
profile = "black"
line_length = 88

[tool.ruff]
line-length = 88
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "W", "I", "N", "UP", "B", "SIM"]
EOF
```

Create `.pre-commit-config.yaml`:

```bash
cat > .pre-commit-config.yaml << 'EOF'
repos:
  # General file checks
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-toml
      - id: check-added-large-files
      - id: check-merge-conflict

  # Python formatting
  - repo: https://github.com/psf/black
    rev: 25.1.0
    hooks:
      - id: black

  # Python import sorting
  - repo: https://github.com/pycqa/isort
    rev: 6.0.1
    hooks:
      - id: isort

  # Python linting
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.11.4
    hooks:
      - id: ruff
        args: [--fix]

  # Security scanning
  - repo: https://github.com/PyCQA/bandit
    rev: 1.8.3
    hooks:
      - id: bandit
        args: [-c, pyproject.toml]
        additional_dependencies: ["bandit[toml]"]

  # Secret detection
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.5.0
    hooks:
      - id: detect-secrets

  # Commit message format
  - repo: local
    hooks:
      - id: commit-msg-format
        name: Commit message format
        entry: scripts/check-commit-msg.sh
        language: system
        stages: [commit-msg]
        always_run: true
EOF
```

Create the commit message validation script:

```bash
mkdir -p scripts
cat > scripts/check-commit-msg.sh << 'SCRIPT'
#!/usr/bin/env bash
# Validates conventional commit format: #<issue> <type>(<scope>): <description>
# or: <type>(<scope>): <description> (for initial setup commits)

MSG_FILE="$1"
MSG=$(head -1 "$MSG_FILE")

# Allow merge and revert commits
if echo "$MSG" | grep -qE "^(Merge|Revert) "; then
    exit 0
fi

# Match: #N type(scope): description
if echo "$MSG" | grep -qE "^#[0-9]+ (feat|fix|docs|test|refactor|chore|ci|perf|style)\([a-z0-9-]+\): .+$"; then
    exit 0
fi

echo "❌ Invalid commit message format."
echo "   Expected: #<issue> <type>(<scope>): <description>"
echo "   Example:  #1 feat(auth): add login endpoint"
echo "   Types: feat, fix, docs, test, refactor, chore, ci, perf, style"
exit 1
SCRIPT
chmod +x scripts/check-commit-msg.sh
```

Install hooks and make the initial commit:

```bash
pre-commit install
pre-commit install --hook-type commit-msg
pre-commit run --all-files

git add pyproject.toml .pre-commit-config.yaml scripts/
git commit -m "#1 chore(setup): add pre-commit hooks and Python linter config"
git push
```

Note: You'll create issue `#1` in Step 4 below, but GitHub lets you
reference issue numbers in commits before the issue exists. The link
resolves once the issue is created.

### Step 4: Create a GitHub Issue for the Git Agent (Manually)

This is the one issue you create by hand. It follows the issue template
convention and defines the acceptance criteria for building your Git
workflow agent.

```bash
gh issue create \
  --title "[FEAT] Build Kiro CLI agent for Git workflow automation" \
  --body "## 📋 Description
Build a Kiro CLI agent that automates Git workflow operations: creating
GitHub Issues, commits, and Pull Requests using predefined templates.

## 🎯 Problem/Goal
Manually creating issues and PRs with the correct format is repetitive
and error-prone. An agent should enforce the conventions automatically.

## 💡 Proposed Solution
Create a Kiro CLI agent (\`.kiro/agents/git-agent.json\`) that:
- Creates GitHub Issues using \`gh\` CLI with a predefined template
- Creates feature branches with proper naming
- Creates Pull Requests using \`gh\` CLI with a predefined template
- Follows conventional commit format

## ✅ Acceptance Criteria
- [ ] Agent config exists at \`.kiro/agents/git-agent.json\`
- [ ] Agent creates issues with \`[TYPE]\` prefix and all sections (Description, Problem/Goal, Proposed Solution, Acceptance Criteria, Labels)
- [ ] Issues include Acceptance Criteria with checkboxes (Definition of Done)
- [ ] Agent creates branches with correct prefix (\`feature/\`, \`fix/\`, etc.)
- [ ] Agent commits with format: \`#<issue> <type>(<scope>): <description>\`
- [ ] Agent creates PRs with \`Closes #N\` linking to the issue
- [ ] PR includes Related Issue, Changes, and Testing sections
- [ ] Agent uses \`gh\` CLI for all GitHub operations

## 🏷️ Labels
- Type: enhancement
- Component: tooling
- Priority: priority/high"
```

Note the issue number (e.g. `#1`). You'll use this in Part 2.

---

## 3. Exercise Part 2: Use Your Agent

### Goal

Build the Git agent from Part 1, then use it to create issues for all
remaining course modules, set up a README, and go through the full
Git workflow — all driven by the agent.

### Step 1: Build the Git Agent

Create `.kiro/agents/git-agent.json` — this is the agent you defined
in the issue from Part 1. See
[starter/git-agent.json](starter/git-agent.json) for a starter template.

The agent must be able to:

- Create GitHub Issues with the predefined template
- Create feature branches
- Commit with conventional format
- Create Pull Requests with the predefined template

Test it:

```bash
kiro chat --agent git-agent

# Verify it can create a properly formatted issue
> Create a test issue for adding a hello world script
```

Check the created issue on GitHub — it should have all sections and
checkboxes.

### Step 2: Create Issues for All Course Modules

Use your agent to create one GitHub Issue per module exercise:

```bash
kiro chat --agent git-agent

> Create issues for the following course module exercises:
>
> 1. Module 2: Build a Software Architecture agent (arc42, C4 diagrams)
> 2. Module 3: Build a Software Requirements agent (user stories, DDD, Pareto)
> 3. Module 4: Build a CI/CD agent (GitHub Actions, SAM deploy)
> 4. Module 5: Build a TDD/BDD multi-agent system (test writer, executor, implementer, refactorer)
```

Each issue should follow the template with proper acceptance criteria.
Do **not** create an issue for Module 6 (FitTrack) — that's a team
exercise that needs separate planning.

### Step 3: Create a Branch for the README

```bash
> Create a feature branch for issue #1
```

### Step 4: Create the Course README

Create `README.md` at the repo root with:

- Course title: "Software Development Processes Powered by AI Agents"
- Brief description of what you'll build
- Checkbox list of all modules:

```markdown
# Software Development Processes Powered by AI Agents

## Course Progress

- [ ] Module 1: Git — workflow agent
- [ ] Module 2: Software Architecture — arc42 design agent
- [ ] Module 3: Software Requirements — user story derivation agent
- [ ] Module 4: CI/CD — deployment pipeline agent
- [ ] Module 5: TDD/BDD — multi-agent test system
- [ ] Module 6: FitTrack — team project using all agents
```

### Step 5: Commit and Push

```bash
> Commit the README and the agent config, referencing issue #1
> Push to remote
```

### Step 6: Create a Pull Request

```bash
> Create a pull request for the current branch, closing issue #1
```

Verify the PR has:

- Title with issue reference and `[TYPE]` prefix
- `Closes #1` in the body
- Changes and Testing sections

### Step 7: Add Instructor as Reviewer

After the PR is created and all pre-commit hooks pass:

```bash
gh pr edit --add-reviewer momokrunic
```

Wait for the review before merging. This applies to every module — always
add the instructor as reviewer on your PR.

### Step 8: Merge to Main

After the instructor approves:

```bash
gh pr merge --squash
```

After merge, verify:

- Issue `#1` is automatically closed
- `main` branch has the README and agent config
- All module issues (`#2` through `#5`) are open and properly formatted

---

## References

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Pre-commit Framework](https://pre-commit.com/)
- [GitHub CLI Manual](https://cli.github.com/manual/)
- [Kiro CLI](https://kiro.dev)
