--DROP FUNCTION o2p_aggregate_polygon_relation(bigint);
CREATE OR REPLACE FUNCTION o2p_aggregate_polygon_relation(
  bigint
) returns geometry[] AS $o2p_aggregate_polygon_relation$
DECLARE
  v_rel_id ALIAS for $1;
  v_polygons geometry[];
BEGIN

SELECT
  array_agg(polygon) polygons
FROM (
  SELECT
    CASE
      WHEN holes[1] IS NULL THEN st_makepolygon(shell)
      ELSE st_makepolygon(shell, holes)
    END polygon
  FROM (
    SELECT
      outside.line AS shell,
      array_agg(inside.line) AS holes
    FROM (
      SELECT
        geom as line,
        role
      FROM
        (SELECT unnest(geom) as geom, unnest(role) as role from o2p_aggregate_relation(v_rel_id)) out_sub
      WHERE
        role != 'inner' AND
        ST_IsClosed(geom)
    ) outside LEFT OUTER JOIN (
      SELECT
        geom as line,
        role
      FROM
        (SELECT unnest(geom) as geom, unnest(role) as role from o2p_aggregate_relation(v_rel_id)) in_sub
      WHERE
        role = 'inner' AND
        ST_IsClosed(geom)
    ) inside ON ST_CONTAINS(st_makepolygon(outside.line), inside.line)
  GROUP BY
    outside.line) polys
) poly_array
INTO
  v_polygons;


RETURN v_polygons;
END;
$o2p_aggregate_polygon_relation$ LANGUAGE plpgsql;
