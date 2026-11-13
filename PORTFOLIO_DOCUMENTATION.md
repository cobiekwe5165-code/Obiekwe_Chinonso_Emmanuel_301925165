# MIT 8103 Database Portfolio Documentation

**Student:** Chinonso Emmanuel Obiekwe  
**Student ID:** 301925165  
**Selected case study:** Eco Hub University Management System — campus energy monitoring and sustainability  
**Repository:** [github.com/cobiekwe5165-code/Obiekwe_Chinonso_Emmanuel_301925165](https://github.com/cobiekwe5165-code/Obiekwe_Chinonso_Emmanuel_301925165)

## Introduction

This portfolio presents five connected database activities for the Eco Hub University Management System. The case study focuses on information needed to monitor energy use across university sites, meters and readings, alongside sustainability projects. A relational PostgreSQL design provides the foundation for the SQL activities. The later activities build on that foundation to explore query performance, transaction safety, document databases, and a distributed/cloud database pattern.

Together, the activities demonstrate a progression from designing reliable data structures to considering how data is queried, updated concurrently, represented in a NoSQL system, and made available across database instances. The repository contains activity-specific documentation and scripts. Where an activity requires a live service or execution evidence, the activity README identifies the relevant setup and evidence requirements; the scripts should not be mistaken for proof of a cloud deployment or execution in an environment where that has not been performed.

## Case study and data scope

Eco Hub University is the selected organisation and the portfolio's fictional case study. Its energy-monitoring scenario involves campus sites, energy meters installed at those sites, timestamped energy readings, and sustainability projects associated with campuses. The data model is designed to support operational questions such as which site a meter belongs to, what energy was recorded at a particular time, and how campus projects relate to the university's sustainability work. The sample records are for demonstration and do not represent actual university operational data.

The five activities share this context but examine different database concerns. The relational activities use PostgreSQL. Portfolio 4 models the same monitoring domain in MongoDB, while Portfolio 5 demonstrates PostgreSQL logical replication between a writable publisher and a separate subscriber.

## Portfolio activities

### 1. Database design and modelling

The first activity defines the relational data model for the case study. It separates information into four core tables: `campus_site`, `energy_meter`, `energy_reading`, and `sustainability_project`. The design documentation describes table attributes, primary and foreign keys, relationships, and business rules. An entity-relationship diagram communicates how the entities connect, and a normalisation discussion explains the organisation of the data to reduce unnecessary duplication and update anomalies.

The activity includes PostgreSQL schema creation, sample data, and constraint tests. Constraints are used to protect data quality and enforce valid relationships and values. The recorded test summary reports one sample row in each core table and 14 deliberately invalid inserts rejected by their expected constraints. This activity establishes the schema used as the basis for the later relational exercises.

### 2. Query optimisation

The second activity uses SQL queries to retrieve and relate energy and sustainability data. Examples include counting readings by meter, finding readings at a specific timestamp, and joining a sustainability project to its campus site. The focus then shifts to measuring and improving a filtered query using PostgreSQL execution plans and an index.

The activity reports three timing runs before and after indexing. In the documented comparison, median execution time changed from 2.491 ms before the index to 0.298 ms after it, with the plan changing from a sequential scan to a bitmap index scan and bitmap heap scan. The result illustrates how an index can reduce work for a selective query. It also recognises the trade-off: indexes consume storage and add maintenance cost to writes, and measurements depend on the test data and environment.

### 3. Transactions and concurrency

The third activity examines how PostgreSQL transactions protect data and what can go wrong when two sessions update a shared value at the same time. A temporary processing counter associated with an energy-reading record is used to demonstrate transaction visibility and rollback without changing the business fields of the sample record.

The commit/rollback exercise shows that an uncommitted update is not visible to another session under READ COMMITTED, a committed change remains in place, and a constraint error aborts a transaction so its changes can be rolled back. The two-session exercise compares a basic read-calculate-write approach with `SELECT ... FOR UPDATE`. Without a row lock, both sessions can read the same initial value and overwrite one another, losing an increment. Locking the row makes the second session wait and then work from the updated value. Separate SQL scripts guide the two sessions through the scenario.

### 4. NoSQL and advanced data models

The fourth activity models Eco Hub University's energy-monitoring data in MongoDB. It uses three collections: `campus_sites`, `energy_meters`, and `energy_readings`. Meters refer to sites, and readings refer to meters while embedding a small site snapshot. This hybrid reference-and-embedding design keeps potentially unbounded readings separate from meter documents, while allowing common reading views to include selected site details without an additional lookup. The snapshot duplicates a limited amount of data, so changes to site information may require a deliberate update strategy.

The `mongosh` script demonstrates collection validation, synthetic sample records, indexes for site/time queries and unique meter/timestamp readings, a time-range query, daily energy aggregation, an execution plan, and a targeted update. The activity documentation asks the user to record the MongoDB version, actual query output, and execution statistics when running the script. Those environment-specific results should be filled in from a real run rather than inferred from the script.

### 5. Distributed and cloud databases

The fifth activity prepares a two-instance PostgreSQL logical-replication pattern. One database acts as the publisher and owns writes; a separately hosted subscriber receives published row changes and can serve read traffic such as reporting. The scripts create and seed publisher-side tables, define a publication, prepare matching subscriber tables and a subscription, and provide verification queries for row counts, sample readings, and subscription status.

This activity highlights the benefits and operational considerations of asynchronous replication. It can offload reads and make a separate read copy available, but the subscriber may briefly lag behind the publisher. The design keeps writes on one publisher to avoid multi-primary conflicts. The runbook also covers PostgreSQL configuration, network access, least-privilege replication credentials, monitoring, and the need to coordinate schema changes because logical replication does not automatically replicate DDL. The supplied documentation explicitly describes the setup as prepared for execution on two PostgreSQL instances; it does not claim that a cloud service was connected or that the scripts were run in that environment.

## Repository and use

The complete portfolio, including activity documentation, SQL and JavaScript scripts, and available evidence directories, is available here:

**[Open the GitHub repository](https://github.com/cobiekwe5165-code/Obiekwe_Chinonso_Emmanuel_301925165)**

Each activity is stored in its own folder: `portfolio-1-database-design`, `portfolio-2-query-optimisation`, `portfolio-3-transactions-concurrency`, `portfolio-4-nosql`, and `portfolio-5-distributed-cloud`. Consult the README in each folder for its prerequisites and execution order. Use a disposable test database or isolated test environment when running scripts, especially those that create, drop, or replace activity-specific data. Capture actual execution output where required so that evidence reflects the database version and environment used.

## Conclusion

The five activities present a coherent database portfolio based on one campus energy-monitoring case study. They cover relational modelling and integrity, practical query tuning, transaction correctness under concurrent access, document-oriented modelling, and a publisher-subscriber replication architecture. The work connects database design decisions to data quality, performance, consistency, and operational needs, while distinguishing documented examples and prepared scripts from results that require execution in a specific environment.
