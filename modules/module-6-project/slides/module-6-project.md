# Module 6: Final Project

## Slide 1: Module 6: Final Project
**Type:** title
**Content:**
Module 6: Final Project
Software Development Processes Powered by AI Agents

**Notes:**
This is the capstone module. Everything from Modules 1–5 comes together. You complete your kata end-to-end using all AI agents, with full TDD discipline, CI/CD pipelines, and professional documentation.

---

## Slide 2: What You'll Deliver
**Type:** content
**Content:**
- A fully functional kata: `docker build && docker run`
- All user stories implemented with TDD discipline
- CI/CD pipeline showing GREEN commits
- Sphinx documentation site on GitHub Pages
- Professional README + LICENSE

**Notes:**
This is not a new concept module — it's pure execution. You already have all the tools. Now use them to deliver a complete, professional project.

---

## Slide 3: The Full Picture
**Type:** content
**Content:**
- Module 1: Git Agent → commits, branches, PRs
- Module 2: Architecture Agent → arc42, C4 diagrams
- Module 3: Requirements Agent → user stories, Pareto
- Module 4: CI/CD Agent → Docker, pipelines
- Module 5: TDD/BDD Agent → RED-GREEN-REFACTOR
- **Module 6: All agents → complete project**

**Notes:**
Each module gave you one agent. Now you orchestrate all of them together. The git agent creates issues and PRs. The TDD agent implements stories. The CI/CD pipeline validates every push.

---

## Slide 4: Step 1 — Fix INFRA Stories
**Type:** content
**Content:**
- Update `requirements-agent` to enforce Docker deployment
- Regenerate all INFRA scenarios
- No Lambda/DynamoDB — use Docker containers
- INFRA stories must cover: deployment, data store, events, monitoring

**Notes:**
Before you start implementing, your INFRA stories need to match your actual deployment target. The course exercises originally referenced AWS Lambda, but your katas use localhost Docker. Fix this first or your TDD agent will generate wrong infrastructure tests.

---

## Slide 5: Step 2 — Implement with TDD
**Type:** content
**Content:**
- For each story: INFRA → BE → FE → E2E
- RED → GREEN → REFACTOR for each scenario
- **Commit on every GREEN** — this is your evidence
- Each commit references Story/Scenario ID
- CI/CD pipeline must trigger and pass on every push

**Notes:**
The key deliverable is the commit history. I need to see incremental GREEN commits in your CI/CD pipeline. Not one giant commit at the end — that's not TDD. Each scenario gets its own RED-GREEN-REFACTOR cycle and its own commit.

---

## Slide 6: Step 3 — Documentation
**Type:** content
**Content:**
- Move `architecture/` under `docs/`
- Copy Sphinx starter files: `cp -r modules/module-6-project/starter/* docs/`
- Edit `conf.py` and `index.rst`
- Build locally: `cd docs && make html`
- Copy `docs-deploy.yml` to `.github/workflows/`
- Enable GitHub Pages: `gh api repos/{owner}/{repo}/pages -X PUT -f build_type=workflow`

**Notes:**
Starter files are provided — you don't need to write Sphinx config from scratch. Copy, customize, build. The workflow deploys automatically on every push to main that touches docs.

---

## Slide 7: Step 4 — Polish
**Type:** content
**Content:**
- Professional `README.md`:
  - What the kata solves
  - How to build and run (`docker build && docker run`)
  - How to run tests
  - Link to Sphinx docs site
  - Author info
- Add `LICENSE` file (MIT recommended)

**Notes:**
The README is the first thing anyone sees. Make it professional. Include build instructions that actually work. Link to your live documentation site.

---

## Slide 8: Grading (45 pts)
**Type:** content
**Content:**
| Criterion | Points |
|-----------|--------|
| Kata is functional (`docker build && docker run`) | 15 |
| All user stories implemented (tests GREEN) | 10 |
| TDD discipline visible in CI/CD history | 10 |
| Sphinx documentation site on GitHub Pages | 5 |
| Professional README + LICENSE | 5 |

**Notes:**
The biggest chunk is "kata works" — 15 points. If I can clone your repo, run docker build and docker run, and the kata works, that's 15 points. TDD discipline is the second biggest — I look at your CI/CD history for incremental GREEN commits.

---

## Slide 9: Timeline
**Type:** content
**Content:**
| Day | Activity |
|-----|----------|
| Mon 20.4. | Project consultation (not mandatory) |
| Wed 22.4. | Project consultation (not mandatory) |
| **Fri 24.4.** | **Project presentations** |

**Notes:**
Monday and Wednesday are open consultation days — come if you're stuck. Friday is presentations. Be ready to demo your kata and show your CI/CD pipeline.

---

## Slide 10: Go Build
**Type:** closing
**Content:**
You have all the agents.
You have all the tools.
Now deliver.

`docker build && docker run`

**Notes:**
No new theory. No new concepts. Just execution. Good luck.
