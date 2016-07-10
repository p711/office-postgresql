#!/bin/bash
set -e

psql -a -v ON_ERROR_STOP=1 --username "${POSTGRES_USER:-postgres}" <<-EOSQL
    -- Create Gitlab stuff
    CREATE ROLE gitlab with LOGIN CREATEDB PASSWORD '${GITLAB_PASSWORD}';
    CREATE DATABASE gitlabhq_production;
    GRANT ALL PRIVILEGES ON DATABASE gitlabhq_production to gitlab;

    -- Create Mattermost stuff
    CREATE ROLE mattermost with LOGIN CREATEDB PASSWORD '${GITLAB_PASSWORD}';
    CREATE DATABASE mattermost_production;
    GRANT ALL PRIVILEGES ON DATABASE mattermost_production to mattermost;

    -- Create Odoo stuff
    CREATE ROLE odoo with LOGIN CREATEDB PASSWORD '${ODOO_PASSWORD}';
EOSQL

psql -a -v ON_ERROR_STOP=1 --username "${POSTGRES_USER:-postgres}" gitlabhq_production <<-EOSQL
    create extension pg_trgm;
EOSQL


