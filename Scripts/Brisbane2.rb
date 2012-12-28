require 'conformist'
require 'csv'
require 'pathname'
require 'sqlite3'

if ARGV[0..1].size != 2
  puts "Usage: [ruby] #{__FILE__} <DIR> <SQLITE>"
  exit
end

dir = Pathname.new File.expand_path(ARGV[0])
db  = SQLite3::Database.new File.expand_path(ARGV[1])

db.execute <<-SQL
  DROP TABLE IF EXISTS "routes";
SQL

db.execute <<-SQL
  CREATE TABLE "routes" (
    "route_id" TEXT NOT NULL PRIMARY KEY UNIQUE,
    "short_name" TEXT NOT NULL,
    "long_name" TEXT NOT NULL,
    "route_type" INTEGER NOT NULL
  );
SQL

db.execute <<-SQL
  DROP TABLE IF EXISTS "trips";
SQL

db.execute <<-SQL
  CREATE TABLE "trips" (
    "trip_id" TEXT NOT NULL PRIMARY KEY UNIQUE,
    "direction" INTEGER NOT NULL,
    "headsign" TEXT NOT NULL,
    "route_id" TEXT NOT NULL,
    FOREIGN KEY ("route_id") REFERENCES "routes" ("route_id") ON DELETE CASCADE
  );
SQL

db.execute <<-SQL
  CREATE INDEX "index_trips_on_route_id" ON "trips" ("route_id");
SQL

db.execute <<-SQL
  DROP TABLE IF EXISTS "stop_times";
SQL

db.execute <<-SQL
  CREATE TABLE "stop_times" (
    "arrival_time" STRING NOT NULL,
    "stop_sequence" INTEGER NOT NULL,
    "stop_id" TEXT NOT NULL,
    "trip_id" INTEGER NOT NULL,
    PRIMARY KEY ("arrival_time", "stop_sequence", "stop_id", "trip_id"),
    FOREIGN KEY ("stop_id") REFERENCES "stops" ("stop_id") ON DELETE RESTRICT,
    FOREIGN KEY ("trip_id") REFERENCES "trips" ("trip_id") ON DELETE CASCADE
  );
SQL

db.execute <<-SQL
  DROP TABLE IF EXISTS "stops";
SQL

db.execute <<-SQL
  CREATE TABLE "stops" (
    "stop_id" TEXT NOT NULL PRIMARY KEY UNIQUE,
    "stop_name" TEXT NOT NULL,
    "stop_lat" REAL NOT NULL,
    "stop_lon" REAL NOT NULL
  );
SQL

routes_csv    = CSV.open dir.join('routes.txt')
routes_schema = Conformist.new do
  column :route_id, 0
  column :short_name, 2
  column :long_name, 3
  column :route_type, 4
end

routes_schema.conform(routes_csv, skip_first: true).each do |route|
  db.execute <<-SQL
    INSERT INTO routes
    (route_id, short_name, long_name, route_type)
    VALUES
    ("#{route.route_id}", "#{route.short_name}", "#{route.long_name}", #{route.route_type});
  SQL
end

trips_csv    = CSV.open dir.join('trips.txt')
trips_schema = Conformist.new do
  column :trip_id, 2
  column :headsign, 3
  column :route_id, 0
end

trips_schema.conform(trips_csv, skip_first: true).each do |trip|
  db.execute <<-SQL
    INSERT INTO trips
    (trip_id, direction, headsign, route_id)
    VALUES
    ("#{trip.trip_id}", 0, "#{trip.headsign}", "#{trip.route_id}");
  SQL
end

stops_csv    = CSV.open dir.join('stops.txt')
stops_schema = Conformist.new do
  column :stop_id, 0
  column :stop_name, 2
  column :stop_lat, 4
  column :stop_lon, 5
end

stops_schema.conform(stops_csv, skip_first: true).each do |stop|
  db.execute <<-SQL
    INSERT INTO stops
    (stop_id, stop_name, stop_lat, stop_lon)
    VALUES
    ("#{stop.stop_id}", "#{stop.stop_name}", #{stop.stop_lat}, #{stop.stop_lon});
  SQL
end

stop_times_csv = CSV.open dir.join('stop_times.txt')
stop_times_schema = Conformist.new do
  column :arrival_time, 1
  column :stop_sequence, 4
  column :stop_id, 3
  column :trip_id, 0
end

stop_times_schema.conform(stop_times_csv, skip_first: true).each do |stop_time|
  db.execute <<-SQL
    INSERT INTO stop_times
    (arrival_time, stop_sequence, stop_id, trip_id)
    VALUES
    ("#{stop_time.arrival_time}", #{stop_time.stop_sequence}, "#{stop_time.stop_id}", "#{stop_time.trip_id}");
  SQL
end
