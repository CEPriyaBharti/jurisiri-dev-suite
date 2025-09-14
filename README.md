# JuriSiri - Legal Case Management System

A comprehensive legal case management system with AI-powered features for advocates and law firms.

## 🚀 Quick Start

### Prerequisites

- Python 3.12+
- Docker and Docker Compose
- Node.js 18+ (for frontend)
- Git

### Setup

1. **Clone with submodules**

   ```bash
   git clone --recursive <repository-url>
   cd jurisiri-v3

   # If already cloned, initialize submodules
   git submodule update --init --recursive
   ```

2. **One-command setup**

   ```bash
   ./scripts/setup.sh
   ```

3. **Start development**

   ```bash
   ./scripts/dev-start.sh
   ```

4. **Start servers**

   ```bash
   # API server
   cd api && source venv/bin/activate
   uvicorn main:app --reload --port 8000

   # Web server (new terminal)
   cd web && npm run dev
   ```

## 🏗️ Project Structure

```
jurisiri-v3/
├── api/                          # FastAPI backend
│   ├── core/                     # Core infrastructure
│   ├── users/                    # User management
│   ├── clients/                  # Client management
│   ├── cases/                    # Case management
│   ├── ai/                       # AI integration
│   ├── tests/                    # Test suite
│   └── migrations/               # Database migrations
├── web/                          # Next.js frontend
├── docker/                       # Docker configuration
├── scripts/                      # Development scripts
├── docs/                         # Documentation
└── .vscode/                      # VSCode configuration
```

## 🛠️ Development

### Available Scripts

- `./scripts/setup.sh` - Initial project setup
- `./scripts/dev-start.sh` - Start development services
- `./scripts/dev-stop.sh` - Stop development services
- `./scripts/db-reset.sh` - Reset database (coming soon)
- `./scripts/test.sh` - Run tests (coming soon)

### Code Quality

The project uses industry-standard tools for code quality:

- **Black** - Code formatting
- **isort** - Import sorting
- **flake8** - Linting
- **mypy** - Type checking
- **bandit** - Security scanning
- **pre-commit** - Git hooks

### Testing

```bash
cd api
source venv/bin/activate
pytest
```

### Database

- **Development**: PostgreSQL on port 5432
- **Testing**: PostgreSQL on port 5433
- **Admin Interface**: pgAdmin on http://localhost:5050

## 🔧 Configuration

### Environment Variables

#### Backend (api/.env)

- Database connection settings
- JWT configuration
- AI API keys
- Security settings

#### Frontend (web/.env.local)

- API endpoints
- Feature flags
- UI configuration

### Docker Services

- **PostgreSQL**: Main database
- **PostgreSQL Test**: Test database
- **Redis**: Caching (optional)
- **pgAdmin**: Database administration

## 📚 Documentation

- [Phase 1 Decisions](docs/project-management/phase1-decisions.md)
- [Development Environment](docs/project-management/phase1-development-environment.md)
- [Phase 2 Planning](docs/project-management/phase2-planning.md)

## 🏛️ Architecture

### Backend (FastAPI)

- **Modular Design**: Domain-driven architecture
- **Dependency Injection**: Clean separation of concerns
- **Authentication**: JWT with refresh tokens
- **Database**: PostgreSQL with SQLAlchemy ORM
- **AI Integration**: OpenAI API support

### Frontend (Next.js)

- **App Router**: Modern Next.js architecture
- **TypeScript**: Type-safe development
- **Tailwind CSS**: Utility-first styling
- **Component Library**: Reusable UI components

### Database Schema

- **Organizations**: Multi-tenant architecture
- **Users**: Advocates and administrators
- **Clients**: Separate authentication system
- **Cases**: Case management with AI integration
- **Documents**: File management system

## 🔐 Security

- Complex password requirements
- JWT access and refresh tokens
- Device tracking and management
- Role-based access control
- Data encryption and secure storage

## 🚀 Deployment

### Development

```bash
./scripts/dev-start.sh
```

### Production

- Docker containerization
- Environment-specific configurations
- CI/CD pipeline ready
- Monitoring and logging

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a pull request

### Code Style

- Follow PEP 8 for Python
- Use TypeScript for frontend
- Write comprehensive tests
- Document your code

## 📄 License

This project is proprietary software. All rights reserved.

## 🆘 Support

For support and questions:

- Check the documentation in `docs/`
- Review the project structure
- Contact the development team

## 🎯 Roadmap

### Phase 1 ✅

- [x] Database architecture
- [x] Project structure
- [x] Authentication system
- [x] Development environment

### Phase 2 🚧

- [ ] AI integration
- [ ] Core API endpoints
- [ ] Frontend implementation
- [ ] Testing suite

### Phase 3 📋

- [ ] Deployment setup
- [ ] Performance optimization
- [ ] Security hardening
- [ ] Production release

---

**JuriSiri** - Empowering legal professionals with AI-driven case management.
