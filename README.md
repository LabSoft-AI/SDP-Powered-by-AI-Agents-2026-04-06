# Software Development Processes Powered by AI Agents

3-week master's course where students build specialized Kiro CLI agents
that automate each phase of the software development lifecycle, then use
those agents as a team to build a real serverless application.

The course is grounded in two emerging disciplines:

- **Context Engineering** — controlling what goes into an agent's context
  window (system prompt, resources, tools, conversation history) to
  maximize output quality.
- **Harness Engineering** — building guides (feedforward controls) that
  steer the agent before it acts, and sensors (feedback controls) that
  detect and self-correct issues after it acts. Pre-commit hooks, linters,
  test suites, and review agents are all part of the harness.
- **Spec-Driven Development** — writing specifications (tests, schemas,
  acceptance criteria) before implementation, then using AI agents to
  generate code that satisfies them. TDD and BDD with AI agents flip the
  traditional workflow: the spec becomes the feedforward guide, and the
  test suite becomes the sensor that validates the agent's output.

Each module teaches a software development process, then has students
encode it as context (agent config) and harness (guides + sensors) around
a Kiro CLI agent.

See the [Intro slides](modules/intro/) for a deeper dive into these
concepts.

## Course Structure

The course has two parts:

1. **Modules 1–5 (Individual)** — Each student builds one Kiro CLI agent
   per module, learning the underlying software development process along
   the way.
2. **Module 6 (Team)** — Students form teams and use all five agents
   together to build **SubscriptionPlatform**, a serverless subscription and payments service on AWS (Lemon Squeezy-style).

## Modules

| # | Module | Process Learned | Agent Built |
|---|--------|-----------------|-------------|
| 0 | [Intro](modules/intro/) | Context engineering, harness engineering | — |
| 1 | [Git](modules/module-1-git/) | Branching, commits, PRs, issue tracking | Issue creator, PR creator |
| 2 | [Software Architecture](modules/module-2-architecture/) | arc42 template, C4 model | Architecture doc generator |
| 3 | [Software Requirements](modules/module-3-requirements/) | User stories, DDD, Pareto prioritization | Story derivation agent |
| 4 | CI/CD | GitHub Actions, SAM, AWS deployment | Deployment pipeline agent |
| 5 | [TDD/BDD](modules/module-5-tdd-bdd/) | RED-GREEN-REFACTOR, backend-first | TDD/BDD implementation agent |
| 6 | Subscription Platform | Full lifecycle (team project) | All agents from M1–M5 |

## Course Project: SubscriptionPlatform

A serverless subscription and payments service (Lemon Squeezy-style) that lets
merchants create products, manage customers, process checkouts, and handle
recurring billing. Built entirely by AI agents.

**Bounded contexts:** CATALOG, IDENTITY, ORDER, BILLING.

## 3-Week Timeline

| Days | Activity | Deliverable |
|------|----------|-------------|
| 1–2 | [Module 1: Git](modules/module-1-git/) | Git agent + practice exercise |
| 3–4 | [Module 2: Architecture](modules/module-2-architecture/) | Architecture agent + kata design |
| 5–6 | [Module 3: Requirements](modules/module-3-requirements/) | Story agent + kata backlog |
| 7–8 | Module 4: CI/CD | Deploy agent + pipeline exercise |
| 9–12 | Module 5: TDD/BDD | Multi-agent TDD system + practice |
| 13–18 | Module 6: Subscription Platform (teams) | Working app deployed on AWS |
| 19–21 | Buffer / presentations | Demo + retrospective |

## Assessment

| Criterion | Weight |
|-----------|--------|
| Architecture doc covers all 12 arc42 chapters | 15% |
| Story backlog has correct IDs, BDD ACs, traceability | 20% |
| RED phase committed before any implementation | 15% |
| All MVP tests GREEN | 25% |
| Traceability comments in every implementation file | 10% |
| App deployed and reachable on AWS | 15% |

## AWS Infrastructure

