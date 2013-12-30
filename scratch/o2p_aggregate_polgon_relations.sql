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
      array_agg(inside.line) AS holes,
      outside.seq
    FROM (
      SELECT
        o2p_calculate_nodes_to_line(ways.nodes) AS line,
        relation_members.member_role AS ROLE,
        relation_members.sequence_id AS seq
      FROM
        relation_members JOIN ways
        ON relation_members.member_id = ways.id
      WHERE
        relation_members.relation_id = v_rel_id AND
        relation_members.member_type = 'W' AND
        relation_members.member_role != 'inner' AND
        ways.nodes[1] = ways.nodes[array_length(ways.nodes,1)]
    ) outside LEFT OUTER JOIN (
       SELECT
         o2p_calculate_nodes_to_line(ways.nodes) AS line,
         relation_members.member_role AS ROLE,
         relation_members.sequence_id AS seq
        FROM
          relation_members JOIN ways
          ON relation_members.member_id = ways.id
        WHERE
          relation_members.relation_id = v_rel_id AND
          relation_members.member_type = 'W' AND
          relation_members.member_role = 'inner' AND
          ways.nodes[1] = ways.nodes[array_length(ways.nodes,1)]
    ) inside ON ST_CONTAINS(st_makepolygon(outside.line), inside.line)
  GROUP BY
    outside.line,
    outside.seq) polys
  ORDER BY
    seq
) poly_array
INTO
  v_polygons;


RETURN v_polygons;
END;
$o2p_aggregate_polygon_relation$ LANGUAGE plpgsql;
