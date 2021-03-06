-- Poly Example view

CREATE OR REPLACE VIEW planet_osm_polygon_view AS
SELECT
  id as osm_id,
-------------------------------
ways.tags -> 'access' as "access",
ways.tags -> 'addr:housename' as "addr:housename",
ways.tags -> 'addr:housenumber' as "addr:housenumber",
ways.tags -> 'addr:interpolation' as "addr:interpolation",
ways.tags -> 'admin_level' as "admin_level",
ways.tags -> 'aerialway' as "aerialway",
ways.tags -> 'aeroway' as "aeroway",
ways.tags -> 'amenity' as "amenity",
ways.tags -> 'area' as "area",
ways.tags -> 'barrier' as "barrier",
ways.tags -> 'bicycle' as "bicycle",
ways.tags -> 'brand' as "brand",
ways.tags -> 'bridge' as "bridge",
ways.tags -> 'boundary' as "boundary",
ways.tags -> 'building' as "building",
ways.tags -> 'construction' as "construction",
ways.tags -> 'covered' as "covered",
ways.tags -> 'culvert' as "culvert",
ways.tags -> 'cutting' as "cutting",
ways.tags -> 'denomination' as "denomination",
ways.tags -> 'disused' as "disused",
ways.tags -> 'embankment' as "embankment",
ways.tags -> 'foot' as "foot",
ways.tags -> 'generator:source' as "generator:source",
ways.tags -> 'harbour' as "harbour",
ways.tags -> 'highway' as "highway",
ways.tags -> 'historic' as "historic",
ways.tags -> 'horse' as "horse",
ways.tags -> 'intermittent' as "intermittent",
ways.tags -> 'junction' as "junction",
ways.tags -> 'landuse' as "landuse",
ways.tags -> 'layer' as "layer",
ways.tags -> 'leisure' as "leisure",
ways.tags -> 'lock' as "lock",
ways.tags -> 'man_made' as "man_made",
ways.tags -> 'military' as "military",
ways.tags -> 'motorcar' as "motorcar",
ways.tags -> 'name' as "name",
ways.tags -> 'natural' as "natural",
ways.tags -> 'office' as "office",
ways.tags -> 'oneway' as "oneway",
ways.tags -> 'operator' as "operator",
ways.tags -> 'place' as "place",
ways.tags -> 'population' as "population",
ways.tags -> 'power' as "power",
ways.tags -> 'power_source' as "power_source",
ways.tags -> 'public_transport' as "public_transport",
ways.tags -> 'railway' as "railway",
ways.tags -> 'ref' as "ref",
ways.tags -> 'religion' as "religion",
ways.tags -> 'route' as "route",
ways.tags -> 'service' as "service",
ways.tags -> 'shop' as "shop",
ways.tags -> 'sport' as "sport",
ways.tags -> 'surface' as "surface",
ways.tags -> 'toll' as "toll",
ways.tags -> 'tourism' as "tourism",
ways.tags -> 'tower:type' as "tower:type",
ways.tags -> 'tracktype' as "tracktype",
ways.tags -> 'tunnel' as "tunnel",
ways.tags -> 'water' as "water",
ways.tags -> 'waterway' as "waterway",
ways.tags -> 'wetland' as "wetland",
ways.tags -> 'width' as "width",
ways.tags -> 'wood' as "wood",
-------------------------------
  o2p_calculate_zorder(tags) z_order,
  st_area(st_makepolygon(st_transform(o2p_calculate_nodes_to_line(nodes),900913))) way_area,
  st_makepolygon(st_transform(o2p_calculate_nodes_to_line(nodes),900913)) way
FROM
  ways
WHERE
(NOT EXISTS (select 1 from relation_members JOIN relations ON relation_members.relation_id = relations.id WHERE 
  relation_members.member_id = ways.id and relation_members.member_type = 'W' AND
  (relations.tags -> 'type' = 'multipolygon' OR relations.tags -> 'type' = 'boundary' OR relations.tags -> 'type' = 'route')) AND
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
tags -> 'access' as "access",
tags -> 'addr:housename' as "addr:housename",
tags -> 'addr:housenumber' as "addr:housenumber",
tags -> 'addr:interpolation' as "addr:interpolation",
tags -> 'admin_level' as "admin_level",
tags -> 'aerialway' as "aerialway",
tags -> 'aeroway' as "aeroway",
tags -> 'amenity' as "amenity",
tags -> 'area' as "area",
tags -> 'barrier' as "barrier",
tags -> 'bicycle' as "bicycle",
tags -> 'brand' as "brand",
tags -> 'bridge' as "bridge",
tags -> 'boundary' as "boundary",
tags -> 'building' as "building",
tags -> 'construction' as "construction",
tags -> 'covered' as "covered",
tags -> 'culvert' as "culvert",
tags -> 'cutting' as "cutting",
tags -> 'denomination' as "denomination",
tags -> 'disused' as "disused",
tags -> 'embankment' as "embankment",
tags -> 'foot' as "foot",
tags -> 'generator:source' as "generator:source",
tags -> 'harbour' as "harbour",
tags -> 'highway' as "highway",
tags -> 'historic' as "historic",
tags -> 'horse' as "horse",
tags -> 'intermittent' as "intermittent",
tags -> 'junction' as "junction",
tags -> 'landuse' as "landuse",
tags -> 'layer' as "layer",
tags -> 'leisure' as "leisure",
tags -> 'lock' as "lock",
tags -> 'man_made' as "man_made",
tags -> 'military' as "military",
tags -> 'motorcar' as "motorcar",
tags -> 'name' as "name",
tags -> 'natural' as "natural",
tags -> 'office' as "office",
tags -> 'oneway' as "oneway",
tags -> 'operator' as "operator",
tags -> 'place' as "place",
tags -> 'population' as "population",
tags -> 'power' as "power",
tags -> 'power_source' as "power_source",
tags -> 'public_transport' as "public_transport",
tags -> 'railway' as "railway",
tags -> 'ref' as "ref",
tags -> 'religion' as "religion",
tags -> 'route' as "route",
tags -> 'service' as "service",
tags -> 'shop' as "shop",
tags -> 'sport' as "sport",
tags -> 'surface' as "surface",
tags -> 'toll' as "toll",
tags -> 'tourism' as "tourism",
tags -> 'tower:type' as "tower:type",
tags -> 'tracktype' as "tracktype",
tags -> 'tunnel' as "tunnel",
tags -> 'water' as "water",
tags -> 'waterway' as "waterway",
tags -> 'wetland' as "wetland",
tags -> 'width' as "width",
tags -> 'wood' as "wood",
----------------------------
  z_order, st_area(way) way_area, way
FROM (  
SELECT
  relation_id * -1 as osm_id,
  ways.tags as tags,
  o2p_calculate_zorder(relations.tags) as z_order,
  st_transform(unnest(o2p_aggregate_polygon_relation(relation_id)),900913) as way
FROM
  ways JOIN relation_members ON ways.id = relation_members.member_id JOIN relations on relation_members.relation_id = relations.id
WHERE
  relations.tags != ''::hstore AND
  relations.tags is not null AND
  ways.nodes[1] = ways.nodes[array_length(ways.nodes, 1)] AND
  array_length(ways.nodes,1)>1 AND
  exist(relations.tags, 'type') AND ((
    relations.tags -> 'type' = 'multipolygon' OR relations.tags -> 'type' = 'boundary' OR relations.tags -> 'type' = 'route'
  ) AND (
    exist(ways.tags, 'aeroway') OR 
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
    exist(ways.tags, 'waterway') OR 
    exist(ways.tags, 'wetland')
  )
)
) rel_poly;
