# Module 4: CI/CD

## Slide 1: Module 4: CI/CD
**Type:** title
**Content:**
Module 4: CI/CD
Software Development Processes Powered by AI Agents

**Notes:**
Welcome to Module 4. Today we cover CI/CD — the automated quality gate that verifies every change before it reaches main.
By the end of this module you'll understand GitHub Actions, Docker, and pipeline design — and you'll build a Kiro CLI agent that generates CI/CD pipelines for your kata.

---

## Slide 2: The Story of 160,000 CI Jobs Per Day
**Type:** storytelling
**Content:**
In 2018, at BMW Munich, I worked on a platform with 500 million lines of code and over 2,000 developers. Every push triggered a CI pipeline. Every day, 160,000 CI jobs ran across the platform. That sounds like overhead — until you realize it was the only thing preventing chaos. Without those pipelines, a single developer's mistake could break the entire platform. With them, broken code was caught in minutes, not days. CI wasn't a luxury. It was the safety net that made collaboration at scale possible.

**Notes:**
This connects back to Story 1 from the TDD course. The BMW platform had 500 million lines of code. At that scale, manual testing is impossible. You can't ask 2,000 developers to manually run tests before every push.
CI pipelines automated that verification. Every push, every branch, every pull request — automatically built and tested. 160,000 times a day. That's not overhead. That's the cost of moving fast without breaking things.
The lesson: CI is not optional in professional software development. It's the foundation that everything else — code review, deployment, release management — depends on.

---

## Slide 3: What You'll Learn
**Type:** content
**Content:**
- What You'll Learn
- Understand CI, CD, and continuous deployment — and the differences
- Know how GitHub Actions workflows, jobs, and steps work
- Write a Dockerfile that builds and tests your kata
- Design a pipeline: Build Docker image → Run tests → Report results
- Understand OIDC federation for keyless AWS deployments
- Build a Kiro CLI agent that generates CI/CD pipelines

**Notes:**
These are our learning objectives. The key deliverable is a working CI pipeline for your kata — a Dockerfile that builds and tests your code, and a GitHub Actions workflow that runs it on every push.
The OIDC section is theory prep for Module 6 when you deploy to AWS. For this module, you focus on build and test only.

---

## Slide 4: Part 1
**Type:** section
**Content:**
Part 1
Theory: Continuous Integration

**Notes:**
Let's start with the fundamentals. What is CI, why does it matter, and how does it connect to everything we've built so far?

---

## Slide 5: Why CI/CD?
**Type:** content
**Content:**
- Why CI/CD?
- Module 1: Git branching and PRs — *how* to collaborate
- Module 2: Architecture — *what* to build
- Module 3: Requirements — *what to build first* and *how to verify*
- Module 4: CI/CD — **automatically verify every change works**
- The pipeline is the bridge between "code written" and "code trusted"

**Notes:**
Each module builds on the previous ones. Git gives you collaboration. Architecture gives you design. Requirements give you testable stories. CI/CD gives you automated verification.
Without CI/CD, you're trusting humans to remember to run tests. Humans forget. Humans skip steps when they're in a hurry. The pipeline never forgets. It runs the same checks, every time, consistently.

---

## Slide 6: Without CI vs With CI
**Type:** code
**Content:**
```text
Without CI:
  Developer: "It works on my machine"
  Reviewer:  "Did you run the tests?"
  Developer: "...most of them"
  → Broken main, manual testing, slow feedback

With CI:
  Developer pushes to feature branch
  → GitHub Actions builds Docker image
  → Tests run automatically inside container
  → PR shows ✅ or ❌ before anyone reviews
  → Merge only when green
```

**Notes:**
This is the fundamental shift. Without CI, quality depends on developer discipline. With CI, quality is enforced by automation.
The PR status check is the key. Before a reviewer even looks at the code, they can see whether the tests pass. If the check is red, there's no point reviewing — the code is broken.

---

## Slide 7: The CI Contract
**Type:** content
**Content:**
- The CI Contract
- Every push triggers a build
- Every build runs the full test suite
- A broken build is the team's **top priority** to fix
- The `main` branch is always in a deployable state
- If CI is red, stop and fix it before doing anything else

**Notes:**
This is a social contract, not just a technical one. The team agrees: if CI breaks, we fix it immediately. No new features, no new PRs — fix the build first.
Why? Because a broken main branch blocks everyone. If main is broken, no one can merge, no one can deploy, no one can trust the codebase. Fixing CI is always the highest priority.

