# Portfolio 1 — Database Design and Modelling

I organised the data into campus_site, energy_meter, energy_reading, sustainability_project. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| campus_site | 1 |
| energy_meter | 1 |
| energy_reading | 1 |
| sustainability_project | 1 |

The 14 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Obiekwe_Chinonso_Emmanuel_301925165_P1_Design.md)
- [ER diagram](Obiekwe_Chinonso_Emmanuel_301925165_P1_ERDiagram.md)
- [Normalisation](Obiekwe_Chinonso_Emmanuel_301925165_P1_Normalisation.md)
- [Schema](Obiekwe_Chinonso_Emmanuel_301925165_P1_Schema.sql)
- [Sample data](Obiekwe_Chinonso_Emmanuel_301925165_P1_SampleData.sql)
- [Constraint tests](Obiekwe_Chinonso_Emmanuel_301925165_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Obiekwe_Chinonso_Emmanuel_301925165_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

