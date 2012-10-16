INSERT INTO routes (route_id, short_name, long_name, route_type) VALUES ('PYRMONT1', 'Northern Pyrmont', 'Sydney Test 1', 3);
INSERT INTO routes (route_id, short_name, long_name, route_type) VALUES ('PYRMONT2', 'Centre Pyrmont', 'Sydney Test 2', 3);

INSERT INTO directions (direction, headsign, route_id) VALUES (0, 'outbound', 'PYRMONT1');
INSERT INTO directions (direction, headsign, route_id) VALUES (0, 'outbound', 'PYRMONT2');

INSERT INTO directions_stops (direction, route_id, stop_id) VALUES (0, 'PYRMONT1', 'PYRMONT1');
INSERT INTO directions_stops (direction, route_id, stop_id) VALUES (0, 'PYRMONT2', 'PYRMONT2');

INSERT INTO stops (stop_id, stop_name, stop_lat, stop_lon) VALUES ('PYRMONT1', 'Northern Pyrmont', -33.863879398423684, 151.19326660898435);
INSERT INTO stops (stop_id, stop_name, stop_lat, stop_lon) VALUES ('PYRMONT2', 'Centre Pyrmont', -33.871117521151696, 151.19551966455685);
