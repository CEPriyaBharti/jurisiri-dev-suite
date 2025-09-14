#!/bin/bash

# JuriSiri Development Services Stop Script
# This script stops all development services

echo "🛑 Stopping JuriSiri development services..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Stop Docker services
stop_docker_services() {
    print_status "Stopping Docker services..."

    cd docker

    # Stop all services
    docker compose down

    print_success "All Docker services stopped"

    cd ..
}

# Display completion message
display_completion() {
    echo ""
    echo "✅ All development services have been stopped"
    echo ""
    echo "💡 To start services again:"
    echo "  ./scripts/dev-start.sh"
    echo ""
    echo "🗑️  To clean up Docker volumes (removes all data):"
    echo "  cd docker && docker-compose down -v"
    echo ""
}

# Main execution
main() {
    stop_docker_services
    display_completion
}

main "$@"
