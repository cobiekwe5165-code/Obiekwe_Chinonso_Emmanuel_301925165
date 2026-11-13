# Eco Hub University Management System — database design

My case study records campus_site, energy_meter, energy_reading, sustainability_project.

## Users

- Facilities staff review energy readings by campus site.
- Sustainability coordinators track project schedules and budgets.

## Main operations

- Record timestamped energy readings for campus meters.
- Find readings for a site within a date range.
- Summarize energy use by site and reporting period.
- Benchmark plan: load 50000 synthetic readings, compare a timestamp-range filter before and after adding a B-tree index on energy_reading.recorded_at, and verify that both plans return equivalent results.

## Entities

| Entity | Information stored |
| --- | --- |
| campus_site | A university location where energy use is monitored or a sustainability project is conducted. |
| energy_meter | A metering device installed at one campus site. |
| energy_reading | A synthetic energy measurement recorded by a campus meter at a specific time. |
| sustainability_project | A campus sustainability initiative associated with a site and tracked by schedule and budget. |

## campus_site

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| site_id | BIGINT | PK | Yes |
| site_code | TEXT | Unique | Yes |
| site_name | TEXT |  | Yes |
| building_type | TEXT |  | Yes |
- Unique key: (site_code).

## energy_meter

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| meter_id | BIGINT | PK | Yes |
| meter_code | TEXT | Unique | Yes |
| site_id | BIGINT | FK | Yes |
| installed_on | DATE |  | Yes |
| unit | TEXT |  | Yes |
- site_id → campus_site.site_id
- Unique key: (meter_code).

## energy_reading

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| reading_id | BIGINT | PK | Yes |
| meter_id | BIGINT | FK | Yes |
| recorded_at | TIMESTAMPTZ |  | Yes |
| energy_kwh | NUMERIC(18,2) |  | Yes |
| quality_note | TEXT |  | No |
- meter_id → energy_meter.meter_id
- Unique key: (meter_id, recorded_at).

## sustainability_project

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| project_id | BIGINT | PK | Yes |
| project_code | TEXT | Unique | Yes |
| site_id | BIGINT | FK | Yes |
| start_date | DATE |  | Yes |
| end_date | DATE |  | No |
| budget | NUMERIC(18,2) |  | Yes |
- site_id → campus_site.site_id
- Unique key: (project_code).

## Relationships and business rules

- Each campus site has a distinct site code.
- Every energy meter must reference an existing campus site.
- A meter can have at most one reading for each recorded timestamp; this constraint also arbitrates concurrent duplicate inserts.
- Recorded energy use must be zero or greater.
- A project budget must be zero or greater.

## Assumptions

- All records and measurements are synthetic; student names and student identifiers are intentionally excluded.
- Primary-key values are allocated from disjoint synthetic identifier ranges so each entity's single-column primary key is globally unique.
- Worked normalisation example: start with an energy-reading record that repeats meter and site details; separate meter details into energy_meter and retain meter_id as a foreign key in energy_reading. The resulting reading-to-meter-to-site chain avoids repeated ancestor roles.
- Each meter has at most one reading at a given timestamp; duplicate meter-and-timestamp pairs are rejected.

