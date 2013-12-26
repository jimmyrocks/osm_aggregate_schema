z_order, field
5, railway
6, highway: secondary, secondary_link
7, highway: primary, primary_link
8, highway: unclassified, trunk, trunk_link, residential
9, highway: motorway, motorway_link

DROP TABLE render_point;
CREATE TABLE render_point
(
  osm_id bigint,
  tags hstore,
  z_order integer,
  way geometry(Point,900913),
  changeset_id bigint NOT NULL
);

-- Populate render_point table by changeset (this is how it will be updated)


-- View prototype
CREATE VIEW render_osm_point AS
SELECT
  osm_id as osm_id,
  tags -> '%1' as "%1",
  z_order as z_order,
  way as way
FROM
  render_point
WHERE
  exist(tags, '%1')

DROP TABLE render_way;
CREATE TABLE render_way
(
  osm_id bigint,
  tags hstore,
  z_order integer,
  way geometry(Point,900913),
  changeset_id bigint NOT NULL,
  polygon boolean
);

-- View prototype
CREATE VIEW render_osm_point AS
SELECT
  osm_id as osm_id,
  tags -> '%1' as "%1",
  z_order as z_order,
  way as way
FROM
  render_point
WHERE
  exist(tags, '%1')

DROP FUNCTION o2p_calculate_zorder(hstore);
CREATE OR REPLACE FUNCTION o2p_calculate_zorder(
  hstore
) returns integer AS $o2p_calculate_zorder$
DECLARE
  v_tags ALIAS for $1;
  v_zorder integer;
BEGIN
  -- https://github.com/openstreetmap/osm2pgsql/blob/master/style.lua

SELECT
  SUM(calc.order) as z_order
FROM
 (SELECT
  key,
  value,
  CASE
    WHEN key = 'railway' THEN 5
    WHEN key = 'boundary' AND value = 'administrative' THEN 0
    WHEN key = 'bridge' AND value = 'yes' THEN 10
    WHEN key = 'bridge' AND value = 'true' THEN 10
    WHEN key = 'bridge' AND value = '1' THEN 10
    WHEN key = 'tunnel' AND value = 'yes' THEN -10
    WHEN key = 'tunnel' AND value = 'true' THEN -10
    WHEN key = 'tunnel' AND value = '1' THEN -10
    WHEN key = 'highway' AND value = 'minor' THEN 3
    WHEN key = 'highway' AND value = 'road' THEN 3
    WHEN key = 'highway' AND value = 'unclassified' THEN 3
    WHEN key = 'highway' AND value = 'residential' THEN 3
    WHEN key = 'highway' AND value = 'tertiary_link' THEN 4
    WHEN key = 'highway' AND value = 'tertiary' THEN 4
    WHEN key = 'highway' AND value = 'secondary_link' THEN 6
    WHEN key = 'highway' AND value = 'secondary' THEN 6
    WHEN key = 'highway' AND value = 'primary_link' THEN 7
    WHEN key = 'highway' AND value = 'primary' THEN 7
    WHEN key = 'highway' AND value = 'trunk_link' THEN 8
    WHEN key = 'highway' AND value = 'trunk' THEN 8
    WHEN key = 'highway' AND value = 'motorway_link' THEN 9
    WHEN key = 'highway' AND value = 'motorway' THEN 9
    WHEN key = 'layer' THEN 10 * value::integer
    ELSE 0
  END as order
FROM
  each(v_tags)) calc
INTO
  v_zorder;

RETURN v_zorder;
END;
$o2p_calculate_zorder$ LANGUAGE plpgsql;

DROP FUNCTION o2p_calculate_road(hstore);
CREATE OR REPLACE FUNCTION o2p_calculate_road(
  hstore
) returns boolean AS $o2p_calculate_road$
DECLARE
  v_tags ALIAS for $1;
  v_road boolean;
BEGIN
  -- https://github.com/openstreetmap/osm2pgsql/blob/master/style.lua

SELECT
  CASE
    WHEN SUM(isRoad) > 0 THEN true
    ELSE false
  END as road
FROM
 (SELECT
  key,
  value,
  CASE
    WHEN key = 'railway' THEN 1
    WHEN key = 'boundary' AND value = 'administrative' THEN 1
    WHEN key = 'highway' AND value = 'residential' THEN 1
    WHEN key = 'highway' AND value = 'tertiary_link' THEN 1
    WHEN key = 'highway' AND value = 'tertiary' THEN 1
    WHEN key = 'highway' AND value = 'secondary_link' THEN 1
    WHEN key = 'highway' AND value = 'secondary' THEN 1
    WHEN key = 'highway' AND value = 'primary_link' THEN 1
    WHEN key = 'highway' AND value = 'primary' THEN 1
    WHEN key = 'highway' AND value = 'trunk_link' THEN 1
    WHEN key = 'highway' AND value = 'trunk' THEN 1
    WHEN key = 'highway' AND value = 'motorway_link' THEN 1
    WHEN key = 'highway' AND value = 'motorway' THEN 1
    ELSE 0
  END as isRoad
FROM
  each(v_tags)) calc
INTO
  v_road;

RETURN v_road;
END;
$o2p_calculate_road$ LANGUAGE plpgsql;

------------------
-- Nodes to Line
------------------
DROP FUNCTION o2p_calculate_nodes_to_line(bigint[]);
CREATE OR REPLACE FUNCTION o2p_calculate_nodes_to_line(
  bigint[]
) returns geometry AS $o2p_calculate_nodes_to_line$
DECLARE
  v_nodes ALIAS for $1;
  v_line geometry;
BEGIN
-- looks up all the nodes and creates a linestring from them
SELECT
  ST_MakeLine(g.geom)
FROM (
  SELECT
    geom
  FROM
    nodes
    JOIN (
      SELECT 
        unnest(v_nodes) as node
    ) way ON nodes.id = way.node
) g
INTO
  v_line;

-- If it's a closed line, make it into a polygon
-- it also must have 4 points?
--IF v_nodes[1] = v_nodes[array_length(v_nodes, 1)] THEN
--  SELECT ST_MakePolygon(v_line) INTO v_line;
--END IF;

RETURN v_line;
END;
$o2p_calculate_nodes_to_line$ LANGUAGE plpgsql;

--------------------
-- Build Polygon (using relation)
--------------------
-- #way will also apply to relations with type=multipolygon, type=boundary, or type=route; all other relations are ignored by osm2pgsql.
--  Closed ways with area=yes and closed relations with type=multipolygon or type=boundary will be imported as polygons even if no polygon flag is set. Non-closed ways and closed ways with area=no will always be imported as lines
DROP FUNCTION o2p_calculate_polygon(bigint);
CREATE OR REPLACE FUNCTION o2p_calculate_polygon(
  bigint[]
) returns geometry AS $o2p_calculate_polygon$
DECLARE
  v_way_id ALIAS for $1;
  v_poly geometry;
BEGIN
-- Looks at the way id and determines the polygon for it


RETURN v_poly;
END;
$o2p_calculate_polygon$ LANGUAGE plpgsql;



