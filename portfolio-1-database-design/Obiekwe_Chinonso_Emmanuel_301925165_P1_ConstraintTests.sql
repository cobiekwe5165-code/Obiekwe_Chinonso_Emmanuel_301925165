-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. duplicate site primary key. Expected: pk_campus_site, SQLSTATE 23505.
INSERT INTO portfolio."campus_site" ("site_id", "site_code", "site_name", "building_type")
VALUES (101, 'TEST-SITE-PK', 'Primary Key Test', 'academic');

-- 2. duplicate site code. Expected: uq_campus_site_0, SQLSTATE 23505.
INSERT INTO portfolio."campus_site" ("site_id", "site_code", "site_name", "building_type")
VALUES (10001, 'ECO-N', 'Unique Test Site', 'academic');

-- 3. null site name. Expected: site_name, SQLSTATE 23502.
INSERT INTO portfolio."campus_site" ("site_id", "site_code", "site_name", "building_type")
VALUES (10002, 'TEST-SITE-NN', NULL, 'academic');

-- 4. duplicate meter primary key. Expected: pk_energy_meter, SQLSTATE 23505.
INSERT INTO portfolio."energy_meter" ("meter_id", "meter_code", "site_id", "installed_on", "unit")
VALUES (201, 'TEST-METER-PK', 101, '2025-09-01', 'kWh');

-- 5. duplicate meter code. Expected: uq_energy_meter_0, SQLSTATE 23505.
INSERT INTO portfolio."energy_meter" ("meter_id", "meter_code", "site_id", "installed_on", "unit")
VALUES (10003, 'MTR-N-01', 101, '2025-09-02', 'kWh');

-- 6. missing meter site. Expected: fk_energy_meter_0, SQLSTATE 23503.
INSERT INTO portfolio."energy_meter" ("meter_id", "meter_code", "site_id", "installed_on", "unit")
VALUES (10004, 'TEST-METER-FK', 99991, '2025-09-03', 'kWh');

-- 7. duplicate reading primary key. Expected: pk_energy_reading, SQLSTATE 23505.
INSERT INTO portfolio."energy_reading" ("reading_id", "meter_id", "recorded_at", "energy_kwh", "quality_note")
VALUES (301, 201, '2026-03-01T11:00:00Z', 2.5, NULL);

-- 8. duplicate meter timestamp. Expected: uq_energy_reading_0, SQLSTATE 23505.
INSERT INTO portfolio."energy_reading" ("reading_id", "meter_id", "recorded_at", "energy_kwh", "quality_note")
VALUES (10005, 201, '2026-03-01T10:00:00Z', 3.5, NULL);

-- 9. missing reading meter. Expected: fk_energy_reading_0, SQLSTATE 23503.
INSERT INTO portfolio."energy_reading" ("reading_id", "meter_id", "recorded_at", "energy_kwh", "quality_note")
VALUES (10006, 99992, '2026-03-01T12:00:00Z', 4.5, NULL);

-- 10. negative reading energy. Expected: reading_energy_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."energy_reading" ("reading_id", "meter_id", "recorded_at", "energy_kwh", "quality_note")
VALUES (10007, 201, '2026-03-01T13:00:00Z', -1, NULL);

-- 11. duplicate project primary key. Expected: pk_sustainability_project, SQLSTATE 23505.
INSERT INTO portfolio."sustainability_project" ("project_id", "project_code", "site_id", "start_date", "end_date", "budget")
VALUES (401, 'TEST-PROJECT-PK', 101, '2026-02-01', '2026-10-01', 1000);

-- 12. duplicate project code. Expected: uq_sustainability_project_0, SQLSTATE 23505.
INSERT INTO portfolio."sustainability_project" ("project_id", "project_code", "site_id", "start_date", "end_date", "budget")
VALUES (10008, 'SOLAR-01', 101, '2026-02-02', '2026-10-02', 1200);

-- 13. missing project site. Expected: fk_sustainability_project_0, SQLSTATE 23503.
INSERT INTO portfolio."sustainability_project" ("project_id", "project_code", "site_id", "start_date", "end_date", "budget")
VALUES (10009, 'TEST-PROJECT-FK', 99993, '2026-02-03', '2026-10-03', 1400);

-- 14. negative project budget. Expected: project_budget_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."sustainability_project" ("project_id", "project_code", "site_id", "start_date", "end_date", "budget")
VALUES (10010, 'TEST-PROJECT-CHECK', 101, '2026-02-04', '2026-10-04', -1);
