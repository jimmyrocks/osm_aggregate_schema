DROP FUNCTION o2p_osm_grid(geometry,
  integer,
  integer);
CREATE OR REPLACE FUNCTION o2p_osm_grid(
  geometry,
  integer,
  integer
) RETURNS setof text array as $o2p_osm_grid$
  DECLARE
    v_in_bbox ALIAS FOR $1;
    v_width ALIAS FOR $2;
    v_height ALIAS FOR $3;
    v_bbox geometry;
    v_xmax float; v_xmin float; v_ymax float; v_ymin float;
    v_grid text array;
  BEGIN
    select ST_transform(v_in_bbox, 900913) into v_bbox;
    select st_xmax(v_bbox) into v_xmax;
    select st_xmin(v_bbox) into v_xmin;
    select st_ymax(v_bbox) into v_ymax;
    select st_ymin(v_bbox) into v_ymin;
for v_grid in 
WITH bbox_geoms AS (
SELECT * FROM (
SELECT osm_id, name, highway, z_order, way, 'line' as datatype
FROM planet_osm_line
UNION
SELECT osm_id, name, highway, z_order, way, 'polygon' as datatype
FROM planet_osm_polygon
UNION
SELECT osm_id, name, highway, z_order * 2 as "z_order", way, 'point' as datatype
FROM planet_osm_point
) g WHERE way && v_bbox and st_intersects(way, v_bbox))
SELECT row FROM (SELECT (
SELECT
  array_agg((select 
    osm_id
   from
    bbox_geoms
   where
    way && ST_MakeEnvelope(
    v_xmin + (((v_xmax - v_xmin)/v_width::float) * a)::float,
    v_ymax - (((v_ymax - v_ymin)/v_height::float) * b)::float,
    v_xmin + (((v_xmax - v_xmin)/v_width::float) * (a+1))::float,
    v_ymax - (((v_ymax - v_ymin)/v_height::float) * (b+1))::float,
    900913) AND ST_intersects(way, ST_MakeEnvelope(
    v_xmin + (((v_xmax - v_xmin)/v_width::float) * a)::float,
    v_ymax - (((v_ymax - v_ymin)/v_height::float) * b)::float,
    v_xmin + (((v_xmax - v_xmin)/v_width::float) * (a+1))::float,
    v_ymax - (((v_ymax - v_ymin)/v_height::float) * (b+1))::float,
    900913))
   and
    osm_id is not null
   order by
    z_order desc
   limit 1))
 FROM
 generate_series(0,v_width-1) a) as "row"
FROM
 generate_series(0,v_height-1) b order by b) h
loop
return next v_grid;
end loop;

 --RETURN NEXT v_grid;
 END;
 $o2p_osm_grid$ LANGUAGE plpgsql;

 SELECT * FROM o2p_osm_grid(st_transform(ST_MakeEnvelope(-75.555221,39.749834,-75.554800,39.750106, 4326), 900913), 8, 8);
