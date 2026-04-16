# Module 5 Starter: TDD/BDD Agent

Starter Kiro CLI agent configuration for Module 5.

This is the most complex agent in the course. It uses a **file URI prompt**
(`file://./tdd-bdd-prompt.md`) to keep the prompt in a separate file —
a best practice from the
[Kiro CLI configuration reference](https://kiro.dev/docs/cli/custom-agents/configuration-reference/).

## Setup

```bash
# Copy both files to your repo
cp tdd-bdd-agent.json /path/to/your-repo/.kiro/agents/
cp tdd-bdd-prompt.md /path/to/your-repo/.kiro/agents/

# Start the agent
kiro-cli --agent tdd-bdd-agent
```

## What to Complete

The prompt file (`tdd-bdd-prompt.md`) has TODO sections you must fill in:

1. **Test Naming Convention** — Rules for naming test functions with Story/Scenario IDs
2. **GIVEN-WHEN-THEN Test Template** — The pytest template every test must follow
3. **Green Bar Pattern Rules** — When to use Fake It, Triangulate, Obvious Implementation
4. **Refactoring Checklist** — What to check during the refactoring step
5. **Commit Message Format** — How to format TDD commits with story references
6. **postToolUse Hook** — Replace the placeholder hook in `tdd-bdd-agent.json` with a real hook that runs pytest after every file write

## Agent Configuration Features

This agent uses advanced Kiro CLI features:

- **`file://` prompt** — Prompt lives in a separate `.md` file for readability
- **`resources`** — Auto-loads user stories from `docs/user-stories/`
- **`allowedTools`** — `read` is auto-approved for speed
- **`hooks.postToolUse`** — Runs after every file write (configure to run tests)

See the [Kiro CLI configuration reference](https://kiro.dev/docs/cli/custom-agents/configuration-reference/)
for all available options.

## Usage

```bash
kiro-cli --agent tdd-bdd-agent

> Read my user stories at docs/user-stories/
> Start with the first BE scenario of the first core story
> Follow strict RED-GREEN-REFACTOR — one test at a time
```
