-- node update/insert function
DROP TYPE IF EXISTS aggregate_way CASCADE;
CREATE TYPE aggregate_way AS (geom geometry[], role text[]);
