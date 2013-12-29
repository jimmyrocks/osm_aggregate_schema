SELECT CASE
       WHEN holes[1] IS NULL THEN st_makepolygon(shell)
       ELSE st_makepolygon(shell, holes)
     END polygon
FROM
  (SELECT outside.line AS shell,
      array_agg(inside.line) AS holes,
      outside.seq
   FROM
   (SELECT o2p_calculate_nodes_to_line(ways.nodes) AS line,
       relation_members.member_role AS ROLE,
       relation_members.sequence_id AS seq
    FROM relation_members
    JOIN ways ON relation_members.member_id = ways.id
    WHERE relation_members.relation_id = '3351325'
    AND relation_members.member_type = 'W'
    AND relation_members.member_role != 'inner'
    AND ways.nodes[1] = ways.nodes[array_length(ways.nodes,1)]
 ) outside
   LEFT OUTER JOIN
   (SELECT o2p_calculate_nodes_to_line(ways.nodes) AS line,
       relation_members.member_role AS ROLE,
       relation_members.sequence_id AS seq
    FROM relation_members
    JOIN ways ON relation_members.member_id = ways.id
    WHERE relation_members.relation_id = '3351325'
    AND relation_members.member_type = 'W'
    AND relation_members.member_role = 'inner'
    AND ways.nodes[1] = ways.nodes[array_length(ways.nodes,1)]
 ) inside ON ST_CONTAINS(st_makepolygon(outside.line), inside.line)
   GROUP BY outside.line,
      outside.seq) polys
ORDER BY seq;
