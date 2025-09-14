# JuriSiri Phase 1 Development Decisions

## Database Architecture - FINALIZED

### Technology Choice: PostgreSQL
**Decision**: PostgreSQL for production, SQLite for initial development
**Reasoning**: 
- ACID compliance essential for legal data integrity
- Strong relational capabilities for advocate-client-case relationships
- Better audit trails and compliance features
- Easy migration from SQLite using SQLAlchemy ORM

### Core Architecture: Organization-First Design
**Decision**: All data scoped under organizations
**Benefits**:
- Future-proof scalability (individual → firms → enterprises)
- Clean data isolation for legal confidentiality
- Natural tenant boundaries for billing and compliance
- Auto-create default organization for individual advocates

### Database Schema (Complete & Unified)

```sql
-- Core organization structure
organizations (
    id, name, type, subscription_plan, created_at
)

-- System users (advocates, admins)
users (
    id, organization_id, email, password_hash, 
    role, name, phone, email_verified, 
    last_login, created_at
)

-- Advocate-specific data
advocates (
    id, user_id, bar_registration, specializations,
    license_number, practice_areas, created_at
)

-- Client users (separate authentication system)
clients (
    id, name, email, phone, password_hash, 
    email_verified, last_login, created_at
)

-- Client-organization relationships (multi-org support)
client_organizations (
    id, client_id, organization_id, advocate_id,
    status, created_at
)

-- Case management
cases (
    id, organization_id, advocate_id, client_id, 
    title, description, status, client_visible, created_at
)

case_updates (
    id, case_id, content, update_type, 
    created_by, client_visible, created_at
)

-- AI integration
ai_sessions (
    id, organization_id, user_id, case_id, 
    session_type, messages, created_at
)

-- Document management
documents (
    id, case_id, name, file_path, 
    client_accessible, uploaded_by, created_at
)

-- Notifications
notifications (
    id, user_id, title, message, type, 
    read_status, created_at
)

-- Authentication & security
refresh_tokens (
    id, user_id, user_type, token_hash, expires_at,
    device_info, ip_address, created_at
)
-- user_type: 'advocate' | 'admin' | 'client'
```

### User Roles & Permissions
- **Advocate**: Full access to organization data, case management, AI features
- **Client**: Limited access to own cases and updates only
- **Admin**: Organization-level administration (future)

### Future Considerations
- **Mobile App**: Client app for case updates (post-demo)
- **Scaling**: Migration to Keycloak for enterprise auth
- **Compliance**: Indian legal data residency requirements

## Project Structure - FINALIZED

### Architecture: Modular Domain-Driven Design
**Decision**: Loosely coupled modules with dependency injection
**Benefits**:
- Each module is self-contained and testable
- Clear separation of concerns
- Easy to scale and maintain
- Perfect for team development

### Backend Structure (api/)
```
api/
├── core/                          # Shared infrastructure
│   ├── config.py                  # Environment settings
│   ├── database.py                # Database connection
│   ├── security.py                # JWT & encryption utilities
│   ├── dependencies.py            # Dependency injection container
│   ├── repository.py              # Base repository class
│   └── exceptions.py              # Custom exceptions
│
├── users/                         # Users + Organizations module
│   ├── models.py                  # User, Organization, Advocate models
│   ├── schemas.py                 # Pydantic schemas (auth, users)
│   ├── repository.py              # User/org database operations
│   ├── service.py                 # User/org business logic
│   └── routes.py                  # Authentication & user endpoints
│
├── clients/                       # Client management module
│   ├── models.py                  # Client model
│   ├── schemas.py                 # Client schemas
│   ├── repository.py              # Client database operations
│   ├── service.py                 # Client business logic
│   └── routes.py                  # Client endpoints
│
├── cases/                         # Case management module
│   ├── models.py                  # Case, CaseUpdate models
│   ├── schemas.py                 # Case schemas
│   ├── repository.py              # Case database operations
│   ├── service.py                 # Case business logic
│   └── routes.py                  # Case endpoints
│
├── ai/                           # AI integration module
│   ├── models.py                  # AISession model
│   ├── schemas.py                 # AI request/response schemas
│   ├── repository.py              # AI session storage
│   ├── service.py                 # AI business logic & OpenAI integration
│   └── routes.py                  # AI endpoints
│
├── documents/                     # Document management module
├── notifications/                 # Notification module
├── tests/                         # Test modules (by domain)
└── main.py                        # FastAPI application entry point
```