---

## Slide 8: ⚠️
**Type:** big_number
**Content:**
⚠️
Integration Hell (Revisited)
In Module 1 we talked about long-lived branches causing merge conflicts.
CI adds another dimension: the longer you wait to integrate, the more likely your code breaks against everyone else's changes.
Push early. Push often. Let CI catch problems while they're small.

**Notes:**
This connects directly to Module 1's lesson about short-lived branches. CI amplifies the benefit of frequent integration. When you push daily, CI catches conflicts and regressions immediately — while the context is fresh in your mind.
When you push after two weeks, CI might show 47 test failures. Good luck figuring out which of your 200 changes caused them.

---

## Slide 9: CI vs CD vs Continuous Deployment
**Type:** content
**Content:**
- CI vs CD vs Continuous Deployment
  - **Continuous Integration** — every push is built and tested automatically
  - **Continuous Delivery** — every green build *could* be deployed (manual trigger)
  - **Continuous Deployment** — every green build *is* deployed automatically
- In this course: **Continuous Delivery**
- Push → Build → Test → [Deploy to Staging] → Manual approval → Deploy to Prod

**Notes:**
These three terms are often confused. CI is about building and testing. Continuous Delivery means the artifact is always ready to deploy, but a human decides when. Continuous Deployment removes the human — every green build goes straight to production.
For this course, we practice Continuous Delivery. The pipeline builds, tests, and prepares a deployment. But you or the instructor decides when to actually deploy. This is the safest approach for learning.

---

## Slide 10: Part 2
**Type:** section
**Content:**
Part 2
GitHub Actions

**Notes:**
Now let's look at the tool we'll use for CI: GitHub Actions. It's built into GitHub, free for public repos, and powerful enough for production workloads.

---

## Slide 11: GitHub Actions Concepts
**Type:** content
**Content:**
- GitHub Actions Concepts
  - **Workflow** — YAML file in `.github/workflows/` that defines automation
  - **Event** — what triggers it: `push`, `pull_request`, `workflow_dispatch`
  - **Job** — a set of steps running on the same runner
  - **Step** — a single task: shell command (`run:`) or action (`uses:`)
  - **Runner** — the machine executing the job (`ubuntu-latest`)
  - **Action** — reusable unit of code (`actions/checkout@v4`)

**Notes:**
These are the building blocks. A workflow is a YAML file. It's triggered by events. It contains jobs. Jobs contain steps. Steps run on runners.
The key insight: everything is declarative. You describe what you want, and GitHub Actions figures out how to run it. You don't manage servers, you don't install CI software — it's all built into GitHub.

---

## Slide 12: Anatomy of a Workflow
**Type:** code
**Content:**
```yaml
name: CI                          # Workflow name

on:                               # Trigger events
  push:
    branches: [main, 'feature/**']
  pull_request:
    branches: [main]

permissions:                      # Least privilege
  contents: read

jobs:                             # One or more jobs
  build-and-test:                 # Job ID
    runs-on: ubuntu-latest        # Runner
    steps:                        # Ordered list
      - uses: actions/checkout@v4 # Checkout code
      - run: echo "Hello CI"      # Shell command
```

**Notes:**
This is the skeleton of every workflow. The name is displayed in the GitHub UI. The on block defines triggers. Permissions follow least privilege — only grant what's needed. Jobs define the work. Steps are executed in order.
Notice the pinned version on actions/checkout@v4. Always pin versions. Using @latest means your pipeline could break when the action updates.

---

## Slide 13: Path Filtering
**Type:** code
**Content:**
```yaml
on:
  push:
    paths:
      - 'src/**'
      - 'tests/**'
      - 'Dockerfile'
      - '.github/workflows/ci.yml'
```

**Notes:**
Path filtering is a best practice. Without it, every push triggers the pipeline — even when you only edited the README. With path filtering, the pipeline only runs when relevant files change.
This saves CI minutes and reduces noise. Your pipeline should only run when code that affects the build or tests changes.

---

## Slide 14: Part 3
**Type:** section
**Content:**
Part 3
Docker in CI/CD

**Notes:**
Docker solves the most common CI problem: environment inconsistency. Let's see how.

---

## Slide 15: "Works on My Machine"
**Type:** quote
**Content:**
It works on my machine.
— Every developer, at some point

