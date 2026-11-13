-- Fictional sample records for Eco Hub University Management System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."campus_site" ("site_id", "site_code", "site_name", "building_type") VALUES (101, 'ECO-N', 'North Hall', 'academic');
INSERT INTO portfolio."energy_meter" ("meter_id", "meter_code", "site_id", "installed_on", "unit") VALUES (201, 'MTR-N-01', 101, '2025-08-15', 'kWh');
INSERT INTO portfolio."sustainability_project" ("project_id", "project_code", "site_id", "start_date", "end_date", "budget") VALUES (401, 'SOLAR-01', 101, '2026-01-15', '2026-12-15', 25000);
INSERT INTO portfolio."energy_reading" ("reading_id", "meter_id", "recorded_at", "energy_kwh", "quality_note") VALUES (301, 201, '2026-03-01T10:00:00Z', 12.5, NULL);
COMMIT;
