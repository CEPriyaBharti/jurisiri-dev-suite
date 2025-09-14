-- JuriSiri Database Initialization Script
-- This script sets up the initial database structure

-- Create development database if it doesn't exist
SELECT 'CREATE DATABASE jurisiri_dev'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'jurisiri_dev')\gexec

-- Create test database if it doesn't exist
SELECT 'CREATE DATABASE jurisiri_test'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'jurisiri_test')\gexec

-- Connect to development database
\c jurisiri_dev;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create basic indexes for performance
-- (Detailed schema will be created by SQLAlchemy migrations)

-- Set timezone
SET timezone = 'UTC';

-- Create application user with limited privileges
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'jurisiri_app') THEN
        CREATE ROLE jurisiri_app WITH LOGIN PASSWORD 'jurisiri_app_password';
    END IF;
END
$$;

-- Grant necessary permissions
GRANT CONNECT ON DATABASE jurisiri_dev TO jurisiri_app;
GRANT USAGE ON SCHEMA public TO jurisiri_app;
GRANT CREATE ON SCHEMA public TO jurisiri_app;

-- Connect to test database and set up similar structure
\c jurisiri_test;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
SET timezone = 'UTC';

GRANT CONNECT ON DATABASE jurisiri_test TO jurisiri_app;
GRANT USAGE ON SCHEMA public TO jurisiri_app;
GRANT CREATE ON SCHEMA public TO jurisiri_app;

-- Log initialization completion
\echo 'JuriSiri database initialization completed successfully'
