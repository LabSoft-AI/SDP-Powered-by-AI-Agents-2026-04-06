# Module 6: Final Project

## Learning Objectives

- Apply the complete AI-assisted development workflow end-to-end
- Demonstrate TDD/BDD discipline with CI/CD evidence
- Build professional documentation with Sphinx and GitHub Pages
- Deliver a complete, tested, documented, and deployable kata project

## Overview

The final project brings together everything from Modules 1–5. You will
complete your coding kata using all AI agents, with full TDD discipline,
CI/CD pipelines, and professional documentation.

## Project Requirements

### 1. Complete All User Stories

Use your AI agents to implement **all remaining kata user stories**.

**IMPORTANT**: Before starting, fix your `requirements-agent` to enforce
localhost Docker deployment and regenerate all INFRA scenarios.

Follow the implementation order for each story: INFRA → BE → FE → E2E

### 2. TDD Discipline with CI/CD Evidence

- Practice RED → GREEN → REFACTOR cycles
- **Commit on every GREEN stage** — CI/CD must show this evidence
- Each commit references the Story/Scenario ID
- CI/CD pipeline triggers on every push with passing tests

### 3. Organize Documentation

Move your `architecture/` folder under `docs/` (if not already there):

```text
docs/
├── architecture/     # All arc42 chapters + diagrams
└── user-stories/     # Story inventory + all bundles
```

### 4. Sphinx Documentation Site

Create a **Sphinx agent** (`.kiro/agents/sphinx-agent.json`) that builds
a static documentation site including:

- Project README
- Architecture documentation (all arc42 chapters)
- User Stories (inventory + all story bundles)

**Starter files** are provided in `modules/module-6-project/starter/`.
Copy them to your `docs/` folder and customize:

```bash
cp -r modules/module-6-project/starter/* docs/
```

Then edit `docs/conf.py` (project name, author, GitHub URL) and
`docs/index.rst` (add your architecture chapters and user story files).

See `modules/module-6-project/starter/README.md` for detailed setup
instructions.

### 5. Documentation CI/CD Pipeline

Add a workflow (`.github/workflows/docs-deploy.yml`) that:

- **Triggers** when `README.md`, `docs/architecture/**`, or
  `docs/user-stories/**` change
- **Builds** the Sphinx site
- **Deploys** to GitHub Pages

### 6. Professional README

Once all stories are implemented and tests pass, create a root `README.md`:

- Project title and description
- What the kata solves
- Tech stack and architecture overview
- How to build and run locally (`docker build` + `docker run`)
- How to run tests
- Link to live Sphinx documentation site
- Project structure overview
- Author information

### 7. License

Add a `LICENSE` file (MIT recommended) to the repository root.

## Timeline

| Day | Activity |
|-----|----------|
| Mon 20.4. | Project consultation (not mandatory) |
| Wed 22.4. | Project consultation (not mandatory) |
| **Fri 24.4.** | **Project presentations (mandatory)** |

## Grading (45 pts)

| Criterion | Points |
|-----------|--------|
| Kata is functional (`docker build && docker run`) | 15 |
| All user stories implemented (tests GREEN) | 10 |
| TDD discipline visible in CI/CD history | 10 |
| Sphinx documentation site on GitHub Pages | 5 |
| Professional README + LICENSE | 5 |

## Deliverables

- [ ] PR with all implemented user stories
- [ ] Kata functional: `docker build && docker run`
- [ ] CI/CD pipeline showing TDD commit history
- [ ] Live Sphinx documentation site
- [ ] Documentation CI/CD workflow deploying to GitHub Pages
- [ ] Professional README + LICENSE
