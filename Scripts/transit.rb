require 'sqlite3'

db = SQLite3::Database.new ARGV[0]

db.execute <<-SQL
  ALTER TABLE services
  RENAME TO services_old;
SQL

db.execute <<-SQL
  DROP INDEX index_services_stop;
SQL

db.execute <<-SQL
  DROP INDEX index_services_route;
SQL

db.execute <<-SQL
  CREATE TABLE services(
    id INTEGER NOT NULL PRIMARY KEY,
    time TIMESTAMP,
    stop_id INTEGER NOT NULL,
    trip_id INTEGER NOT NULL
  );
SQL

db.execute <<-SQL
  CREATE INDEX index_services_stop ON services(stop_id);
SQL

db.execute <<-SQL
  CREATE INDEX index_services_trip ON services(trip_id);
SQL

db.execute <<-SQL
  INSERT INTO services
  (id, time, stop_id, trip_id)
  SELECT id, time, stop_id, route_id FROM
  services_old;
SQL

db.execute <<-SQL
  DROP TABLE services_old;
SQL

db.execute <<-SQL
  ALTER TABLE routes
  RENAME to trips_old;
SQL

db.execute <<-SQL
  CREATE TABLE routes (
    id INTEGER NOT NULL PRIMARY KEY,
    short_name VARCHAR(50),
    long_name VARCHAR(100)
  );
SQL

db.execute('SELECT code, name FROM trips_old;').group_by { |trip| trip[0] }.each do |pair|
  short_name = pair[0]
  long_name1 = pair[1][0][1]
  long_name2 = pair[1][1] ? "\n#{pair[1][1][1]}" : ''
  db.execute <<-SQL
    INSERT INTO routes
    (short_name, long_name)
    VALUES
    ('#{short_name}', '#{long_name1 + long_name2}');
  SQL
end

db.execute <<-SQL
  CREATE TABLE trips(
    id INTEGER NOT NULL PRIMARY KEY,
    short_name VARCHAR(25),
    long_name VARCHAR(100),
    heading VARCHAR(25),
    route_id INTEGER NOT NULL
  );
SQL

db.execute <<-SQL
  CREATE INDEX index_trips_route ON trips(route_id);
SQL

db.execute <<-SQL
  INSERT INTO trips
  (id, short_name, long_name, heading, route_id)
  SELECT o.id, o.code, o.name, o.direction, r.id
  FROM trips_old o
  INNER JOIN routes r ON r.short_name = o.code;
SQL

db.execute <<-SQL
  DROP TABLE trips_old;
SQL
