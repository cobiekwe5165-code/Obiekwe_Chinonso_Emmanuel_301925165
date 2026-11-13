# Eco Hub University Management System — SQL queries

## 1. Count energy_reading records for each meter_id (up to 20 groups).

```sql
SELECT "meter_id", count(*) AS record_count
FROM portfolio."energy_reading"
GROUP BY "meter_id"
ORDER BY record_count DESC, "meter_id" NULLS LAST
LIMIT 20;
```

| meter_id | record_count |
| --- | --- |
| 201 | 1 |

## 2. Find energy_reading records where recorded_at matches "2026-03-01T10:00:00Z" (up to 20).

```sql
SELECT * FROM portfolio."energy_reading"
WHERE "recorded_at" IS NOT DISTINCT FROM '2026-03-01T10:00:00Z'
ORDER BY "reading_id"
LIMIT 20;
```

| reading_id | meter_id | recorded_at | energy_kwh | quality_note |
| --- | --- | --- | --- | --- |
| 301 | 201 | 2026-03-01T10:00:00+00:00 | 12.5 | NULL |

## 3. Show related sustainability_project, campus_site records (up to 20).

```sql
SELECT t0."project_id" AS "sustainability_project_project_id",
       t0."project_code" AS "sustainability_project_project_code",
       t1."site_id" AS "campus_site_site_id",
       t1."site_code" AS "campus_site_site_code"
FROM portfolio."sustainability_project" t0
JOIN portfolio."campus_site" t1 ON t0."site_id" = t1."site_id"
ORDER BY t0."project_id", t1."site_id"
LIMIT 20;
```

| sustainability_project_project_id | sustainability_project_project_code | campus_site_site_id | campus_site_site_code |
| --- | --- | --- | --- |
| 401 | SOLAR-01 | 101 | ECO-N |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.491 | 2.476, 2.582, 2.491 | Sort → Seq Scan | 274 |
| After index | 0.298 | 0.298, 0.316, 0.294 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.491 ms to 0.298 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.443..2.446 rows=50 loops=1)
  Seq Scan on energy_reading (actual time=0.015..2.408 rows=50 loops=1)
Planning Time: 0.33 ms
Execution Time: 2.476 ms
```

### Before index, run 2

```text
Sort (actual time=2.546..2.549 rows=50 loops=1)
  Seq Scan on energy_reading (actual time=0.017..2.485 rows=50 loops=1)
Planning Time: 0.331 ms
Execution Time: 2.582 ms
```

### Before index, run 3

```text
Sort (actual time=2.458..2.461 rows=50 loops=1)
  Seq Scan on energy_reading (actual time=0.015..2.421 rows=50 loops=1)
Planning Time: 0.328 ms
Execution Time: 2.491 ms
```

### After index, run 1

```text
Sort (actual time=0.238..0.24 rows=50 loops=1)
  Bitmap Heap Scan on energy_reading (actual time=0.031..0.2 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.016 rows=50 loops=1)
Planning Time: 0.545 ms
Execution Time: 0.298 ms
```

### After index, run 2

```text
Sort (actual time=0.256..0.259 rows=50 loops=1)
  Bitmap Heap Scan on energy_reading (actual time=0.031..0.217 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=50 loops=1)
Planning Time: 0.512 ms
Execution Time: 0.316 ms
```

### After index, run 3

```text
Sort (actual time=0.232..0.235 rows=50 loops=1)
  Bitmap Heap Scan on energy_reading (actual time=0.031..0.195 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.016 rows=50 loops=1)
Planning Time: 0.512 ms
Execution Time: 0.294 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Obiekwe_Chinonso_Emmanuel_301925165_P2_Queries.sql, then Obiekwe_Chinonso_Emmanuel_301925165_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Obiekwe_Chinonso_Emmanuel_301925165_P2_QueryResults.png) · [Index comparison](screenshots/Obiekwe_Chinonso_Emmanuel_301925165_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

