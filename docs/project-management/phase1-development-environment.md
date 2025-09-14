# JuriSiri Phase 1 - Development Environment Setup Plan

## Overview
This document outlines the complete development environment setup for JuriSiri, designed for Python 3.12, FastAPI backend, Next.js frontend, and PostgreSQL database with Docker.

## Development Environment Architecture

### Technology Stack
- **Backend**: Python 3.12 + FastAPI + SQLAlchemy
- **Frontend**: Next.js 14+ with TypeScript
- **Database**: PostgreSQL 15+ (Docker)
- **Caching**: Redis (Docker, future use)
- **Environment**: Virtual environments (venv)

## Project Structure (Final)

```
jurisiri-v3/
├── docker/                        # Docker configuration folder
│   ├── docker-compose.yml         # Main compose file
│   ├── docker-compose.dev.yml     # Development overrides
│   └── postgres/
│       └── init.sql               # Database initialization
│
├── scripts/                       # Development scripts
│   ├── setup.sh                   # Initial project setup
│   ├── dev-start.sh              # Start development environment
│   ├── dev-stop.sh               # Stop development environment
│   ├── db-reset.sh               # Reset database with fresh schema
│   ├── db-migrate.sh             # Run database migrations
│   ├── db-seed.sh                # Seed with test data
│   ├── test.sh                   # Run all tests
│   ├── test-watch.sh             # Run tests in watch mode
│   └── lint.sh                   # Code quality checks
│
├── api/                          # Backend (Python 3.12 + venv)
│   ├── .env                      # Backend environment variables
│   ├── requirements.txt          # Production dependencies
│   ├── requirements-dev.txt      # Development dependencies
│   ├── pyproject.toml           # Python project configuration
│   ├── .pre-commit-config.yaml  # Git hooks configuration
│   └── [modular structure as defined in phase1-decisions.md]
│
├── web/                          # Frontend (Next.js)
│   ├── .env.local               # Frontend environment variables
│   └── [existing Next.js structure]
│
└── .vscode/                      # VSCode team configuration
    ├── settings.json             # Team settings
    ├── extensions.json           # Recommended extensions
    └── launch.json              # Debug configuration
```

## Code Quality Tools (Industry Best Practices)

### Python Formatting & Linting
- **Black** - Code formatter (used by Google, Microsoft, Netflix)
- **isort** - Import sorting and organization
- **flake8** - Linting with plugins for enhanced checking
- **mypy** - Static type checking for Python
- **bandit** - Security linting for Python code

### Pre-commit Hooks
- Automatic code formatting on commit
- Linting checks before commit
- Type checking validation
- Import sorting enforcement

### VSCode Integration
- Python extension with Black formatter
- Auto-formatting on save
- Integrated linting and type checking
- Consistent team configuration

## Testing Framework (FastAPI Best Practices)

### Testing Stack
- **pytest** - Industry standard Python testing framework
- **pytest-asyncio** - For async FastAPI testing
- **httpx** - HTTP client for API testing (FastAPI recommended)
- **pytest-cov** - Coverage reporting and analysis
- **factory-boy** - Test data generation and fixtures
- **pytest-mock** - Mocking utilities for testing

### Test Organization
```
api/tests/
├── unit/                         # Unit tests by module
│   ├── test_users/
│   ├── test_cases/
│   ├── test_clients/
│   └── test_ai/
├── integration/                  # Integration tests
│   ├── test_api_endpoints/
│   └── test_database/
├── e2e/                         # End-to-end tests
└── fixtures/                    # Shared test data and fixtures
```

## Environment Configuration

### Backend Environment Variables (.env)
```bash
# Database
DATABASE_URL=postgresql://jurisiri:password@localhost:5432/jurisiri_dev
DATABASE_TEST_URL=postgresql://jurisiri:password@localhost:5432/jurisiri_test

# Security
SECRET_KEY=your-secret-key-here
JWT_SECRET_KEY=your-jwt-secret-key
JWT_ACCESS_TOKEN_EXPIRE_MINUTES=15
JWT_REFRESH_TOKEN_EXPIRE_DAYS=7

# AI Integration
OPENAI_API_KEY=your-openai-api-key
AI_MODEL=gpt-4
AI_MAX_TOKENS=1000

# Environment
ENVIRONMENT=development
DEBUG=true
LOG_LEVEL=INFO
```

### Frontend Environment Variables (.env.local)
```bash
# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Environment
NODE_ENV=development
NEXT_PUBLIC_ENVIRONMENT=development
```

## Docker Configuration

### Services
- **PostgreSQL 15**: Main database with persistent volumes
- **Redis**: Caching and session storage (future use)
- **pgAdmin**: Database administration interface (development)

### Volume Management
- Database data persistence
- Easy backup and restore
- Development data isolation

## Development Scripts

### Setup Script (`scripts/setup.sh`)
```bash
#!/bin/bash
# One-command project setup
# - Creates Python virtual environment
# - Installs dependencies
# - Sets up pre-commit hooks
# - Starts Docker services
# - Runs initial database migrations
```

### Development Workflow Scripts
- **dev-start.sh**: Start all development services
- **dev-stop.sh**: Stop all development services
- **db-reset.sh**: Reset database with fresh schema
- **test.sh**: Run complete test suite with coverage
- **lint.sh**: Run all code quality checks

## VSCode Team Configuration

### Recommended Extensions
- Python (Microsoft)
- Pylance (Microsoft)
- Black Formatter
- isort
- GitLens
- Docker
- PostgreSQL (Chris Kolkman)

### Team Settings
- Auto-formatting on save
- Consistent indentation (4 spaces for Python, 2 for TypeScript)
- Integrated terminal configuration
- Debug configurations for FastAPI and Next.js

## Development Workflow

### Daily Development Process
1. `./scripts/dev-start.sh` - Start development environment
2. Activate Python virtual environment
3. Make code changes with auto-formatting
4. Run tests with `./scripts/test.sh`
5. Commit with automatic pre-commit checks
6. `./scripts/dev-stop.sh` - Stop environment when done

### Code Quality Process
- Pre-commit hooks ensure code quality
- Automated testing on every commit
- Coverage reporting for test completeness
- Type checking for code reliability

## Benefits of This Setup

### Developer Experience
- **One-command setup**: New developers productive in minutes
- **Consistent environment**: Same setup across all machines
- **Automated quality**: No manual formatting or linting needed
- **Fast feedback**: Immediate test and lint results

### Team Productivity
- **Standardized tools**: Everyone uses the same configuration
- **Reduced setup time**: Focus on coding, not environment issues
- **Quality assurance**: Automated checks prevent common issues
- **Easy onboarding**: Clear documentation and scripts

### Production Readiness
- **Environment parity**: Development matches production
- **Dependency management**: Locked versions for consistency
- **Security scanning**: Automated security checks
- **Performance monitoring**: Built-in profiling and monitoring

## Implementation Priority

### Phase 1 (This Week)
1. Create Docker configuration files
2. Set up Python environment with dependencies
3. Configure code quality tools
4. Create development scripts
5. Set up VSCode team configuration

### Phase 2 (Next Week)
1. Implement comprehensive testing setup
2. Add CI/CD pipeline integration
3. Set up monitoring and logging
4. Create deployment configurations

---
*Development Environment Plan - Ready for Implementation*
*Date: January 14, 2025*
