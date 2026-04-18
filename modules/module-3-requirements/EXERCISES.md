# Module 3: Software Requirements — Exercise Checklist

## Part 1: Understand Story Decomposition

### Step 1: Identify Domains

- [ ] Read architecture document from Module 2
- [ ] Listed bounded contexts / major components
- [ ] Mapped each context to a story domain name

### Step 2: List All Stories

- [ ] Written prioritized list of all user stories
- [ ] Marked Pareto 20% (core stories)
- [ ] Total stories: ______
- [ ] Core stories (20%): ______

### Step 3: Write One Story Bundle Manually

- [ ] Picked one core story
- [ ] Written Original story with AS A / I WANT / SO THAT
- [ ] Written GIVEN-WHEN-THEN scenarios for original story
- [ ] Written FE sub-stories with scenarios (if applicable)
- [ ] Written BE sub-stories with scenarios
- [ ] Written INFRA sub-stories with scenarios:
  - [ ] INFRA: Deployment (Docker container, CI pipeline, or packaging)
  - [ ] INFRA: Data store (database, file storage, or in-memory — appropriate for your architecture)
  - [ ] INFRA: Event handling (if applicable)
  - [ ] INFRA: Monitoring and observability (logging, health checks, or alarms)

### Step 4: Verify Traceability

- [ ] Each scenario traces to an architecture section
- [ ] Each sub-story references its parent story
- [ ] Each THEN clause is a testable assertion

---

## Part 2: Build and Use the Requirements Agent

> **Agent:** `requirements-agent`
> ```bash
> kiro-cli --tui --agent requirements-agent
> ```

### Step 1: Build the Requirements Agent

- [ ] Agent config created at `.kiro/agents/requirements-agent.json`
- [ ] Agent reads architecture and extracts domains
- [ ] Agent generates prioritized story list with Pareto analysis
- [ ] Agent writes story bundles (Original + FE + BE + INFRA)
- [ ] Agent uses GIVEN-WHEN-THEN for all scenarios
- [ ] Agent includes architecture references
- [ ] Agent waits for approval before next story
- [ ] Agent tracks Pareto progress

### Step 2: Generate Stories

- [ ] Started agent: `kiro-cli --tui --agent requirements-agent`
- [ ] Provided architecture document path
- [ ] Received prioritized story list
- [ ] Core stories generated and approved:
  - [ ] Story 1: ______________________________ — approved
  - [ ] Story 2: ______________________________ — approved
  - [ ] Story 3: ______________________________ — approved
- [ ] Supporting stories (as needed):
  - [ ] Story 4: ______________________________ — approved
  - [ ] Story 5: ______________________________ — approved

### Step 3: Verify Story Quality

- [ ] All original stories have AS A / I WANT / SO THAT
- [ ] All scenarios use GIVEN-WHEN-THEN
- [ ] Architecture references point to real sections
- [ ] Story IDs follow `{DOMAIN}-{TYPE}-{N}.{X}` convention
- [ ] INFRA stories cover: deployment, data store, events, monitoring (adapted to your architecture)
- [ ] `docs/user-stories/README.md` has story inventory + Pareto progress

### Step 4: Commit via Git Agent

> **Switch agent:** `git-agent`
> ```bash
> kiro-cli --tui --agent git-agent
> ```

- [ ] Feature branch created for requirements issue
- [ ] User stories committed with issue reference
- [ ] PR created closing the requirements issue

### Step 5: Review and Merge

- [ ] Instructor added as reviewer (`gh pr edit --add-reviewer momokrunic`)
- [ ] PR approved by instructor
- [ ] Merged to main via `gh pr merge --squash`
- [ ] Requirements issue auto-closed
