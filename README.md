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
   together to build **FitTrack**, a serverless fitness tracker on AWS.

## Modules

| # | Module | Process Learned | Agent Built |
|---|--------|-----------------|-------------|
| 0 | [Intro](modules/intro/) | Context engineering, harness engineering | — |
| 1 | [Git](modules/module-1-git/) | Branching, commits, PRs, issue tracking | Issue creator, PR creator |
| 2 | Software Architecture | arc42 template, C4 model | Architecture doc generator |
| 3 | Software Requirements | User stories, DDD, Pareto prioritization | Story derivation agent |
| 4 | CI/CD | GitHub Actions, SAM, AWS deployment | Deployment pipeline agent |
| 5 | TDD/BDD | RED-GREEN-REFACTOR, backend-first | Multi-agent TDD system |
| 6 | FitTrack App | Full lifecycle (team project) | All agents from M1–M5 |

## Course Project: FitTrack

A serverless fitness tracker that lets users log workouts, track personal
records, and visualize weekly progress. Built entirely by AI agents.

**Bounded contexts:** AUTH, WORKOUT, PROGRESS.

## 3-Week Timeline

| Days | Activity | Deliverable |
|------|----------|-------------|
| 1–2 | Module 1: Git | Git agent + practice exercise |
| 3–4 | Module 2: Architecture | Architecture agent + kata design |
| 5–6 | Module 3: Requirements | Story agent + kata backlog |
| 7–8 | Module 4: CI/CD | Deploy agent + pipeline exercise |
| 9–12 | Module 5: TDD/BDD | Multi-agent TDD system + practice |
| 13–18 | Module 6: FitTrack (teams) | Working app deployed on AWS |
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
      - run: sam deploy --no-confirm-changeset --no-fail-on-empty-changeset --stack-name fittrack --resolve-s3 --capabilities CAPABILITY_IAM
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
- AWS SAM CLI
- GitHub account
- Basic knowledge of Python, REST APIs, and React

## References

- [Harness Engineering (Fowler)](https://martinfowler.com/articles/harness-engineering.html)
- [Context Engineering (Fowler)](https://martinfowler.com/articles/exploring-gen-ai/context-engineering-coding-agents.html)
- [arc42 Template](https://arc42.org/overview)
- [C4 Model](https://c4model.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Pre-commit Framework](https://pre-commit.com/)
- [Coding Dojo Kata Catalogue](https://codingdojo.org/kata/)
