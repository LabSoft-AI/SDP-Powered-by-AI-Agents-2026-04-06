# Module 3: Software Requirements

## Slide 1: Module 3: Software Requirements
**Type:** title
**Content:**
Module 3: Software Requirements
Software Development Processes Powered by AI Agents

**Notes:**
Welcome to Module 3. In Module 2 you designed the architecture — the what and how of your system. Now we define what to build first and how to verify it works.
By the end of this module you'll derive user stories from architecture, write testable acceptance criteria, and build an agent that automates the whole process.

---

## Slide 2: What You'll Learn
**Type:** content
**Content:**
- What You'll Learn
- Derive user stories from architecture documents
- Write testable acceptance criteria (GIVEN-WHEN-THEN)
- Decompose stories into FE, BE, and INFRA sub-stories
- Apply Pareto principle to prioritize high-impact stories
- Maintain traceability: architecture → story → scenario → test
- Build a Kiro CLI agent that automates story derivation

**Notes:**
Same pattern as Modules 1 and 2: learn the process, then encode it as an agent.
Requirements engineering is where architecture meets implementation. Without it, developers build the wrong things in the wrong order.

---

## Slide 3: Part 1
**Type:** section
**Content:**
Part 1
Why Requirements Engineering?

**Notes:**
Let's start with why structured requirements matter, even for small projects.

---

## Slide 4: Without Requirements
**Type:** big_number
**Content:**
⚠️
Without Requirements
Developer: "I'll build the login page"
PM: "But we need the payment flow first"
Tester: "How do I know if login works correctly?"
Misaligned priorities. Untestable features. Wasted effort.

**Notes:**
This happens in every team without structured requirements. Everyone has a different idea of what's important. Developers build features nobody asked for. Testers don't know what "correct" means. PMs can't track progress because there's nothing to track against.

---

## Slide 5: With Requirements
**Type:** content
**Content:**
- With Structured Requirements
- **Clear priority** — everyone knows what to build first
- **Testable** — every feature has acceptance criteria
- **Traceable** — every test maps back to a requirement
- **Measurable** — progress is visible (3/10 stories done)
- **Aligned** — developers, testers, PMs agree on scope

**Notes:**
User stories with acceptance criteria solve all of these problems. The story says what to build, the acceptance criteria say how to verify it, and the priority says when to build it.

---

## Slide 6: Part 2
**Type:** section
**Content:**
Part 2
User Stories

**Notes:**
The fundamental unit of requirements in agile development.

---

## Slide 7: User Story Format
**Type:** content
**Content:**
- User Story Format
- **AS A** <role>
- **I WANT** <feature>
- **SO THAT** <benefit>
- Example:
- AS A customer
- I WANT to search products by name
- SO THAT I can find what I'm looking for quickly

**Notes:**
Three parts: who wants it, what they want, and why they want it. The "so that" is critical — it captures the business value. Without it, you're just listing features with no justification.

---

## Slide 8: INVEST Criteria
**Type:** content
**Content:**
- Good Stories Are INVEST
- **I**ndependent — can be developed in any order
- **N**egotiable — details can be discussed
- **V**aluable — delivers value to the user
- **E**stimable — team can estimate effort
- **S**mall — fits in one sprint/iteration
- **T**estable — has clear acceptance criteria

**Notes:**
INVEST is your quality checklist for stories. If a story isn't testable, it's not a story — it's a wish. If it's not independent, you have hidden dependencies that will block your sprint.

---

## Slide 9: Bad vs Good Stories
**Type:** content
**Content:**
- Bad vs Good Stories
- ❌ AS A user I WANT the system to work SO THAT I can use it
- ❌ AS A developer I WANT to create a database table
- ❌ Build the entire checkout flow
- ✅ AS A customer I WANT to add items to cart SO THAT I can purchase multiple products
- ✅ AS A merchant I WANT to see daily revenue SO THAT I can track business performance

**Notes:**
The first bad example has no specificity. The second is a technical task, not a user story — users don't care about database tables. The third is too big — it's an epic, not a story.
Good stories are specific, user-focused, and small enough to implement and test in isolation.

---

## Slide 10: Part 3
**Type:** section
**Content:**
Part 3
From Architecture to Stories

**Notes:**
Your architecture document from Module 2 is the input. User stories are the output. Let's see how to make that connection.

---

## Slide 11: Bounded Contexts → Domains
**Type:** content
**Content:**
- Architecture → Story Domains
- Each **bounded context** from Module 2 becomes a **domain**
- Bounded Context: Order Management → Domain: ORDER
- Bounded Context: Inventory → Domain: INVENTORY
- Bounded Context: User Auth → Domain: AUTH
- Domain names become **prefixes** for Story IDs

**Notes:**
This is the traceability link between architecture and requirements. Your architecture identified the bounded contexts — the major areas of your system. Each one becomes a domain in your story naming convention.
If your kata has a Grid context and a Rover context, those become GRID-STORY-001 and ROVER-STORY-001.

---

