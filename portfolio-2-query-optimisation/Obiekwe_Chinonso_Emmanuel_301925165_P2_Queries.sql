-- Count energy_reading records for each meter_id (up to 20 groups).
SELECT "meter_id", count(*) AS record_count
FROM portfolio."energy_reading"
GROUP BY "meter_id"
ORDER BY record_count DESC, "meter_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "meter_id", count(*) AS record_count
FROM portfolio."energy_reading"
GROUP BY "meter_id"
ORDER BY record_count DESC, "meter_id" NULLS LAST
LIMIT 20;

-- Find energy_reading records where recorded_at matches "2026-03-01T10:00:00Z" (up to 20).
SELECT * FROM portfolio."energy_reading"
WHERE "recorded_at" IS NOT DISTINCT FROM '2026-03-01T10:00:00Z'
ORDER BY "reading_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."energy_reading"
WHERE "recorded_at" IS NOT DISTINCT FROM '2026-03-01T10:00:00Z'
ORDER BY "reading_id"
LIMIT 20;

-- Show related sustainability_project, campus_site records (up to 20).
SELECT t0."project_id" AS "sustainability_project_project_id",
       t0."project_code" AS "sustainability_project_project_code",
       t1."site_id" AS "campus_site_site_id",
       t1."site_code" AS "campus_site_site_code"
FROM portfolio."sustainability_project" t0
JOIN portfolio."campus_site" t1 ON t0."site_id" = t1."site_id"
ORDER BY t0."project_id", t1."site_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."project_id" AS "sustainability_project_project_id",
       t0."project_code" AS "sustainability_project_project_code",
       t1."site_id" AS "campus_site_site_id",
       t1."site_code" AS "campus_site_site_code"
FROM portfolio."sustainability_project" t0
JOIN portfolio."campus_site" t1 ON t0."site_id" = t1."site_id"
ORDER BY t0."project_id", t1."site_id"
LIMIT 20;
