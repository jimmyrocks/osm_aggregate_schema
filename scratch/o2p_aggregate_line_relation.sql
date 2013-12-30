DROP FUNCTION o2p_aggregate_line_relation(bigint);
CREATE OR REPLACE FUNCTION o2p_aggregate_line_relation(
  bigint
) returns geometry[] AS $o2p_aggregate_line_relation$
DECLARE
  v_rel_id ALIAS for $1;
  v_lines geometry[];
BEGIN
-- Looks at the relation id and determines the simplified lines for it
-- Could I do this as a view?
SELECT
  array_agg(route)
FROM (
SELECT
  CASE
    WHEN direction = 'R' THEN st_reverse(st_makeline(st_reverse(way_geom)))
    ELSE st_makeline(way_geom)
  END route
FROM (
  SELECT
    CASE
      WHEN new_line = true THEN
	CASE
	  WHEN lead(new_line,1) OVER ww = false THEN lead(rank2,1) OVER ww || direction
	  ELSE rank2 || direction
	END
      ELSE rank2 || direction
    END grp,
    member_role,
    sequence_id,
    direction,
    way_geom
  FROM (
  SELECT
    way_geom,
    sequence_id,
    direction,
    new_line,
    member_role,
    sequence_id - rank() OVER (PARTITION BY direction ORDER BY sequence_id) + 1 as rank,
    sequence_id - rank() OVER (PARTITION BY new_line ORDER BY sequence_id) + 1 as rank2
  FROM (
  SELECT
    way_geom,
    sequence_id,
    member_role,
    CASE
      WHEN first_node = lag(last_node,1) OVER w OR last_node = lead(first_node,1) OVER w THEN 'F'
      WHEN last_node = lag(first_node,1) OVER w OR first_node = lead(last_node,1) OVER w THEN 'R'
      ELSE 'N'
    END as direction,
    CASE
      WHEN first_node = lag(last_node,1) OVER w or last_node = lag(first_node,1) OVER w THEN false
      ELSE true
    END as new_line
    FROM (
    SELECT
      ways.nodes[1] first_node,
      ways.nodes[array_length(ways.nodes, 1)] last_node,
      o2p_calculate_nodes_to_line(ways.nodes) as way_geom,
      member_role,
      sequence_id
    FROM
    relation_members JOIN
        ways ON ways.id = relation_members.member_id
      WHERE
        relation_id = v_rel_id AND -- relation: 2301099 is rt 13 (for testing)
        member_type = 'W'
      ORDER BY
        sequence_id
  ) g WINDOW w as (
        ORDER BY g.sequence_id
    )) h ORDER BY h.sequence_id 
    ) j WINDOW ww as (
        ORDER BY j.sequence_id) ORDER BY j.sequence_id) k group by grp, direction, member_role order by min(sequence_id)) l;
INTO
  v_lines;


RETURN v_lines;
END;
$o2p_aggregate_line_relation$ LANGUAGE plpgsql;
