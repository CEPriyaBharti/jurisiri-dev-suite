#!/bin/bash

# JuriSiri Development Environment Setup Script
# This script sets up the complete development environment

set -e  # Exit on any error

echo "🚀 Setting up JuriSiri development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Python 3.12 is available
check_python() {
    print_status "Checking Python 3.12 installation..."
    if command -v python3.12 &> /dev/null; then
        PYTHON_CMD="python3.12"
        print_success "Python 3.12 found"
    elif command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
        if [[ "$PYTHON_VERSION" == "3.12" ]]; then
            PYTHON_CMD="python3"
            print_success "Python 3.12 found as python3"
        else
            print_error "Python 3.12 not found. Current version: $PYTHON_VERSION"
            print_error "Please install Python 3.12 before continuing."
            exit 1
        fi
    else
        print_error "Python not found. Please install Python 3.12."
        exit 1
    fi
}

# Check if Docker is available
check_docker() {
    print_status "Checking Docker installation..."
    if ! command -v docker &> /dev/null; then
        print_error "Docker not found. Please install Docker before continuing."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose not found. Please install Docker Compose before continuing."
        exit 1
    fi
    
    print_success "Docker and Docker Compose found"
}

# Set up Python virtual environment
setup_python_env() {
    print_status "Setting up Python virtual environment..."
    
    cd api
    
    # Create virtual environment if it doesn't exist
    if [ ! -d "venv" ]; then
        print_status "Creating virtual environment..."
        $PYTHON_CMD -m venv venv
        print_success "Virtual environment created"
    else
        print_warning "Virtual environment already exists"
    fi
    
    # Activate virtual environment
    source venv/bin/activate
    
    # Upgrade pip
    print_status "Upgrading pip..."
    pip install --upgrade pip
    
    # Install dependencies if requirements files exist
    if [ -f "requirements.txt" ]; then
        print_status "Installing production dependencies..."
        pip install -r requirements.txt
    fi
    
    if [ -f "requirements-dev.txt" ]; then
        print_status "Installing development dependencies..."
        pip install -r requirements-dev.txt
    fi
    
    cd ..
    print_success "Python environment setup completed"
}

# Set up Docker services
setup_docker() {
    print_status "Setting up Docker services..."
    
    cd docker
    
    # Pull Docker images
    print_status "Pulling Docker images..."
    docker-compose pull
    
    # Start PostgreSQL service
    print_status "Starting PostgreSQL service..."
    docker-compose up -d postgres
    
    # Wait for PostgreSQL to be ready
    print_status "Waiting for PostgreSQL to be ready..."
    sleep 10
    
    # Check if PostgreSQL is running
    if docker-compose ps postgres | grep -q "Up"; then
        print_success "PostgreSQL is running"
    else
        print_error "Failed to start PostgreSQL"
        exit 1
    fi
    
    cd ..
    print_success "Docker services setup completed"
}

# Set up pre-commit hooks
setup_precommit() {
    print_status "Setting up pre-commit hooks..."
    
    cd api
    source venv/bin/activate
    
    if command -v pre-commit &> /dev/null; then
        if [ -f ".pre-commit-config.yaml" ]; then
            pre-commit install
            print_success "Pre-commit hooks installed"
        else
            print_warning "Pre-commit config not found, skipping..."
        fi
    else
        print_warning "Pre-commit not installed, skipping hooks setup..."
    fi
    
    cd ..
}

# Create environment files from templates
setup_env_files() {
    print_status "Setting up environment files..."
    
    # Backend environment file
    if [ ! -f "api/.env" ] && [ -f "api/.env.example" ]; then
        cp api/.env.example api/.env
        print_success "Created api/.env from template"
    elif [ ! -f "api/.env" ]; then
        print_warning "No api/.env.example found, skipping backend env setup"
    fi
    
    # Frontend environment file
    if [ ! -f "web/.env.local" ] && [ -f "web/.env.example" ]; then
        cp web/.env.example web/.env.local
        print_success "Created web/.env.local from template"
    elif [ ! -f "web/.env.local" ]; then
        print_warning "No web/.env.example found, skipping frontend env setup"
    fi
}

# Install frontend dependencies
setup_frontend() {
    print_status "Setting up frontend dependencies..."
    
    if [ -d "web" ]; then
        cd web
        
        if [ -f "package.json" ]; then
            if command -v pnpm &> /dev/null; then
                print_status "Installing dependencies with pnpm..."
                pnpm install
            elif command -v npm &> /dev/null; then
                print_status "Installing dependencies with npm..."
                npm install
            else
                print_error "Neither pnpm nor npm found. Please install Node.js and npm."
                exit 1
            fi
            print_success "Frontend dependencies installed"
        else
            print_warning "No package.json found in web directory"
        fi
        
        cd ..
    else
        print_warning "Web directory not found, skipping frontend setup"
    fi
}

# Display setup completion message
display_completion() {
    echo ""
    echo "🎉 JuriSiri development environment setup completed!"
    echo ""
    echo "📋 Next steps:"
    echo "  1. Start development services: ./scripts/dev-start.sh"
    echo "  2. Activate Python environment: cd api && source venv/bin/activate"
    echo "  3. Run database migrations: ./scripts/db-migrate.sh"
    echo "  4. Start the API server: cd api && uvicorn main:app --reload"
    echo "  5. Start the web server: cd web && npm run dev"
    echo ""
    echo "🔧 Useful commands:"
    echo "  - View database: http://localhost:5050 (pgAdmin)"
    echo "  - Stop services: ./scripts/dev-stop.sh"
    echo "  - Reset database: ./scripts/db-reset.sh"
    echo "  - Run tests: ./scripts/test.sh"
    echo ""
    echo "📚 Documentation: docs/project-management/"
    echo ""
}

# Main execution
main() {
    echo "Starting JuriSiri development environment setup..."
    echo "This will set up Python virtual environment, Docker services, and dependencies."
    echo ""
    
    check_python
    check_docker
    setup_env_files
    setup_docker
    setup_python_env
    setup_frontend
    setup_precommit
    
    display_completion
}

# Run main function
main "$@"