### Frontend Structure (web/)
```
web/                               # Next.js frontend (separate)
├── app/                          # Next.js App Router
├── components/                   # React components
├── lib/                         # Frontend utilities
├── hooks/                       # Custom React hooks
├── types/                       # TypeScript types (frontend only)
└── public/                      # Static assets
```

### Key Architectural Decisions:
- **No Shared Code**: Backend and frontend communicate only via APIs
- **Dependency Injection**: Services injected for perfect isolation
- **Base Repository**: All repositories inherit from BaseRepository
- **Users + Organizations**: Combined in single module (logical grouping)
- **Module Communication**: Through dependency injection, not direct imports

### Refactoring Strategy:
- Complete refactor of existing code to match new structure
- Focus on clean architecture for long-term maintainability
- Implement dependency injection from the start

## Authentication & Security Architecture - FINALIZED

### Architecture: Separate User Systems
**Decision**: Separate authentication for system users (advocates/admins) and client users
**Benefits**:
- Different security policies and token expiry times
- Clean separation of concerns
- Easier mobile app integration for clients
- Independent scaling and management

### Database Schema (Authentication)

```sql
-- System users (advocates, admins)
users (
    id, organization_id, email, password_hash, 
    role, name, phone, email_verified, 
    last_login, created_at
)

advocates (
    id, user_id, bar_registration, specializations,
    license_number, practice_areas, created_at
)

-- Client users (separate system)
clients (
    id, name, email, phone, password_hash, 
    email_verified, last_login, created_at
)

client_organizations (
    id, client_id, organization_id, advocate_id,
    status, created_at
)

-- Shared refresh token management
refresh_tokens (
    id, user_id, user_type, token_hash, expires_at,
    device_info, ip_address, created_at
)
-- user_type: 'advocate' | 'admin' | 'client'
```

### JWT Implementation
```
Access Token: 15 minutes (short-lived)
Refresh Token: 7 days (stored securely with device tracking)

System Users JWT: user_id, role, organization_id
Client Users JWT: client_id, accessible_organization_ids[]
```

### Role-Based Permissions
```
ADMIN: Full organization access
├── Manage advocates and organization settings
├── View all cases and clients
├── Billing and subscription management

ADVOCATE: Case-based access within organization
├── Own cases (created by them)
├── Assigned cases (shared to them)
├── Own clients and AI features

CLIENT: Multi-organization access
├── Cases across all associated organizations
├── Organization selection via org_id parameter
├── Read-only access to own case data
```

### Authentication Endpoints
```
# System users (advocates/admins)
POST /auth/advocate/register    # Registration with organization creation
POST /auth/advocate/login       # Login with email/password
POST /auth/advocate/refresh     # Refresh access token
POST /auth/advocate/logout      # Logout and invalidate tokens

# Client users
POST /auth/client/login         # Client login (password-based for demo)
POST /auth/client/refresh       # Refresh client access token
POST /auth/client/logout        # Client logout

# Shared endpoints
GET  /auth/me                   # Get current user information
GET  /client/organizations      # Get client's accessible organizations
```

### Security Features
- Complex password requirements (8+ chars, mixed case, numbers, symbols)
- Device tracking and management via refresh tokens
- Token revocation capabilities for security breaches
- Multi-device login support
- Organization-scoped permissions for data isolation

### Future Enhancements (Post-Demo)
- OTP-based login for clients (phone number + OTP)
- Multi-factor authentication for advocates
- Email verification and password reset flows
- Rate limiting on authentication endpoints

## Next Steps - Phase 1 Part 4
1. Development environment setup and tooling
2. AI integration architecture planning
3. Testing strategy definition

---
*Phase 1 Core Architecture Decisions - Finalized*
*Date: January 14, 2025*