**Notes:**
This is the classic problem. Code works locally because you have specific versions of Python, specific libraries, specific OS settings. But CI runs on a fresh Ubuntu machine with nothing installed.
Docker solves this by packaging your code with its entire environment. The same image runs locally and in CI — identical results, every time.

---

## Slide 16: Why Docker in CI?
**Type:** content
**Content:**
- Why Docker in CI?
- **Reproducibility** — same image, same results, everywhere
- **Isolation** — dependencies don't leak between projects
- **Speed** — cached layers make rebuilds fast
- **Portability** — the image runs on any Docker host
- One Dockerfile replaces pages of "install these dependencies" docs

**Notes:**
Without Docker, your CI workflow needs to install every dependency from scratch. Different projects need different Python versions, different libraries, different system packages. It's fragile and slow.
With Docker, you build an image once. That image contains everything. The CI workflow just builds and runs the image. Simple, fast, reliable.

---

## Slide 17: Dockerfile for a Python Kata
**Type:** code
**Content:**
```dockerfile
FROM python:3.12-slim

WORKDIR /app

# Dependencies first (cached layer)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Source code (changes frequently)
COPY src/ src/
COPY tests/ tests/

# Default: run tests
CMD ["pytest", "tests/", "-v", "--tb=short"]
```

**Notes:**
Notice the layer ordering. We copy requirements.txt first and install dependencies. This layer is cached — it only rebuilds when requirements.txt changes. Then we copy the source code, which changes frequently.
This means most builds only rebuild the last two layers. The dependency installation is cached. This can save minutes on every build.
The CMD runs pytest by default. When CI does docker run, it automatically runs the tests.

---

## Slide 18: Dockerfile for a C++ Kata
**Type:** code
**Content:**
```dockerfile
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential cmake git ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/google/googletest.git && \
    cd googletest && mkdir build && cd build && \
    cmake .. && cmake --build . --target install

WORKDIR /app
COPY . .

RUN mkdir -p build && cd build && cmake .. && cmake --build .
CMD ["./build/run_tests"]
```

**Notes:**
This is adapted from the TDD course's devcontainer Dockerfile. It installs build tools, clones and builds GoogleTest, then builds the project.
For C++ projects, the build step is part of the Dockerfile because compilation is required before tests can run. The CMD runs the compiled test binary.

---

## Slide 19: 📦
**Type:** big_number
**Content:**
📦
Dockerfile = Environment as Code
Your Dockerfile is the single source of truth for your build environment.
No more "install these 12 things manually" — just `docker build`.

**Notes:**
This is a key mindset shift. The Dockerfile is not just a CI artifact — it's documentation. It tells anyone exactly what's needed to build and test the project.
New team member? docker build, docker run. Done. No setup guide, no "ask Bob how to configure the environment."

---

## Slide 20: Part 4
**Type:** section
**Content:**
Part 4
Pipeline Design

**Notes:**
Now let's put it all together: Docker + GitHub Actions = a complete CI pipeline.

---

## Slide 21: The Pipeline
**Type:** content
**Content:**
- Pipeline Stages
  - **Build** — build the Docker image from your Dockerfile
  - **Test** — run tests inside the Docker container
  - **Report** — show results in the PR (✅ or ❌)
- For your kata, that's all you need
- Module 6 adds: Deploy to AWS with SAM

**Notes:**
Keep it simple. For your kata, the pipeline has three stages: build the image, run the tests, report the result. That's it.
You don't need deployment for Module 4. You don't need code coverage. You don't need artifact uploads. Start with the minimum viable pipeline and add complexity only when needed.

---

## Slide 22: The Complete Kata Pipeline
**Type:** code
**Content:**
```yaml
name: CI

on:
  push:
    branches: [main, 'feature/**', 'fix/**']
  pull_request:
    branches: [main]

permissions:
  contents: read

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build Docker image
        run: docker build -t kata-tests .

      - name: Run tests
        run: docker run --rm kata-tests
```

**Notes:**
Three steps. Checkout, build, run. The Dockerfile encapsulates all the build logic and dependencies. The workflow just builds and runs it.
This is the power of Docker in CI. Your workflow is simple and generic. All the complexity lives in the Dockerfile, which you can test locally before pushing.

---

## Slide 23: 3
**Type:** big_number
**Content:**
3
Three Steps
Checkout. Build. Run.
The Dockerfile handles the rest.

