# Module 4 Starter: CI/CD Agent

Starter Kiro CLI agent configuration for Module 4.

## Setup

```bash
# Copy to your repo
cp cicd-agent.json /path/to/your-repo/.kiro/agents/

# Start the agent
kiro-cli --tui --agent cicd-agent
```

## What to Complete

The starter has TODO sections you must fill in:

1. **Dockerfile Template** — Add a Python Dockerfile template (`python:3.12-slim` base, pip install, pytest CMD)
2. **GitHub Actions Workflow Template** — Add the complete `ci.yml` template with triggers, permissions, and Docker build/run steps
3. **Path Filtering Rules** — Define which file changes should trigger the pipeline. Hint: think about where your implementation lives (`src/`), where your tests live (`tests/`), and the files that define the build environment (`Dockerfile`, `requirements.txt`, `.github/workflows/ci.yml`)
4. **Docker Build Verification Step** — Add a step that verifies the Docker image builds before running tests

## Usage

```bash
kiro-cli --tui --agent cicd-agent

> Read my kata project structure
> Generate a Dockerfile for building and testing
> Generate a GitHub Actions CI workflow
```
