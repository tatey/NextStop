require 'sqlite3'
require 'fileutils'

if ARGV[0..1].size != 2
  puts "Usage: [ruby] #{__FILE__} <SOURCE> <DESTINATION>"
  exit
end

source = File.expand_path ARGV[0]
dest   = File.expand_path ARGV[1]

FileUtils.cp source, dest

db = SQLite3::Database.new dest

db.execute <<-SQL
  CREATE TABLE "directions" (
    "direction" INTEGER NOT NULL,
    "headsign" TEXT NOT NULL,
    "route_id" TEXT NOT NULL,
    PRIMARY KEY ("direction", "route_id")
  );
SQL

db.execute <<-SQL
  CREATE INDEX "index_directions_on_route_id" ON "directions" ("route_id");
SQL

db.execute <<-SQL
  CREATE TABLE "directions_stops" (
    "direction" INTEGER NOT NULL,
    "route_id" INTENGER NOT NULL,
    "stop_id" TEXT NOT NULL,
    PRIMARY KEY("direction", "route_id", "stop_id")
  );
SQL

db.execute <<-SQL
  INSERT INTO "directions" ("direction", "headsign", "route_id")
  SELECT DISTINCT "trips".direction, "trips".headsign, "trips".route_id
  FROM "trips";
SQL

db.execute <<-SQL
  INSERT INTO "directions_stops" ("direction", "route_id", "stop_id")
  SELECT DISTINCT "trips".direction, "trips".route_id, "stop_times".stop_id
  FROM "stop_times"
  INNER JOIN "trips" ON "trips".trip_id = "stop_times".trip_id
SQL

db.execute <<-SQL
  DROP TABLE "stop_times";
SQL

db.execute <<-SQL
  DROP TABLE "trips";
SQL

db.execute <<-SQL
  VACUUM;
SQL
