# Module 6: Final Project — Exercise Checklist

## Part 1: Fix Requirements and Complete Stories

### Step 1: Update Requirements Agent

- [ ] Updated `requirements-agent.json` to enforce Docker deployment
- [ ] INFRA stories reference Docker containers (not Lambda/DynamoDB)
- [ ] Regenerated all INFRA scenarios with updated agent

### Step 2: Implement All User Stories

- [ ] For each story, followed INFRA → BE → FE → E2E order
- [ ] Each scenario has RED → GREEN → REFACTOR cycle
- [ ] Committed on every GREEN stage with Story/Scenario ID reference
- [ ] All E2E scenarios pass
- [ ] All BE scenarios pass
- [ ] All FE scenarios pass (if applicable)
- [ ] All INFRA scenarios pass
- [ ] Kata is functional: `docker build && docker run` works

---

## Part 2: CI/CD Evidence

- [ ] CI/CD pipeline triggers on every push
- [ ] Pipeline history shows incremental GREEN commits
- [ ] No commits with failing tests in history
- [ ] Test names include Story/Scenario IDs
- [ ] All tests have GIVEN-WHEN-THEN comments

---

## Part 3: Documentation

### Step 1: Organize Docs

- [ ] `docs/architecture/` contains all arc42 chapters
- [ ] `docs/user-stories/` contains all story bundles
- [ ] `docs/user-stories/README.md` has story inventory

### Step 2: Build Sphinx Documentation Site

- [ ] Copied starter files to `docs/`: `cp -r modules/module-6-project/starter/* docs/`
- [ ] Updated `docs/conf.py` with project name, author, GitHub URL
- [ ] Updated `docs/index.rst` with architecture chapters and user story files
- [ ] Installed dependencies: `pip install -r docs/requirements.txt`
- [ ] Sphinx site builds locally without errors: `cd docs && make html`
- [ ] (Optional) Sphinx agent created at `.kiro/agents/sphinx-agent.json`

### Step 3: Documentation CI/CD

- [ ] Copied workflow: `mkdir -p .github/workflows && cp modules/module-6-project/starter/docs-deploy.yml .github/workflows/`
- [ ] Enabled GitHub Pages: Settings → Pages → Source → GitHub Actions
- [ ] Triggers on changes to `README.md` and `docs/**`
- [ ] Builds Sphinx site and deploys to GitHub Pages
- [ ] Documentation site is live at `https://<username>.github.io/<repo>/`

---

## Part 4: Polish

### Step 1: Professional README

- [ ] Project title and description
- [ ] What the kata solves
- [ ] Tech stack and architecture overview
- [ ] How to build and run locally
- [ ] How to run tests
- [ ] Link to Sphinx documentation site
- [ ] Project structure overview
- [ ] Author information

### Step 2: License

- [ ] `LICENSE` file at repository root (MIT recommended)
