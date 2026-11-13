-- Portfolio 5: publisher setup for PostgreSQL logical replication.
-- Run only on a disposable publisher test database as an administrator.
-- This resets only the dedicated p5_cloud objects used by this exercise.

DROP PUBLICATION IF EXISTS p5_energy_pub;
DROP SCHEMA IF EXISTS p5_cloud CASCADE;
CREATE SCHEMA p5_cloud;

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

CREATE INDEX p5_energy_reading_site_time_idx
    ON p5_cloud.energy_reading (site_code, recorded_at DESC);

INSERT INTO p5_cloud.campus_site (site_id, site_code, site_name, region) VALUES
    (101, 'ECO-N', 'North Campus', 'North'),
    (102, 'ECO-S', 'South Campus', 'South');

INSERT INTO p5_cloud.energy_reading
    (reading_id, site_code, recorded_at, energy_kwh, quality_note) VALUES
    (301, 'ECO-N', '2026-03-01 10:00:00+00', 12.50, 'verified'),
    (302, 'ECO-N', '2026-03-01 11:00:00+00', 13.20, NULL),
    (303, 'ECO-S', '2026-03-01 10:00:00+00', 8.75, NULL),
    (304, 'ECO-S', '2026-03-02 10:00:00+00', 9.10, NULL);

CREATE PUBLICATION p5_energy_pub
    FOR TABLE p5_cloud.campus_site, p5_cloud.energy_reading;

-- Publisher-side baseline checks.
SELECT 'campus_site' AS table_name, count(*) AS row_count FROM p5_cloud.campus_site
UNION ALL
SELECT 'energy_reading', count(*) FROM p5_cloud.energy_reading
ORDER BY table_name;
