# Eco Hub University Management System — ER diagram

```mermaid
erDiagram
    direction LR
    campus_site {
        bigint site_id PK
        text site_code UK
        text site_name
        text building_type
    }
    energy_meter {
        bigint meter_id PK
        text meter_code UK
        bigint site_id FK
        date installed_on
        text unit
    }
    energy_reading {
        bigint reading_id PK
        bigint meter_id FK
        timestamptz recorded_at
        numeric energy_kwh
        text quality_note "Optional"
    }
    sustainability_project {
        bigint project_id PK
        text project_code UK
        bigint site_id FK
        date start_date
        date end_date "Optional"
        numeric budget
    }
    campus_site ||--o{ energy_meter : "site_id"
    energy_meter ||--o{ energy_reading : "meter_id"
    campus_site ||--o{ sustainability_project : "site_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Obiekwe_Chinonso_Emmanuel_301925165_ERDiagram.png)