| Resource | Value |
|----------|-------|
| AWS Account | `954728790990` (Course) |
| Region | `eu-central-1` |
| OIDC Deploy Role | `arn:aws:iam::954728790990:role/GitHubActions-Course` |
| Permissions Boundary | `arn:aws:iam::954728790990:policy/CoursePermissionsBoundary` |
| SSO Portal | https://d-90678c8e27.awsapps.com/start |
| SSO Username | `student` |

## Deployment

All deployments go through GitHub Actions using OIDC federation — no AWS keys in the repo.

### GitHub Actions Workflow

```yaml
name: Deploy
on:
  push:
    branches: [main, 'feature/**', 'fix/**', 'hotfix/**', 'chore/**']

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::954728790990:role/GitHubActions-Course
          aws-region: eu-central-1

      - uses: aws-actions/setup-sam@v2

      - run: sam build
      - run: sam deploy --no-confirm-changeset --no-fail-on-empty-changeset --stack-name subscription-platform --resolve-s3 --capabilities CAPABILITY_IAM
```

### Permissions Boundary

All IAM roles created by SAM/CloudFormation must reference the permissions boundary:

```yaml
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      # ...
      Policies:
        - DynamoDBCrudPolicy:
            TableName: !Ref MyTable
```

The `CoursePermissionsBoundary` allows only:
- Lambda, DynamoDB, API Gateway, S3, CloudFront
- Cognito, CloudFormation, CloudWatch, Events, Step Functions
- IAM role management (no user/group/policy creation)

Blocked services: EC2, RDS, EKS, ECS, Bedrock, SageMaker, Redshift

### Allowed Branch Prefixes

| Branch | Purpose |
|--------|---------|
| `main` | Production-ready code |
| `feature/*` | New functionality |
| `fix/*` | Bug fixes |
| `hotfix/*` | Urgent fixes |
| `chore/*` | Maintenance tasks |

## Tech Stack

| Layer | Technology |
|-------|------------|
| Runtime | Python 3.12 |
| API | Amazon API Gateway (REST) |
| Compute | AWS Lambda |
| Database | Amazon DynamoDB (single-table) |
| Auth | Amazon Cognito User Pools |
| IaC | AWS SAM (`template.yaml`) |
| Frontend | React 18 SPA |
| Hosting | S3 + CloudFront |
| CI/CD | GitHub Actions |
| Testing | pytest, pytest-bdd, moto |

## Prerequisites

- AWS student sandbox account (SSO access provided)
- [Kiro CLI](https://kiro.dev) installed
- Python 3.12+
- Node 20+
- Java (for PlantUML diagram generation)
- AWS SAM CLI
- GitHub account + [GitHub CLI](https://cli.github.com/) (`gh`)
- Basic knowledge of Python, REST APIs, and React

## Setup

Clone the repo and run the setup script:

```bash
git clone https://github.com/LabSoft-AI/SDP-Powered-by-AI-Agents-2026-04-06.git
cd SDP-Powered-by-AI-Agents-2026-04-06
./setup.sh
source .venv/bin/activate
```

This creates a Python virtual environment and installs:

- PlantUML (for diagram generation)
- `pre-commit` and `detect-secrets`
- Pre-commit hooks:
  - Filesystem checks (trailing whitespace, YAML, JSON, merge conflicts)
  - Secret detection (with `.secrets.baseline`)
  - PlantUML SVG auto-generation from `.puml` files
  - Commit message format validation (`#<issue> <type>(<scope>): <description>`)
  - Direct commits to `main` blocked (must use PRs)

## References

- [Harness Engineering (Fowler)](https://martinfowler.com/articles/harness-engineering.html)
- [Context Engineering (Fowler)](https://martinfowler.com/articles/exploring-gen-ai/context-engineering-coding-agents.html)
- [Spec-Driven Development (Fowler)](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)
- [arc42 Template](https://arc42.org/overview)
- [C4 Model](https://c4model.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Pre-commit Framework](https://pre-commit.com/)
- [Coding Dojo Kata Catalogue](https://codingdojo.org/kata/)
