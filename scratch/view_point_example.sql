-- Point example view

CREATE OR REPLACE VIEW planet_osm_point AS
SELECT
  id,
-------------
nodes.tags -> 'access' as "access",
nodes.tags -> 'addr:housename' as "addr:housename",
nodes.tags -> 'addr:housenumber' as "addr:housenumber",
nodes.tags -> 'addr:interpolation' as "addr:interpolation",
nodes.tags -> 'admin_level' as "admin_level",
nodes.tags -> 'aerialway' as "aerialway",
nodes.tags -> 'aeroway' as "aeroway",
nodes.tags -> 'amenity' as "amenity",
nodes.tags -> 'barrier' as "barrier",
nodes.tags -> 'brand' as "brand",
nodes.tags -> 'bridge' as "bridge",
nodes.tags -> 'boundary' as "boundary",
nodes.tags -> 'building' as "building",
nodes.tags -> 'capital' as "capital",
nodes.tags -> 'construction' as "construction",
nodes.tags -> 'covered' as "covered",
nodes.tags -> 'culvert' as "culvert",
nodes.tags -> 'cutting' as "cutting",
nodes.tags -> 'denomination' as "denomination",
nodes.tags -> 'disused' as "disused",
nodes.tags -> 'ele' as "ele",
nodes.tags -> 'embankment' as "embankment",
nodes.tags -> 'foot' as "foot",
nodes.tags -> 'generator:source' as "generator:source",
nodes.tags -> 'harbour' as "harbour",
nodes.tags -> 'highway' as "highway",
nodes.tags -> 'historic' as "historic",
nodes.tags -> 'horse' as "horse",
nodes.tags -> 'intermittent' as "intermittent",
nodes.tags -> 'junction' as "junction",
nodes.tags -> 'landuse' as "landuse",
nodes.tags -> 'layer' as "layer",
nodes.tags -> 'leisure' as "leisure",
nodes.tags -> 'lock' as "lock",
nodes.tags -> 'man_made' as "man_made",
nodes.tags -> 'military' as "military",
nodes.tags -> 'motorcar' as "motorcar",
nodes.tags -> 'name' as "name",
nodes.tags -> 'natural' as "natural",
nodes.tags -> 'office' as "office",
nodes.tags -> 'oneway' as "oneway",
nodes.tags -> 'operator' as "operator",
nodes.tags -> 'place' as "place",
nodes.tags -> 'population' as "population",
nodes.tags -> 'power' as "power",
nodes.tags -> 'power_source' as "power_source",
nodes.tags -> 'public_transport' as "public_transport",
nodes.tags -> 'railway' as "railway",
nodes.tags -> 'ref' as "ref",
nodes.tags -> 'route' as "route",
nodes.tags -> 'service' as "service",
nodes.tags -> 'shop' as "shop",
nodes.tags -> 'sport' as "sport",
nodes.tags -> 'surface' as "surface",
nodes.tags -> 'toll' as "toll",
nodes.tags -> 'tourism' as "tourism",
nodes.tags -> 'tower:type' as "tower:type",
nodes.tags -> 'tunnel' as "tunnel",
nodes.tags -> 'water' as "water",
nodes.tags -> 'waterway' as "waterway",
nodes.tags -> 'wetland' as "wetland",
nodes.tags -> 'width' as "width",
nodes.tags -> 'wood' as "wood",
-------------
  o2p_calculate_zorder(tags) z_order,
  st_transform(geom,900913) way
FROM NODES
WHERE
(tags != ''::hstore AND tags is not null) AND
(exist(nodes.tags, 'access') OR 
exist(nodes.tags, 'addr:housename') OR 
exist(nodes.tags, 'addr:housenumber') OR 
exist(nodes.tags, 'addr:interpolation') OR 
exist(nodes.tags, 'admin_level') OR 
exist(nodes.tags, 'aerialway') OR 
exist(nodes.tags, 'aeroway') OR 
exist(nodes.tags, 'amenity') OR 
exist(nodes.tags, 'barrier') OR 
exist(nodes.tags, 'brand') OR 
exist(nodes.tags, 'bridge') OR 
exist(nodes.tags, 'boundary') OR 
exist(nodes.tags, 'building') OR 
exist(nodes.tags, 'capital') OR 
exist(nodes.tags, 'construction') OR 
exist(nodes.tags, 'covered') OR 
exist(nodes.tags, 'culvert') OR 
exist(nodes.tags, 'cutting') OR 
exist(nodes.tags, 'denomination') OR 
exist(nodes.tags, 'disused') OR 
exist(nodes.tags, 'ele') OR 
exist(nodes.tags, 'embankment') OR 
exist(nodes.tags, 'foot') OR 
exist(nodes.tags, 'generator:source') OR 
exist(nodes.tags, 'harbour') OR 
exist(nodes.tags, 'highway') OR 
exist(nodes.tags, 'historic') OR 
exist(nodes.tags, 'horse') OR 
exist(nodes.tags, 'intermittent') OR 
exist(nodes.tags, 'junction') OR 
exist(nodes.tags, 'landuse') OR 
exist(nodes.tags, 'layer') OR 
exist(nodes.tags, 'leisure') OR 
exist(nodes.tags, 'lock') OR 
exist(nodes.tags, 'man_made') OR 
exist(nodes.tags, 'military') OR 
exist(nodes.tags, 'motorcar') OR 
exist(nodes.tags, 'name') OR 
exist(nodes.tags, 'natural') OR 
exist(nodes.tags, 'office') OR 
exist(nodes.tags, 'oneway') OR 
exist(nodes.tags, 'operator') OR 
exist(nodes.tags, 'place') OR 
exist(nodes.tags, 'population') OR 
exist(nodes.tags, 'power') OR 
exist(nodes.tags, 'power_source') OR 
exist(nodes.tags, 'public_transport') OR 
exist(nodes.tags, 'railway') OR 
exist(nodes.tags, 'ref') OR 
exist(nodes.tags, 'route') OR 
exist(nodes.tags, 'service') OR 
exist(nodes.tags, 'shop') OR 
exist(nodes.tags, 'sport') OR 
exist(nodes.tags, 'surface') OR 
exist(nodes.tags, 'toll') OR 
exist(nodes.tags, 'tourism') OR 
exist(nodes.tags, 'tower:type') OR 
exist(nodes.tags, 'tunnel') OR 
exist(nodes.tags, 'water') OR 
exist(nodes.tags, 'waterway') OR 
exist(nodes.tags, 'wetland') OR 
exist(nodes.tags, 'width') OR 
exist(nodes.tags, 'wood'));
