DROP FUNCTION o2p_join_line_relation(bigint);
CREATE OR REPLACE FUNCTION o2p_join_line_relation(
  bigint
) returns geometry[] AS o2p_join_line_relation
DECLARE
  v_rel_id ALIAS for $1;
  v_lines geometry[];
BEGIN
-- Looks at the relation id and determines the simplified lines for it
SELECT
  array_agg(route)
FROM (
SELECT
  CASE WHEN a = 'R' THEN st_reverse(st_makeline(st_reverse(way_geom)))
  ELSE st_makeline(way_geom) END route
from (
  SELECT
    CASE
      WHEN b = 'N' THEN CASE WHEN lead(B,1) OVER ww != 'N' THEN lead(rank2,1) OVER ww || a ELSE rank2 || a END
      ELSE rank2 || a
    END grp,
    a,
    sequence_id,
    direction,
    way_geom
  FROM (
  SELECT
    way_geom,
    sequence_id,
    direction,
    CASE WHEN substring(direction from 1 for 1) = 'N' THEN sequence_id::text ELSE substring(direction from 1 for 1) END a,
    substring(direction from 2) b,
    sequence_id - rank() OVER (PARTITION BY substring(direction from 1 for 1) ORDER BY sequence_id) + 1 as rank,
    sequence_id - rank() OVER (PARTITION BY substring(direction from 2) ORDER BY sequence_id) + 1 as rank2
  FROM (
  SELECT
    o2p_calculate_nodes_to_line(g.nodes) as way_geom,
    sequence_id,
    CASE
      WHEN first_node = lag(last_node,1) OVER w THEN 'F'
      WHEN last_node = lead(first_node,1) OVER w THEN 'FN'
      WHEN last_node = lag(first_node,1) OVER w THEN 'R'
      WHEN first_node = lead(last_node,1) OVER w THEN 'RN'
      ELSE 'NN'
    END as direction
    FROM (
    SELECT
      ways.nodes[1] first_node,
      ways.nodes[array_length(ways.nodes, 1)] last_node,
      ways.nodes,
      member_role,
      sequence_id
    FROM
    relation_members JOIN
        ways on ways.id = relation_members.member_id
      WHERE
        relation_id = v_rel_id AND
        member_type = 'W'
      ORDER BY
        sequence_id

  ) g WINDOW w as (
        ORDER BY g.sequence_id
    )) h
    ) j WINDOW ww as (
        ORDER BY j.sequence_id) ORDER BY j.sequence_id) k group by grp, a order by min(sequence_id)) l
INTO
  v_lines;


RETURN v_lines;
END;
o2p_join_line_relation LANGUAGE plpgsql;
