# Module 4: CI/CD — Exercise Checklist

## Part 1: Understand CI/CD Pipelines

### Step 1: Write a Dockerfile

- [ ] Created `Dockerfile` in kata root
- [ ] Base image matches kata language
- [ ] Dependencies installed before source copy (layer caching)
- [ ] Source code and tests copied
- [ ] Default CMD runs the test suite
- [ ] Local build succeeds: `docker build -t my-kata .`
- [ ] Local test run succeeds: `docker run --rm my-kata`

### Step 2: Write a GitHub Actions Workflow

> ⏳ **Note:** Steps 2 and 3 can only be fully verified after Module 5 (TDD/BDD), when you have actual implementation and test code that triggers the CI pipeline.

- [ ] Created `.github/workflows/ci.yml`
- [ ] Triggers on push to `main` and `feature/**`
- [ ] Triggers on pull_request to `main`
- [ ] Permissions set to `contents: read`
- [ ] Builds Docker image
- [ ] Runs tests inside Docker container

### Step 3: Verify the Pipeline

- [ ] Pushed to feature branch
- [ ] GitHub Actions workflow triggered
- [ ] Docker image built successfully
- [ ] Tests ran and results visible in Actions tab
- [ ] PR shows ✅ or ❌ status check

---

## Part 2: Build and Use the CI/CD Agent

> **Agent:** `cicd-agent`
> ```bash
> kiro-cli --tui --agent cicd-agent
> ```

### Step 1: Build the CI/CD Agent

- [ ] Agent config created at `.kiro/agents/cicd-agent.json`
- [ ] Agent detects kata language and build system
- [ ] Agent generates a working Dockerfile
- [ ] Agent generates `.github/workflows/ci.yml`
- [ ] Agent uses pinned action versions
- [ ] Agent sets minimal permissions
- [ ] Agent uses path filtering

### Step 2: Generate Pipeline Files

- [ ] Started agent: `kiro-cli --tui --agent cicd-agent`
- [ ] Agent read project structure
- [ ] Dockerfile generated and approved
- [ ] CI workflow generated and approved

### Step 3: Test Locally

> ⏳ **Note:** Steps 3 and 4 can only be fully verified after Module 5 (TDD/BDD), when you have actual implementation and test code that triggers the CI pipeline.

- [ ] `docker build -t kata-tests .` succeeds
- [ ] `docker run --rm kata-tests` runs tests and passes
- [ ] Copied `scripts/hooks/docker-test.sh` to your repo and added the `docker-test` hook to `.pre-commit-config.yaml`
- [ ] Made a test commit — pre-commit hook builds image and runs tests automatically

### Step 4: Push and Verify

- [ ] Pushed to feature branch
- [ ] GitHub Actions triggered
- [ ] Docker build succeeded in pipeline
- [ ] Tests passed inside container
- [ ] PR shows ✅ status check

### Step 5: Commit via Git Agent

> **Switch agent:** `git-agent`
> ```bash
> kiro-cli --tui --agent git-agent
> ```

- [ ] Feature branch created for CI/CD issue
- [ ] Dockerfile and workflow committed with issue reference
- [ ] PR title **must** include `Module 4` (e.g. `#5 [FEAT] Module 4: CI/CD pipeline with Docker`)
- [ ] PR created closing the CI/CD issue

### Step 6: Review and Merge

- [ ] Instructor added as reviewer (`gh pr edit --add-reviewer momokrunic`)
- [ ] PR approved by instructor
- [ ] Merged to main via `gh pr merge --squash`
- [ ] CI/CD issue auto-closed
