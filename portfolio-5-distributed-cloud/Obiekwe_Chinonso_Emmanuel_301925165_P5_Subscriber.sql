-- Portfolio 5: subscriber setup for PostgreSQL logical replication.
-- Run only on the subscriber test database as an administrator.
-- Publisher and subscriber database names must match.

CREATE SCHEMA IF NOT EXISTS p5_cloud;

CREATE TABLE p5_cloud.campus_site (
    site_id bigint PRIMARY KEY,
    site_code text NOT NULL UNIQUE,
    site_name text NOT NULL,
    region text NOT NULL
);

CREATE TABLE p5_cloud.energy_reading (
    reading_id bigint PRIMARY KEY,
    site_code text NOT NULL,
    recorded_at timestamptz NOT NULL,
    energy_kwh numeric(18, 2) NOT NULL CHECK (energy_kwh >= 0),
    quality_note text,
    UNIQUE (site_code, recorded_at)
);

CREATE INDEX IF NOT EXISTS p5_energy_reading_site_time_idx
    ON p5_cloud.energy_reading (site_code, recorded_at DESC);

-- psql prompts for the connection string without embedding a secret in this file.
-- Prefer .pgpass plus TLS certificate verification for password/certificate setup.
\prompt 'Publisher libpq connection string (no password): ' publisher_conn

-- This statement creates a replication slot on the publisher and starts the initial copy.
-- Run once. To restart, first DROP SUBSCRIPTION p5_energy_sub on this subscriber.
CREATE SUBSCRIPTION p5_energy_sub
    CONNECTION :'publisher_conn'
    PUBLICATION p5_energy_pub
    WITH (copy_data = true, create_slot = true, enabled = true);
