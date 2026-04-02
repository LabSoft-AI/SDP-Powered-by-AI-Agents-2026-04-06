# Software Development Processes Powered by AI Agents

Masters course — 3-week intensive on building AI agents that automate the software development lifecycle.

## Course Project: FitTrack

A serverless fitness tracker built entirely by AI agents.

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

- Python 3.12+
- Node 20+
- AWS SAM CLI
- GitHub account