**Notes:**
Simplicity is a feature. A three-step pipeline is easy to understand, easy to debug, and easy to maintain. When something breaks, there are only three places to look.
Compare this to a pipeline that installs dependencies inline, runs linters, builds artifacts, uploads to S3, and deploys to three environments. That's Module 6 territory. For now, keep it simple.

---

## Slide 24: Test Locally First
**Type:** code
**Content:**
```bash
# Build the image
docker build -t kata-tests .

# Run the tests
docker run --rm kata-tests

# If tests pass locally, they'll pass in CI
# If they fail locally, fix before pushing
```

**Notes:**
Always test locally before pushing. The Docker image is identical locally and in CI. If it works on your machine inside Docker, it works in GitHub Actions.
This is the Docker guarantee: same image, same results, everywhere. No more "it works on my machine but fails in CI."

---

## Slide 25: Part 5
**Type:** section
**Content:**
Part 5
OIDC and AWS Deployment (Theory)

**Notes:**
This section is theory prep for Module 6. You don't need OIDC for your kata pipeline, but understanding it now will save time later.

---

## Slide 26: No Secrets in the Repo
**Type:** content
**Content:**
- OIDC Federation: No Secrets in the Repo
- Traditional approach: store AWS keys in GitHub Secrets (risky)
- OIDC approach: GitHub proves its identity to AWS, gets temporary credentials
- No long-lived keys anywhere — not in the repo, not in GitHub Secrets
- Used in Module 6 for deploying to AWS

**Notes:**
OIDC stands for OpenID Connect. It's a protocol that lets GitHub Actions prove to AWS that it's really running your workflow, without storing any AWS credentials.
The traditional approach — storing AWS access keys in GitHub Secrets — is risky. Keys can leak, they don't expire automatically, and they grant broad access. OIDC eliminates all of these problems.

---

## Slide 27: OIDC Flow
**Type:** code
**Content:**
```yaml
permissions:
  id-token: write   # Required for OIDC
  contents: read

steps:
  - uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-assume: arn:aws:iam::954728790990:role/GitHubActions-Course
      aws-region: eu-central-1
```

**Notes:**
The id-token write permission lets GitHub Actions request an OIDC token. The configure-aws-credentials action sends that token to AWS STS, which verifies it and returns temporary credentials.
These credentials last only for the duration of the workflow run. No long-lived keys, no secrets to rotate, no risk of credential leakage.
You'll use this exact configuration in Module 6 when deploying the Subscription Platform.

---

## Slide 28: Part 6
**Type:** section
**Content:**
Part 6
CI/CD as a Harness Sensor

**Notes:**
Let's connect CI/CD back to the course's core concepts: context engineering and harness engineering.

---

## Slide 29: Pipeline = Harness Sensor
**Type:** content
**Content:**
- CI/CD in the Harness Model
  - **Guide** (feedforward) — branch protection rules, required checks
  - **Sensor** (feedback) — test results, build status
  - **Actuator** (action) — block merge on failure, auto-deploy on success
- The pipeline is the most powerful sensor in your development process
- It runs automatically, consistently, on every change

**Notes:**
Remember from the intro: a harness has guides and sensors. Your CI pipeline is the ultimate sensor. It observes every change and reports whether it's safe to merge.
Branch protection rules are the guide — they require the CI check to pass before merging. The pipeline itself is the sensor — it runs tests and reports results. The merge block is the actuator — it prevents broken code from reaching main.

---

## Slide 30: Branch Protection
**Type:** code
**Content:**
```text
main branch rules:
  ✅ Require status checks to pass (CI must be green)
  ✅ Require PR reviews (at least 1 approval)
  ✅ No direct pushes to main

Result:
  No code reaches main without:
  1. Passing the CI pipeline
  2. Getting a human review
```

**Notes:**
This is the complete quality gate. Automated checks plus human review. Neither alone is sufficient — CI catches technical issues, reviewers catch design issues.
You should enable these rules on your kata repository. Go to Settings → Branches → Add rule → check "Require status checks" and "Require pull request reviews."

---

## Slide 31: 🔗
**Type:** big_number
**Content:**
🔗
Pipeline = Automated Quality Gate
No human has to remember to run tests.
The pipeline does it for you, every time, consistently.

**Notes:**
This is the key takeaway from the theory section. CI removes human error from the verification process. You still need humans for design decisions and code review. But for "does it compile? do the tests pass?" — let the machine handle it.

---