## Slide 12: Part 4
**Type:** section
**Content:**
Part 4
Acceptance Criteria: GIVEN-WHEN-THEN

**Notes:**
The most important part of a user story is not the story itself — it's the acceptance criteria. This is what makes stories testable.

---

## Slide 13: GIVEN-WHEN-THEN Format
**Type:** content
**Content:**
- GIVEN-WHEN-THEN
- **GIVEN** — preconditions (test setup)
- **WHEN** — action under test (trigger)
- **THEN** — expected outcome (assertions)
- Example:
- GIVEN product catalogue contains "Red Widget"
- WHEN I search for "Widget"
- THEN results show "Red Widget"

**Notes:**
This format comes from Behavior-Driven Development. It maps directly to test code: GIVEN is your setup, WHEN is the action you're testing, THEN is your assertions.
Every scenario you write in this format can be turned into an automated test. That's the whole point — requirements that are executable.

---

## Slide 14: GIVEN-WHEN-THEN → Test Code
**Type:** content
**Content:**
- Scenarios Map to Tests
- ```python
- def test_search_returns_matching():
-     # GIVEN
-     catalogue = create(["Red Widget"])
-     # WHEN
-     results = search(catalogue, "Widget")
-     # THEN
-     assert results[0].name == "Red Widget"
- ```
- Every GIVEN = setup
- Every WHEN = action
- Every THEN = assertion

**Notes:**
This is spec-driven development in action. You write the spec first as GIVEN-WHEN-THEN, then the test writes itself. The agent in Module 5 will actually generate these tests from your stories — but only if the stories are well-written.

---

## Slide 15: Part 5
**Type:** section
**Content:**
Part 5
Story Decomposition

**Notes:**
A single user story is too big to implement directly. We need to break it down by layer.

---

## Slide 16: Decomposition Pattern
**Type:** content
**Content:**
- Story Decomposition: Original → Sub-stories
- **Original Story** — the user-facing requirement (E2E test)
- **FE Stories** — UI components (component tests)
- **BE Stories** — API/business logic (unit tests)
- **INFRA Stories** — Lambda, DynamoDB, events, monitoring
- Implementation order: **INFRA → BE → FE → E2E**

**Notes:**
You can't build a UI for an API that doesn't exist. You can't deploy code without infrastructure. That's why the order is always infrastructure first, then backend, then frontend, then end-to-end verification.
Each layer has its own test type. INFRA stories test that resources exist. BE stories test business logic. FE stories test UI components. The original story tests the full flow.

---

## Slide 17: Decomposition Example
**Type:** content
**Content:**
- Example: "Search Products" Story
- STORY-001: AS A customer I WANT to search products
- ├── FE-001.1: Search input component
- ├── FE-001.2: Results list component
- ├── BE-001.1: Search API endpoint
- ├── BE-001.2: Search indexing logic
- ├── INFRA-001.1: Deploy search Lambda
- ├── INFRA-001.2: Create products DynamoDB table
- ├── INFRA-001.3: Configure search event
- └── INFRA-001.4: Setup CloudWatch monitoring

**Notes:**
One user story becomes 8 sub-stories. Each is independently testable, independently implementable, and has a clear owner. This is how you turn a vague requirement into actionable work items.
The INFRA stories are mandatory — every story needs at minimum: Lambda deployment, data store, event handling if applicable, and monitoring.

---

## Slide 18: Part 6
**Type:** section
**Content:**
Part 6
Pareto Prioritization (80/20)

**Notes:**
You can't build everything at once. The Pareto principle tells you what to build first.

---

## Slide 19: The 80/20 Rule
**Type:** big_number
**Content:**
20%
of stories deliver
80%
of the value

**Notes:**
This is the Pareto principle applied to software requirements. Not all stories are equal. A small number of stories — usually around 20% — deliver the vast majority of user value.
Your job is to identify which stories are in that critical 20% and build those first. The remaining 80% of stories are nice-to-have — they add polish but aren't essential for the MVP.

---

## Slide 20: Identifying Core Stories
**Type:** content
**Content:**
- How to Identify Core Stories (20%)
- Which stories are needed for the **MVP**?
- Which stories **block** other stories?
- Which stories deliver the **most user value**?
- Which stories exercise the **most architecture components**?
- Core stories first → Supporting stories later

**Notes:**
Ask these four questions for every story. If a story is needed for the MVP, blocks other work, delivers high value, and exercises multiple components — it's definitely in the core 20%.
For your kata, the core stories are the ones that implement the main algorithm or game loop. Supporting stories are things like error messages, edge cases, and UI polish.

---

## Slide 21: Part 7
**Type:** section
**Content:**
Part 7
Story IDs and Traceability

**Notes:**
Every story and scenario needs a unique ID so you can trace from architecture to test.

---

