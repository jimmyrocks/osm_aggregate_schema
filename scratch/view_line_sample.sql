-- Line Sample View

SELECT
  id,
  tags,
  o2p_calculate_zorder(tags) z_order,
  st_area(st_transform(o2p_calculate_nodes_to_line(nodes),900913)) way_area,
  st_transform(o2p_calculate_nodes_to_line(nodes),900913) way
FROM
 ways
WHERE
(NOT EXISTS (select 1 from relation_members WHERE relation_members.member_type = 'W' AND relation_members.member_id = ways.id) AND
(tags != ''::hstore AND tags is not null AND array_length(nodes,1)>1)) AND 
(
exist(ways.tags, 'access') OR 
exist(ways.tags, 'addr:housename') OR 
exist(ways.tags, 'addr:housenumber') OR 
exist(ways.tags, 'addr:interpolation') OR 
exist(ways.tags, 'admin_level') OR 
exist(ways.tags, 'aerialway') OR 
exist(ways.tags, 'aeroway') OR 
exist(ways.tags, 'amenity') OR 
exist(ways.tags, 'barrier') OR 
exist(ways.tags, 'brand') OR 
exist(ways.tags, 'bridge') OR 
exist(ways.tags, 'boundary') OR 
exist(ways.tags, 'building') OR 
exist(ways.tags, 'construction') OR 
exist(ways.tags, 'covered') OR 
exist(ways.tags, 'culvert') OR 
exist(ways.tags, 'cutting') OR 
exist(ways.tags, 'denomination') OR 
exist(ways.tags, 'disused') OR 
exist(ways.tags, 'embankment') OR 
exist(ways.tags, 'foot') OR 
exist(ways.tags, 'generator:source') OR 
exist(ways.tags, 'harbour') OR 
exist(ways.tags, 'highway') OR 
exist(ways.tags, 'historic') OR 
exist(ways.tags, 'horse') OR 
exist(ways.tags, 'intermittent') OR 
exist(ways.tags, 'junction') OR 
exist(ways.tags, 'landuse') OR 
exist(ways.tags, 'layer') OR 
exist(ways.tags, 'leisure') OR 
exist(ways.tags, 'lock') OR 
exist(ways.tags, 'man_made') OR 
exist(ways.tags, 'military') OR 
exist(ways.tags, 'motorcar') OR 
exist(ways.tags, 'name') OR 
exist(ways.tags, 'natural') OR 
exist(ways.tags, 'office') OR 
exist(ways.tags, 'oneway') OR 
exist(ways.tags, 'operator') OR 
exist(ways.tags, 'place') OR 
exist(ways.tags, 'population') OR 
exist(ways.tags, 'power') OR 
exist(ways.tags, 'power_source') OR 
exist(ways.tags, 'public_transport') OR 
exist(ways.tags, 'railway') OR 
exist(ways.tags, 'ref') OR 
exist(ways.tags, 'route') OR 
exist(ways.tags, 'service') OR 
exist(ways.tags, 'shop') OR 
exist(ways.tags, 'sport') OR 
exist(ways.tags, 'surface') OR 
exist(ways.tags, 'toll') OR 
exist(ways.tags, 'tourism') OR 
exist(ways.tags, 'tower:type') OR 
exist(ways.tags, 'tracktype') OR 
exist(ways.tags, 'tunnel') OR 
exist(ways.tags, 'water') OR 
exist(ways.tags, 'waterway') OR 
exist(ways.tags, 'wetland') OR 
exist(ways.tags, 'width') OR 
exist(ways.tags, 'wood'))
UNION
SELECT
  osm_id, tags, z_order, st_area(way) way_area, way
FROM (  
SELECT
  relation_id * -1 as osm_id,
  relations.tags as tags,
  o2p_calculate_zorder(relations.tags) as z_order,
  st_transform(unnest(o2p_aggregate_line_relation(relation_id)),900913) as way
FROM
  ways JOIN relation_members ON ways.id = relation_members.member_id JOIN relations on relation_members.relation_id = relations.id
WHERE
  (ways.tags != ''::hstore AND ways.tags is not null AND array_length(ways.nodes,1)>1) AND
  (
exist(ways.tags, 'access') OR 
exist(ways.tags, 'addr:housename') OR 
exist(ways.tags, 'addr:housenumber') OR 
exist(ways.tags, 'addr:interpolation') OR 
exist(ways.tags, 'admin_level') OR 
exist(ways.tags, 'aerialway') OR 
exist(ways.tags, 'aeroway') OR 
exist(ways.tags, 'amenity') OR 
exist(ways.tags, 'barrier') OR 
exist(ways.tags, 'brand') OR 
exist(ways.tags, 'bridge') OR 
exist(ways.tags, 'boundary') OR 
exist(ways.tags, 'building') OR 
exist(ways.tags, 'construction') OR 
exist(ways.tags, 'covered') OR 
exist(ways.tags, 'culvert') OR 
exist(ways.tags, 'cutting') OR 
exist(ways.tags, 'denomination') OR 
exist(ways.tags, 'disused') OR 
exist(ways.tags, 'embankment') OR 
exist(ways.tags, 'foot') OR 
exist(ways.tags, 'generator:source') OR 
exist(ways.tags, 'harbour') OR 
exist(ways.tags, 'highway') OR 
exist(ways.tags, 'historic') OR 
exist(ways.tags, 'horse') OR 
exist(ways.tags, 'intermittent') OR 
exist(ways.tags, 'junction') OR 
exist(ways.tags, 'landuse') OR 
exist(ways.tags, 'layer') OR 
exist(ways.tags, 'leisure') OR 
exist(ways.tags, 'lock') OR 
exist(ways.tags, 'man_made') OR 
exist(ways.tags, 'military') OR 
exist(ways.tags, 'motorcar') OR 
exist(ways.tags, 'name') OR 
exist(ways.tags, 'natural') OR 
exist(ways.tags, 'office') OR 
exist(ways.tags, 'oneway') OR 
exist(ways.tags, 'operator') OR 
exist(ways.tags, 'place') OR 
exist(ways.tags, 'population') OR 
exist(ways.tags, 'power') OR 
exist(ways.tags, 'power_source') OR 
exist(ways.tags, 'public_transport') OR 
exist(ways.tags, 'railway') OR 
exist(ways.tags, 'ref') OR 
exist(ways.tags, 'route') OR 
exist(ways.tags, 'service') OR 
exist(ways.tags, 'shop') OR 
exist(ways.tags, 'sport') OR 
exist(ways.tags, 'surface') OR 
exist(ways.tags, 'toll') OR 
exist(ways.tags, 'tourism') OR 
exist(ways.tags, 'tower:type') OR 
exist(ways.tags, 'tracktype') OR 
exist(ways.tags, 'tunnel') OR 
exist(ways.tags, 'water') OR 
exist(ways.tags, 'waterway') OR 
exist(ways.tags, 'wetland') OR 
exist(ways.tags, 'width') OR 
exist(ways.tags, 'wood'))) rel_line;
