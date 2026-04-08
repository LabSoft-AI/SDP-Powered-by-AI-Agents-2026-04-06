# Architecture Agent Starter

Starter Kiro CLI agent configuration for Module 2.

## Usage

From your kata repo root:

```bash
mkdir -p .kiro/agents
cp modules/module-2-architecture/starter/architecture-agent.json .kiro/agents/
```

Start the agent:

```bash
kiro-cli chat --agent architecture-agent
```

## What You Need to Complete

The starter config has the arc42 workflow and output format. You must add:

1. **C4 PlantUML templates** — Context, Container, and Component diagram
   examples using `!include` from the C4-PlantUML library
2. **ADR template** — Architecture Decision Record format with Status,
   Context, Decision, Rationale, Consequences
3. **Architectural principles** — the principles your agent should follow
   (e.g. serverless, EDA, DDD, scales-to-zero, single-table DynamoDB)

Refer to the Module 2 theory (README.md) for all patterns and formats.
