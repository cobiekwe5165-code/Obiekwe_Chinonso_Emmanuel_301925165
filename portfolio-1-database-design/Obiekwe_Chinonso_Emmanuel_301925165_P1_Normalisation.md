# Eco Hub University Management System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| meter_id | energy_reading records (list) |
| --- | --- |
| 201 | [301] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| energy_reading.reading_id | energy_reading.meter_id | energy_reading.quality_note | energy_meter.meter_id | energy_meter.meter_code | energy_meter.site_id | campus_site.site_id | campus_site.site_code |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | NULL | 201 | MTR-N-01 | 101 | 101 | ECO-N |

Key: reading_id.

## 2NF: depend on the whole key

energy_reading: meter_id is a proper part of candidate key (meter_id, recorded_at), and determines energy_meter details.

## energy_meter_example

| energy_meter.meter_id | energy_meter.meter_code | energy_meter.site_id | campus_site.site_id | campus_site.site_code |
| --- | --- | --- | --- | --- |
| 201 | MTR-N-01 | 101 | 101 | ECO-N |

## energy_reading_example

| energy_reading.reading_id | energy_reading.meter_id | energy_reading.quality_note |
| --- | --- | --- |
| 301 | 201 | NULL |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## campus_site

| site_id | site_code | site_name | building_type |
| --- | --- | --- | --- |
| 101 | ECO-N | North Hall | academic |

## energy_meter

| meter_id | meter_code | site_id | installed_on | unit |
| --- | --- | --- | --- | --- |
| 201 | MTR-N-01 | 101 | 2025-08-15 | kWh |

## energy_reading

| reading_id | meter_id | recorded_at | energy_kwh | quality_note |
| --- | --- | --- | --- | --- |
| 301 | 201 | 2026-03-01T10:00:00+00:00 | 12.5 | NULL |

## sustainability_project

| project_id | project_code | site_id | start_date | end_date | budget |
| --- | --- | --- | --- | --- | --- |
| 401 | SOLAR-01 | 101 | 2026-01-15 | 2026-12-15 | 25000 |

## Dependencies

- campus_site: (site_id) → site_code, site_name, building_type
- energy_meter: (meter_id) → meter_code, site_id, installed_on, unit
- energy_reading: (reading_id) → meter_id, recorded_at, energy_kwh, quality_note
- sustainability_project: (project_id) → project_code, site_id, start_date, end_date, budget

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
