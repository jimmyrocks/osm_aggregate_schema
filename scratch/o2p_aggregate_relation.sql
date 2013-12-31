--DROP FUNCTION o2p_aggregate_relation(bigint);
CREATE OR REPLACE FUNCTION o2p_aggregate_relation(
  bigint
) returns aggregate_way AS $o2p_aggregate_relation$
DECLARE
  v_rel_id ALIAS for $1;
  v_way geometry[];
  v_role text[];
BEGIN

SELECT
  array_agg(route),
  array_agg(member_role)
FROM (
  SELECT
    CASE
      WHEN direction = 'R' THEN st_reverse(st_makeline(st_reverse(way_geom)))
      ELSE st_makeline(way_geom)
    END route,
    member_role
  FROM (
    SELECT
      CASE
        WHEN new_line = true THEN
    CASE
      WHEN lead(new_line,1) OVER rw_seq = false THEN lead(new_line_rank,1) OVER rw_seq || direction
      ELSE new_line_rank || direction
    END
        ELSE new_line_rank || direction
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
        sequence_id - rank() OVER (PARTITION BY new_line ORDER BY sequence_id) + 1 as new_line_rank
      FROM (
        SELECT
          sequence_id,
          member_role,
          CASE
            WHEN
              first_node = last_node
            THEN 'N'
            WHEN
              first_node = lag(last_node,1) OVER wr_seq OR
              last_node = lead(first_node,1) OVER wr_seq OR
              last_node = lag(last_node) OVER wr_seq
            THEN 'F'
            WHEN
              last_node = lag(first_node,1) OVER wr_seq OR
              first_node = lead(last_node,1) OVER wr_seq OR
              first_node = lag(first_node) OVER wr_seq
            THEN 'R'
            ELSE 'N'
          END as direction,
          CASE
            WHEN
              first_node = lag(last_node,1) OVER wr_seq OR
              last_node = lag(first_node,1) OVER wr_seq OR
              first_node = lag(first_node) OVER wr_seq OR
              last_node = lag(last_node) OVER wr_seq
            THEN false
            ELSE true
          END as new_line,
          CASE
            WHEN
              first_node = lag(first_node) OVER wr_seq OR
              last_node = lag(last_node) OVER wr_seq
            THEN st_reverse(way_geom)
            ELSE way_geom
          END as way_geom
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
          ) way_rels
          WINDOW wr_seq as (
           ORDER BY way_rels.sequence_id
          )
      ) directioned_ways ORDER BY directioned_ways.sequence_id 
    ) ranked_ways
     WINDOW rw_seq as (
      ORDER BY ranked_ways.sequence_id
    )
    ORDER BY
      ranked_ways.sequence_id
  ) grouped_ways GROUP BY
    grp,
    direction,
    member_role
  ORDER BY
    min(sequence_id)
 ) ways_agg
  INTO
    v_way, v_role;

 RETURN (v_way, v_role);
END;
$o2p_aggregate_relation$ LANGUAGE plpgsql;
