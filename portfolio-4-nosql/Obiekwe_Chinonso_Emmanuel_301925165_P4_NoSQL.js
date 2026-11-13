// Eco Hub University NoSQL portfolio — run with mongosh.
// This script only resets documents marked portfolio: "P4" in its dedicated database.
const p4db = db.getSiblingDB("eco_hub_nosql_p4");

function ensureCollection(name, validator) {
  if (p4db.getCollectionInfos({ name }).length === 0) {
    p4db.createCollection(name, {
      validator,
      validationLevel: "strict",
      validationAction: "error"
    });
  }
}

ensureCollection("campus_sites", {
  $jsonSchema: {
    bsonType: "object",
    required: ["portfolio", "siteId", "siteCode", "siteName", "buildingType"],
    properties: {
      portfolio: { bsonType: "string" },
      siteId: { bsonType: "int" },
      siteCode: { bsonType: "string" },
      siteName: { bsonType: "string" },
      buildingType: { bsonType: "string" }
    }
  }
});

ensureCollection("energy_meters", {
  $jsonSchema: {
    bsonType: "object",
    required: ["portfolio", "meterId", "meterCode", "siteId", "installedOn", "unit"],
    properties: {
      portfolio: { bsonType: "string" },
      meterId: { bsonType: "int" },
      meterCode: { bsonType: "string" },
      siteId: { bsonType: "int" },
      installedOn: { bsonType: "date" },
      unit: { bsonType: "string" }
    }
  }
});

ensureCollection("energy_readings", {
  $jsonSchema: {
    bsonType: "object",
    required: ["portfolio", "readingId", "meterId", "recordedAt", "energyKwh", "siteSnapshot"],
    properties: {
      portfolio: { bsonType: "string" },
      readingId: { bsonType: "int" },
      meterId: { bsonType: "int" },
      recordedAt: { bsonType: "date" },
      energyKwh: { bsonType: ["double", "decimal", "int", "long"], minimum: 0 },
      qualityNote: { bsonType: ["string", "null"] },
      siteSnapshot: {
        bsonType: "object",
        required: ["siteCode", "siteName"],
        properties: {
          siteCode: { bsonType: "string" },
          siteName: { bsonType: "string" }
        }
      }
    }
  }
});

const sites = p4db.getCollection("campus_sites");
const meters = p4db.getCollection("energy_meters");
const readings = p4db.getCollection("energy_readings");

// Idempotently reset only this portfolio's tagged sample documents.
sites.deleteMany({ portfolio: "P4" });
meters.deleteMany({ portfolio: "P4" });
readings.deleteMany({ portfolio: "P4" });

sites.insertMany([
  { portfolio: "P4", siteId: 101, siteCode: "ECO-N", siteName: "North Campus", buildingType: "Academic" },
  { portfolio: "P4", siteId: 102, siteCode: "ECO-S", siteName: "South Campus", buildingType: "Residential" }
]);

meters.insertMany([
  { portfolio: "P4", meterId: 201, meterCode: "MTR-N-01", siteId: 101, installedOn: ISODate("2025-01-15T00:00:00Z"), unit: "kWh" },
  { portfolio: "P4", meterId: 202, meterCode: "MTR-S-01", siteId: 102, installedOn: ISODate("2025-02-01T00:00:00Z"), unit: "kWh" }
]);

readings.insertMany([
  { portfolio: "P4", readingId: 301, meterId: 201, recordedAt: ISODate("2026-03-01T10:00:00Z"), energyKwh: 12.5, siteSnapshot: { siteCode: "ECO-N", siteName: "North Campus" } },
  { portfolio: "P4", readingId: 302, meterId: 201, recordedAt: ISODate("2026-03-01T11:00:00Z"), energyKwh: 13.2, siteSnapshot: { siteCode: "ECO-N", siteName: "North Campus" } },
  { portfolio: "P4", readingId: 303, meterId: 202, recordedAt: ISODate("2026-03-01T10:00:00Z"), energyKwh: 8.75, siteSnapshot: { siteCode: "ECO-S", siteName: "South Campus" } },
  { portfolio: "P4", readingId: 304, meterId: 202, recordedAt: ISODate("2026-03-02T10:00:00Z"), energyKwh: 9.1, siteSnapshot: { siteCode: "ECO-S", siteName: "South Campus" } }
]);

// The compound unique index enforces one reading per meter at each timestamp
// and supports the meter/time access pattern. The second index supports campus reports.
readings.createIndex({ meterId: 1, recordedAt: 1 }, { unique: true, name: "uq_meter_recorded_at" });
readings.createIndex({ "siteSnapshot.siteCode": 1, recordedAt: -1 }, { name: "ix_site_recorded_at" });

print("MongoDB version: " + p4db.version());
print("Readings in the sample time range:");
readings.find({
  portfolio: "P4",
  recordedAt: {
    $gte: ISODate("2026-03-01T00:00:00Z"),
    $lt: ISODate("2026-03-02T00:00:00Z")
  }
}, { _id: 0, readingId: 1, meterId: 1, recordedAt: 1, energyKwh: 1, siteSnapshot: 1 })
  .sort({ recordedAt: 1, readingId: 1 })
  .forEach(printjson);

print("Daily energy totals by site:");
readings.aggregate([
  { $match: { portfolio: "P4" } },
  {
    $group: {
      _id: {
        siteCode: "$siteSnapshot.siteCode",
        day: { $dateTrunc: { date: "$recordedAt", unit: "day", timezone: "UTC" } }
      },
      totalKwh: { $sum: "$energyKwh" },
      readingCount: { $sum: 1 }
    }
  },
  { $sort: { "_id.day": 1, "_id.siteCode": 1 } }
]).forEach(printjson);

print("Explain plan for the site and time-range query:");
printjson(readings.find({
  portfolio: "P4",
  "siteSnapshot.siteCode": "ECO-N",
  recordedAt: {
    $gte: ISODate("2026-03-01T00:00:00Z"),
    $lt: ISODate("2026-03-02T00:00:00Z")
  }
}).sort({ recordedAt: -1 }).explain("executionStats"));

// Demonstrate a targeted document update (optional field, absent in initial reading).
readings.updateOne(
  { portfolio: "P4", readingId: 301 },
  { $set: { qualityNote: "verified" } }
);
print("Updated sample reading:");
printjson(readings.findOne({ portfolio: "P4", readingId: 301 }, { _id: 0 }));
