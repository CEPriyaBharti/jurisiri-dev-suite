#!/bin/bash

# JuriSiri Development Services Start Script
# This script starts all development services

set -e

echo "🚀 Starting JuriSiri development services..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Start Docker services
start_docker_services() {
    print_status "Starting Docker services..."
    
    cd docker
    
    # Start PostgreSQL
    docker-compose up -d postgres
    
    # Wait for PostgreSQL to be ready
    print_status "Waiting for PostgreSQL to be ready..."
    sleep 5
    
    # Check if services are running
    if docker-compose ps postgres | grep -q "Up"; then
        print_success "PostgreSQL is running on port 5432"
    else
        echo "❌ Failed to start PostgreSQL"
        exit 1
    fi
    
    cd ..
}

# Display service information
display_services() {
    echo ""
    echo "🎉 Development services are running!"
    echo ""
    echo "📊 Service URLs:"
    echo "  🗄️  PostgreSQL: localhost:5432"
    echo "  📊 pgAdmin: http://localhost:5050 (admin@jurisiri.com / admin123)"
    echo ""
    echo "🔧 Next steps:"
    echo "  1. Activate Python environment: cd api && source venv/bin/activate"
    echo "  2. Start API server: cd api && uvicorn main:app --reload --host 0.0.0.0 --port 8000"
    echo "  3. Start web server: cd web && npm run dev"
    echo ""
    echo "⚡ Quick commands:"
    echo "  - Stop services: ./scripts/dev-stop.sh"
    echo "  - Reset database: ./scripts/db-reset.sh"
    echo "  - Run tests: ./scripts/test.sh"
    echo ""
}

# Main execution
main() {
    start_docker_services
    display_services
}

main "$@"