## Slide 32: Part 7
**Type:** section
**Content:**
Part 7
Exercise: Build the CI/CD Agent

**Notes:**
Now it's your turn. You'll build a Kiro CLI agent that generates Dockerfiles and GitHub Actions workflows for your kata.

---

## Slide 33: Exercise Overview
**Type:** content
**Content:**
- Exercise Overview
- **Part 1:** Manually write a Dockerfile and CI workflow for your kata
- **Part 2:** Build a `cicd-agent` that automates pipeline generation
- **Deliverables:**
  - `Dockerfile` — builds and tests your kata
  - `.github/workflows/ci.yml` — GitHub Actions pipeline
  - `.kiro/agents/cicd-agent.json` — the agent config

**Notes:**
Same pattern as previous modules: understand manually first, then automate with an agent.
Part 1 ensures you understand what a Dockerfile and workflow do. Part 2 has you build an agent that generates them automatically for any kata.

---

## Slide 34: Part 1: Manual Pipeline
**Type:** content
**Content:**
- Part 1: Write It Manually
- Step 1: Write a `Dockerfile` for your kata
  - Base image, dependencies, source copy, test CMD
- Step 2: Write `.github/workflows/ci.yml`
  - Triggers, permissions, Docker build + run
- Step 3: Test locally with `docker build` and `docker run`
- Step 4: Push and verify on GitHub Actions

**Notes:**
Start by writing both files by hand. This forces you to understand every line. What base image do you need? What dependencies? How are tests executed?
Test locally first. If docker build and docker run work on your machine, they'll work in CI. Only push when you're confident it works.

---

## Slide 35: Part 2: The CI/CD Agent
**Type:** content
**Content:**
- Part 2: Build the CI/CD Agent
- Create `.kiro/agents/cicd-agent.json` from the starter template
- The agent must:
  - Detect kata language and build system
  - Generate a working Dockerfile
  - Generate `.github/workflows/ci.yml`
  - Use pinned action versions and minimal permissions
- Fill in the TODO sections in the starter

**Notes:**
The starter template has four TODO sections you must complete: Dockerfile templates per language, the GitHub Actions workflow template, path filtering rules, and a Docker build verification step.
The agent should be able to read any kata project and generate the right pipeline. It detects the language from project files — requirements.txt means Python, CMakeLists.txt means C++, package.json means Node.js.

---

## Slide 36: Using the Agent
**Type:** code
**Content:**
```bash
# Start the CI/CD agent
kiro-cli --tui --agent cicd-agent

> Read my kata project structure
> Generate a Dockerfile for building and testing
> Generate a GitHub Actions CI workflow

# Test locally
docker build -t kata-tests .
docker run --rm kata-tests

# Commit via Git agent
kiro-cli --tui --agent git-agent
> Create a branch for the CI/CD issue
> Commit the Dockerfile and workflow
> Create a PR closing the CI/CD issue
```

**Notes:**
The workflow is: use the CI/CD agent to generate files, test locally, then switch to the Git agent to commit and create a PR.
This is the multi-agent workflow in action. Each agent is specialized. The CI/CD agent knows pipelines. The Git agent knows commits and PRs. You orchestrate them.

---

## Slide 37: Acceptance Criteria
**Type:** content
**Content:**
- Acceptance Criteria
- [ ] Agent config at `.kiro/agents/cicd-agent.json`
- [ ] Agent detects kata language and build system
- [ ] Working `Dockerfile` that builds and runs tests
- [ ] Working `.github/workflows/ci.yml`
- [ ] Pipeline triggers on push and PR
- [ ] Tests run inside Docker container in CI
- [ ] PR shows ✅ status check
- [ ] Instructor added as reviewer

**Notes:**
These are the checkboxes that must all be checked for the module to be complete. The most important one: PR shows a green check. That means your pipeline works end-to-end — from push to Docker build to test execution to status report.

---

## Slide 38: 🎯
**Type:** big_number
**Content:**
🎯
Key Takeaway
CI/CD is the automated quality gate. Docker makes it reproducible. GitHub Actions makes it free.
Build it once, and every future change is automatically verified.

**Notes:**
After this module, every push to your kata triggers an automated build and test. You never have to manually verify again. The pipeline does it for you.
This is the foundation for Module 5 (TDD) and Module 6 (deployment). You can't do test-driven development effectively without CI verifying your tests. You can't deploy safely without CI confirming the build is green.
