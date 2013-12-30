-- Poly sample view

SELECT
  id,
  tags,
  o2p_calculate_zorder(tags) z_order,
  st_area(st_makepolygon(st_transform(o2p_calculate_nodes_to_line(nodes),900913))) way_area,
  st_makepolygon(st_transform(o2p_calculate_nodes_to_line(nodes),900913)) way
FROM
  ways
WHERE
(NOT EXISTS (select 1 from relation_members WHERE relation_members.member_type = 'W' AND relation_members.member_id = ways.id) AND
  tags != ''::hstore AND tags is not null AND nodes[1] = nodes[array_length(nodes, 1)] AND array_length(nodes,1)>1) AND
(exist(tags, 'aeroway') OR 
exist(tags, 'amenity') OR 
exist(tags, 'building') OR 
exist(tags, 'harbour') OR 
exist(tags, 'historic') OR 
exist(tags, 'landuse') OR 
exist(tags, 'leisure') OR 
exist(tags, 'man_made') OR 
exist(tags, 'military') OR 
exist(tags, 'natural') OR 
exist(tags, 'office') OR 
exist(tags, 'place') OR 
exist(tags, 'power') OR 
exist(tags, 'public_transport') OR 
exist(tags, 'shop') OR 
exist(tags, 'sport') OR 
exist(tags, 'tourism') OR 
exist(tags, 'water') OR 
exist(tags, 'waterway') OR exist(tags, 'wetland')) 
UNION
SELECT
  osm_id, tags, z_order, st_area(way) way_area, way
FROM (  
SELECT
  relation_id * -1 as osm_id,
  relations.tags as tags,
  o2p_calculate_zorder(relations.tags) as z_order,
  st_transform(unnest(o2p_aggregate_polygon_relation(relation_id)),900913) as way
FROM
  ways JOIN relation_members ON ways.id = relation_members.member_id JOIN relations on relation_members.relation_id = relations.id
WHERE
  (ways.tags != ''::hstore AND ways.tags is not null AND ways.nodes[1] = ways.nodes[array_length(ways.nodes, 1)] AND array_length(ways.nodes,1)>1) AND
(exist(ways.tags, 'aeroway') OR 
exist(ways.tags, 'amenity') OR 
exist(ways.tags, 'building') OR 
exist(ways.tags, 'harbour') OR 
exist(ways.tags, 'historic') OR 
exist(ways.tags, 'landuse') OR 
exist(ways.tags, 'leisure') OR 
exist(ways.tags, 'man_made') OR 
exist(ways.tags, 'military') OR 
exist(ways.tags, 'natural') OR 
exist(ways.tags, 'office') OR 
exist(ways.tags, 'place') OR 
exist(ways.tags, 'power') OR 
exist(ways.tags, 'public_transport') OR 
exist(ways.tags, 'shop') OR 
exist(ways.tags, 'sport') OR 
exist(ways.tags, 'tourism') OR 
exist(ways.tags, 'water') OR 
exist(ways.tags, 'waterway') OR exist(ways.tags, 'wetland'))) rel_poly;
