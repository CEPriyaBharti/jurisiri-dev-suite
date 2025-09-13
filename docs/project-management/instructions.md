# JuriSiri Project Instructions & Development Guidelines

## Project Overview
JuriSiri is a legal case management platform with integrated AI assistance. This document contains project-specific development guidelines and preferences for consistent execution.

## Development Philosophy
- **Quality over Speed**: Focus on robust, maintainable code
- **User-Centric Design**: Every feature should solve real advocate pain points
- **Security First**: Legal data requires highest security standards
- **Scalable Architecture**: Build for growth from day one

## Development Workflow

### Git Workflow
- **Main Branch**: Production-ready code only
- **Feature Branches**: `feature/description` format
- **Commit Messages**: Conventional commits format

```bash
# Example commit messages
feat(auth): add JWT refresh token mechanism
fix(cases): resolve case status update bug
docs(api): update authentication endpoints
```

### Code Review Process
1. **Self Review**: Test locally, check code quality
2. **Peer Review**: At least one team member approval
3. **Automated Tests**: All tests must pass
4. **Documentation**: Update relevant docs

## AI Integration Guidelines

### API Usage Best Practices
- **Rate Limiting**: Implement proper rate limiting
- **Error Handling**: Graceful fallbacks for AI failures
- **Cost Monitoring**: Track token usage and costs
- **Context Management**: Efficient prompt engineering

### Security Considerations
- **Data Sanitization**: Clean all inputs before AI processing
- **Output Validation**: Validate AI responses before display
- **Audit Logging**: Log all AI interactions for compliance
- **Privacy**: Never send sensitive client data to external APIs

## Legal Industry Specific Requirements

### Compliance Standards
- **Data Residency**: Consider local data storage requirements
- **Audit Trail**: Complete activity logging for legal requirements
- **Client Confidentiality**: Strict data protection measures
- **Regulatory Compliance**: Follow bar council and legal regulations

### Performance Requirements
- **Response Time**: Sub-second response for critical operations
- **Availability**: 99.9% uptime for production systems
- **Data Backup**: Encrypted daily backups with appropriate retention
- **Disaster Recovery**: Clear recovery procedures

## Communication Preferences

### Code Reviews
- **Constructive Feedback**: Focus on improvement, not criticism
- **Explain Reasoning**: Provide context for suggestions
- **Learn Together**: Share knowledge and best practices
- **Respect Time**: Efficient, focused reviews

### Documentation Updates
- **Keep Current**: Update docs with code changes
- **Clear Examples**: Provide practical examples
- **User Perspective**: Write for the intended audience

## AI Assistant Instructions

When working on this project:
1. **Follow established patterns** in existing code
2. **Prioritize security** in all implementations
3. **Write comprehensive tests** for new features
4. **Update documentation** when adding functionality
5. **Consider performance implications** of changes
6. **Maintain clean, organized code structure**
7. **Provide constructive feedback** and improvement suggestions
8. **Focus on solving real user problems**
9. **Ask for clarification** before making technology assumptions

## Reference Documents
- `@docs/technical/code-standards.md` - Coding standards and best practices
- `@docs/technical/architecture.md` - System architecture guidelines
- `@docs/business/market-analysis.md` - Business context and market understanding

---
*Document created: January 2025*
*Last updated: January 2025*
