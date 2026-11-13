-- Portfolio 5: run on the subscriber after initial synchronization has begun.
-- Counts may temporarily differ while the asynchronous initial copy catches up.

SELECT 'campus_site' AS table_name, count(*) AS row_count FROM p5_cloud.campus_site
UNION ALL
SELECT 'energy_reading', count(*) FROM p5_cloud.energy_reading
ORDER BY table_name;

SELECT site_code, reading_id, recorded_at, energy_kwh
FROM p5_cloud.energy_reading
ORDER BY recorded_at, reading_id;

-- Subscription worker state and latest receive/apply timestamps.
SELECT subname,
       pid,
       received_lsn,
       latest_end_lsn,
       latest_end_time
FROM pg_stat_subscription
WHERE subname = 'p5_energy_sub';

-- Per-table synchronization state; 'r' means ready after the initial copy.
SELECT s.subname, sr.srrelid::regclass AS replicated_table, sr.srsubstate
FROM pg_subscription_rel AS sr
JOIN pg_subscription AS s ON s.oid = sr.srsubid
WHERE s.subname = 'p5_energy_sub'
ORDER BY replicated_table;

-- Optional publisher-side check (run on publisher, not subscriber):
-- SELECT slot_name, active, restart_lsn FROM pg_replication_slots WHERE slot_name = 'p5_energy_sub';
