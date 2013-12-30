-- Poly Example view

CREATE OR REPLACE VIEW planet_osm_polygon AS
SELECT
  id,
-------------------------------
ways.tags -> 'aeroway' as "aeroway",
ways.tags -> 'amenity' as "amenity",
ways.tags -> 'building' as "building",
ways.tags -> 'harbour' as "harbour",
ways.tags -> 'historic' as "historic",
ways.tags -> 'landuse' as "landuse",
ways.tags -> 'leisure' as "leisure",
ways.tags -> 'man_made' as "man_made",
ways.tags -> 'military' as "military",
ways.tags -> 'natural' as "natural",
ways.tags -> 'office' as "office",
ways.tags -> 'place' as "place",
ways.tags -> 'power' as "power",
ways.tags -> 'public_transport' as "public_transport",
ways.tags -> 'shop' as "shop",
ways.tags -> 'sport' as "sport",
ways.tags -> 'tourism' as "tourism",
ways.tags -> 'water' as "water",
ways.tags -> 'waterway' as "waterway",
ways.tags -> 'wetland' as "wetland",
-------------------------------
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
  osm_id, 
-----------------------------
tags -> 'aeroway' as "aeroway",
tags -> 'amenity' as "amenity",
tags -> 'building' as "building",
tags -> 'harbour' as "harbour",
tags -> 'historic' as "historic",
tags -> 'landuse' as "landuse",
tags -> 'leisure' as "leisure",
tags -> 'man_made' as "man_made",
tags -> 'military' as "military",
tags -> 'natural' as "natural",
tags -> 'office' as "office",
tags -> 'place' as "place",
tags -> 'power' as "power",
tags -> 'public_transport' as "public_transport",
tags -> 'shop' as "shop",
tags -> 'sport' as "sport",
tags -> 'tourism' as "tourism",
tags -> 'water' as "water",
tags -> 'waterway' as "waterway",
tags -> 'wetland' as "wetland",
----------------------------
  z_order, st_area(way) way_area, way
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