## Slide 22: Story ID Convention
**Type:** content
**Content:**
- Story ID Format
- Original: `{DOMAIN}-STORY-{N}` → ORDER-STORY-001
- Frontend: `{DOMAIN}-FE-{N}.{X}` → ORDER-FE-001.1
- Backend: `{DOMAIN}-BE-{N}.{X}` → ORDER-BE-001.1
- Infrastructure: `{DOMAIN}-INFRA-{N}.{X}` → ORDER-INFRA-001.1
- Scenario: `{STORY-ID}-S{N}` → ORDER-BE-001.1-S1

**Notes:**
The naming convention encodes the domain, the type, the parent story number, and the sub-story number. This means you can look at any test name and immediately know which story, which layer, and which scenario it tests.
In Module 5, your TDD agent will use these IDs to name test functions: test_order_be_001_1_s1_given_valid_order_when_submitted_then_created.

---

## Slide 23: Traceability Chain
**Type:** content
**Content:**
- Full Traceability
- Architecture Section 3.2
- ↓ derives
- ORDER-STORY-001
- ↓ decomposes
- ORDER-BE-001.1
- ↓ specifies
- ORDER-BE-001.1-S1
- ↓ tests
- test_order_be_001_1_s1_...

**Notes:**
This is the golden thread from design to test. When a test fails, you trace it back: which scenario? Which story? Which architecture component? When architecture changes, you trace forward: which stories are affected? Which tests need updating?
This traceability is what separates professional software engineering from ad-hoc coding.

---

## Slide 24: Part 8
**Type:** section
**Content:**
Part 8
Building the Requirements Agent

**Notes:**
Now let's automate everything we just learned. You'll build an agent that reads your architecture and produces user stories.

---

## Slide 25: Agent Workflow
**Type:** content
**Content:**
- Requirements Agent Workflow
- 1. Read architecture document
- 2. Extract domains (bounded contexts)
- 3. Generate prioritized story list (Pareto)
- 4. Write story bundles one at a time
- 5. Wait for approval before next story
- 6. Track progress with Pareto metrics

**Notes:**
Same pattern as the architecture agent — work incrementally, wait for approval. The agent reads your Module 2 output and produces Module 3 output.
The key context engineering challenge is encoding the story format, the decomposition rules, and the Pareto analysis into the agent's prompt.

---

## Slide 26: What the Agent Produces
**Type:** content
**Content:**
- Agent Output
- ```
- docs/user-stories/
- ├── README.md          ← inventory + progress
- ├── {domain-1}.md      ← STORY + FE + BE + INFRA
- ├── {domain-2}.md      ← STORY + FE + BE + INFRA
- └── {domain-3}.md      ← STORY + FE + BE + INFRA
- ```
- Each file = one **story bundle**
- Original + all sub-stories in one file

**Notes:**
Story bundles keep everything together. When you open a domain file, you see the original story, all its frontend stories, all its backend stories, and all its infrastructure stories. No jumping between files.
The README tracks overall progress and Pareto completion percentage.

---

## Slide 27: Context Engineering for Requirements
**Type:** content
**Content:**
- Context Engineering: What Goes in the Prompt
- ✅ Story format (AS A / I WANT / SO THAT)
- ✅ GIVEN-WHEN-THEN template
- ✅ Story ID naming convention
- ✅ Decomposition rules (FE + BE + INFRA)
- ✅ INFRA minimums (Lambda, data, events, monitoring)
- ✅ Pareto analysis instructions
- ✅ Architecture reference rules

**Notes:**
This is your TODO list for the agent prompt. The starter template has placeholders for each of these. Fill them in based on what we covered today.
The better your prompt, the better your stories. This is context engineering — controlling the agent's output by controlling its input.

---

## Slide 28: Assignment
**Type:** content
**Content:**
- Module 3 Assignment
- 1. Build `requirements-agent.json` (fill in all TODOs)
- 2. Use it to derive stories from your kata architecture
- 3. Generate all core stories (Pareto 20%)
- 4. Commit via git-agent, create PR
- 5. Add `@momokrunic` as reviewer
- Deadline: check COURSE-TRACKER for dates

**Notes:**
Same workflow as Module 2. Build the agent, use it on your kata, commit the results, create a PR.
The starter template has TODO sections — you need to fill in the story bundle template, Pareto analysis rules, INFRA requirements, and architecture reference rules. These are the parts that make your agent produce good stories instead of generic ones.

---

## Slide 29: Recap
**Type:** content
**Content:**
- Module 3 Recap
- ✅ User stories capture requirements from user perspective
- ✅ GIVEN-WHEN-THEN makes stories testable
- ✅ Decompose: Original → FE + BE + INFRA
- ✅ Pareto: 20% of stories = 80% of value
- ✅ Story IDs enable full traceability
- ✅ Implementation order: INFRA → BE → FE → E2E
- Next: Module 4 — CI/CD

**Notes:**
You now have the complete chain: architecture (Module 2) tells you what to build, requirements (Module 3) tell you what to build first and how to verify it, and in Module 5 you'll use TDD to actually implement it.
Module 4 covers CI/CD — automating the deployment pipeline so your code goes from commit to production automatically.
