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
    "stop_sequence" INTEGER NOT NULL,
    PRIMARY KEY("direction", "route_id", "stop_id", "stop_sequence")
  );
SQL

db.execute('SELECT "routes".route_id FROM "routes" WHERE "routes".route_type = 2;').flatten.each do |route_id|
  db.execute <<-SQL
    INSERT INTO "directions" ("direction", "headsign", "route_id")
    SELECT DISTINCT "trips".direction, "trips".headsign, "trips".route_id
    FROM "trips"
    WHERE "trips".route_id = '#{route_id}';
  SQL

  db.execute("SELECT DISTINCT \"trips\".direction FROM \"trips\" WHERE \"trips\".route_id = \"#{route_id}\";").flatten.each do |direction_id|
    db.execute <<-SQL
      INSERT INTO "directions_stops" ("direction", "route_id", "stop_id", "stop_sequence")
      SELECT "trips".direction, "trips".route_id, "stop_times".stop_id, "stop_times".stop_sequence
      FROM "routes"
      INNER JOIN "trips" ON "trips".route_id = "routes".route_id
      INNER JOIN "stop_times" ON "stop_times".trip_id = "trips".trip_id
      WHERE "routes".route_id = "#{route_id}" AND "trips".direction = #{direction_id}
      GROUP BY "stop_times".stop_id
      ORDER BY "stop_times".stop_sequence;
    SQL
  end
end

db.execute <<-SQL
  DROP TABLE "stop_times";
SQL

db.execute <<-SQL
  DROP TABLE "trips";
SQL

db.execute <<-SQL
  VACUUM;
SQL
