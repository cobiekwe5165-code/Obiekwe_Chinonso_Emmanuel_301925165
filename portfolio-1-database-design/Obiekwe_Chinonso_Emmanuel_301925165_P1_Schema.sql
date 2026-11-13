-- Eco Hub University Management System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."campus_site" (
  "site_id" bigint NOT NULL,
  "site_code" text NOT NULL,
  "site_name" text NOT NULL,
  "building_type" text NOT NULL,
  CONSTRAINT "pk_campus_site" PRIMARY KEY ("site_id"),
  CONSTRAINT "uq_campus_site_0" UNIQUE ("site_code")
);
CREATE TABLE portfolio."energy_meter" (
  "meter_id" bigint NOT NULL,
  "meter_code" text NOT NULL,
  "site_id" bigint NOT NULL,
  "installed_on" date NOT NULL,
  "unit" text NOT NULL,
  CONSTRAINT "pk_energy_meter" PRIMARY KEY ("meter_id"),
  CONSTRAINT "uq_energy_meter_0" UNIQUE ("meter_code")
);
CREATE TABLE portfolio."energy_reading" (
  "reading_id" bigint NOT NULL,
  "meter_id" bigint NOT NULL,
  "recorded_at" timestamptz NOT NULL,
  "energy_kwh" numeric(18,2) NOT NULL,
  "quality_note" text,
  CONSTRAINT "pk_energy_reading" PRIMARY KEY ("reading_id"),
  CONSTRAINT "uq_energy_reading_0" UNIQUE ("meter_id", "recorded_at")
);
CREATE TABLE portfolio."sustainability_project" (
  "project_id" bigint NOT NULL,
  "project_code" text NOT NULL,
  "site_id" bigint NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date,
  "budget" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_sustainability_project" PRIMARY KEY ("project_id"),
  CONSTRAINT "uq_sustainability_project_0" UNIQUE ("project_code")
);
ALTER TABLE portfolio."energy_meter" ADD CONSTRAINT "fk_energy_meter_0" FOREIGN KEY ("site_id") REFERENCES portfolio."campus_site" ("site_id");
ALTER TABLE portfolio."energy_reading" ADD CONSTRAINT "fk_energy_reading_0" FOREIGN KEY ("meter_id") REFERENCES portfolio."energy_meter" ("meter_id");
ALTER TABLE portfolio."sustainability_project" ADD CONSTRAINT "fk_sustainability_project_0" FOREIGN KEY ("site_id") REFERENCES portfolio."campus_site" ("site_id");
ALTER TABLE portfolio."energy_reading" ADD CONSTRAINT "reading_energy_nonnegative" CHECK ("energy_kwh" >= 0);
ALTER TABLE portfolio."sustainability_project" ADD CONSTRAINT "project_budget_nonnegative" CHECK ("budget" >= 0);
COMMIT;
