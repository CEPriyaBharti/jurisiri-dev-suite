#!/bin/bash
set -e

# Step 1: Create Python virtual environment inside api folder
cd "$(dirname "$0")/api"
python3 -m venv venv

# Step 2: Activate venv and install requirements-dev.txt
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements-dev.txt

# Step 3: Install jurisiri-ai in editable mode
pip install -e ../jurisiri-ai

# Step 4: Install npm dependencies in web folder
cd ../web
npm install

# Step 5: Start Docker containers using docker-compose.taml
cd ../docker
docker compose -f docker-compose.yaml up -d
