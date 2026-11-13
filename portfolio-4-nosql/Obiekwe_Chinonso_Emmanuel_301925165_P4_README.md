# Portfolio 4 — NoSQL and Advanced Data Models

## Case study

This portfolio models Eco Hub University energy monitoring in MongoDB. The relational design in Portfolio 1 remains the source of truth for the SQL work; this exercise explores a document model for read patterns that need a reading and its campus context together.

## Model and trade-offs

The database uses three collections:

- `campus_sites`: one document per campus site.
- `energy_meters`: one document per meter, referencing its site with `siteId`.
- `energy_readings`: one document per measurement, referencing `meterId` and embedding a small `siteSnapshot` (`siteCode`, `siteName`).

Readings are kept separate rather than embedded in a meter because they can grow without bound. The copied site snapshot makes common reading views self-contained and avoids a lookup, at the cost of possible stale snapshot values if a site's name changes. The script demonstrates the read model and indexes; a production system would update snapshots deliberately or use `$lookup` when current site details are required.

## Run

Requires MongoDB and `mongosh`. From the repository root, run:

```sh
mongosh portfolio-4-nosql/Obiekwe_Chinonso_Emmanuel_301925165_P4_NoSQL.js
```

The script uses the isolated `eco_hub_nosql_p4` database. It removes only documents tagged `portfolio: "P4"` from its three collections before loading its synthetic sample records, so rerunning it resets this exercise's data without dropping the database or unrelated documents.

## What the script demonstrates

1. Collection-level schema validation for the key document fields and BSON types.
2. A hybrid reference/embedding model and sample synthetic data.
3. Indexes for site/time filtering and unique meter/timestamp readings.
4. A time-range query, an aggregation that summarizes energy by site and day, and an `explain("executionStats")` plan.
5. A targeted update of a reading's optional quality note.

The script prints the query results and execution plan when run. Record your own MongoDB version, the printed results, and the relevant `executionStats` (including `nReturned`, `totalKeysExamined`, and `totalDocsExamined`) below; those measurements depend on the MongoDB version and execution environment.

## Results from my run

- MongoDB version: _Run `db.version()` and record the result._
- Time-range query: _Record the returned documents/count._
- Daily aggregation: _Record the returned groups/totals._
- Index plan and execution statistics: _Paste or summarize the actual `explain("executionStats")` output._

## References

- [MongoDB documentation — Model Your Data](https://www.mongodb.com/docs/manual/data-modeling/)
- [MongoDB documentation — Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/)
- [MongoDB documentation — Indexes](https://www.mongodb.com/docs/manual/indexes/)
- [MongoDB documentation — Aggregation Pipeline](https://www.mongodb.com/docs/manual/aggregation/)
