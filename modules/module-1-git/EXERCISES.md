# Module 1: Git — Exercise Checklist

## Part 1: Manual Setup (No Agent)

### Prerequisites

- [ ] Git installed (`git --version`)
- [ ] Python 3.12+ installed (`python3 --version`)
- [ ] GitHub CLI installed (`gh --version`)
- [ ] Kiro CLI installed (`kiro-cli --version`)
- [ ] GitHub account created

### Step 1: GitHub CLI Authentication

- [ ] Run `gh auth login` and complete browser auth

### Step 2: Create Course Repository

- [ ] Repository created: `sdp-powered-by-ai-agents-name-surname`
- [ ] Repository is public
- [ ] Cloned locally and `cd` into it
- [ ] Instructor added as collaborator (`momokrunic`)

### Step 3: Pre-commit Hooks

- [ ] Python virtual environment created (`.venv`)
- [ ] `pre-commit`, `black`, `isort`, `ruff`, `bandit`, `detect-secrets` installed
- [ ] `pyproject.toml` created with tool configuration
- [ ] `.pre-commit-config.yaml` created with all hooks
- [ ] `scripts/hooks/check-commit-msg.sh` created and executable
- [ ] `pre-commit install` run successfully
- [ ] `pre-commit install --hook-type commit-msg` run successfully
- [ ] `pre-commit run --all-files` passes
- [ ] Initial commit pushed: `#1 chore(setup): add pre-commit hooks and Python linter config`

### Step 4: Create Git Agent Issue

- [ ] Issue created via `gh issue create` with proper format
- [ ] Issue has `[FEAT]` prefix in title
- [ ] Issue has all sections: Description, Problem/Goal, Proposed Solution, Acceptance Criteria, Labels
- [ ] Acceptance criteria have checkboxes
- [ ] Issue number noted: #______

---

## Part 2: Use Your Agent

> **Agent:** `git-agent`
> ```bash
> kiro-cli --tui --agent git-agent
> ```

### Step 1: Build the Git Agent

- [ ] Agent config created at `.kiro/agents/git-agent.json`
- [ ] Agent can create GitHub Issues with the template
- [ ] Agent can create feature branches with correct prefix
- [ ] Agent can commit with format: `#<issue> <type>(<scope>): <description>`
- [ ] Agent can create PRs with `Closes #N` linking
- [ ] Agent tested: created a test issue and verified format on GitHub

### Step 2: Create Module Issues via Agent

- [ ] Module 2 issue created (Software Architecture agent)
- [ ] Module 3 issue created (Software Requirements agent)
- [ ] Module 4 issue created (CI/CD agent)
- [ ] Module 5 issue created (TDD/BDD multi-agent system)
- [ ] All issues have proper `[FEAT]` prefix, sections, and checkboxes
- [ ] No issue created for Module 6 (team project — separate planning)

### Step 3: Create Branch

- [ ] Feature branch created for issue #1 (e.g. `feature/git-agent`)

### Step 4: Create Course README

- [ ] `README.md` created at repo root
- [ ] Contains course title
- [ ] Contains module progress checklist with all 6 modules

### Step 5: Commit and Push

- [ ] README and agent config committed with issue reference
- [ ] Pre-commit hooks pass on commit
- [ ] Pushed to remote

### Step 6: Create Pull Request

- [ ] PR created with issue reference in title
- [ ] PR body has `Closes #1`
- [ ] PR body has Changes and Testing sections

### Step 7: Review

- [ ] Instructor added as reviewer (`gh pr edit --add-reviewer momokrunic`)
- [ ] Waited for review before merging

### Step 8: Merge

- [ ] PR approved by instructor
- [ ] Merged to main via `gh pr merge --squash`
- [ ] Issue #1 auto-closed after merge
- [ ] `main` branch has README and agent config
- [ ] Module issues #2–#5 are open and properly formatted
