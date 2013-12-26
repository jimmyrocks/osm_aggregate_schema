DROP VIEW render_osm_point;
CREATE VIEW render_osm_point AS SELECT id as osm_id, tags -> 'access' as "access", tags -> 'addr:housename' as "addr:housename", tags -> 'addr:housenumber' as "addr:housenumber", tags -> 'addr:interpolation' as "addr:interpolation", tags -> 'admin_level' as "admin_level", tags -> 'aerialway' as "aerialway", tags -> 'aeroway' as "aeroway", tags -> 'amenity' as "amenity", tags -> 'area' as "area", tags -> 'barrier' as "barrier", tags -> 'bicycle' as "bicycle", tags -> 'brand' as "brand", tags -> 'bridge' as "bridge", tags -> 'boundary' as "boundary", tags -> 'building' as "building", tags -> 'capital' as "capital", tags -> 'construction' as "construction", tags -> 'covered' as "covered", tags -> 'culvert' as "culvert", tags -> 'cutting' as "cutting", tags -> 'denomination' as "denomination", tags -> 'disused' as "disused", tags -> 'ele' as "ele", tags -> 'embankment' as "embankment", tags -> 'foot' as "foot", tags -> 'generator:source' as "generator:source", tags -> 'harbour' as "harbour", tags -> 'highway' as "highway", tags -> 'historic' as "historic", tags -> 'horse' as "horse", tags -> 'intermittent' as "intermittent", tags -> 'junction' as "junction", tags -> 'landuse' as "landuse", tags -> 'layer' as "layer", tags -> 'leisure' as "leisure", tags -> 'lock' as "lock", tags -> 'man_made' as "man_made", tags -> 'military' as "military", tags -> 'motorcar' as "motorcar", tags -> 'name' as "name", tags -> 'natural' as "natural", tags -> 'office' as "office", tags -> 'oneway' as "oneway", tags -> 'operator' as "operator", tags -> 'place' as "place", tags -> 'poi' as "poi", tags -> 'population' as "population", tags -> 'power' as "power", tags -> 'power_source' as "power_source", tags -> 'public_transport' as "public_transport", tags -> 'railway' as "railway", tags -> 'ref' as "ref", tags -> 'religion' as "religion", tags -> 'route' as "route", tags -> 'service' as "service", tags -> 'shop' as "shop", tags -> 'sport' as "sport", tags -> 'surface' as "surface", tags -> 'toll' as "toll", tags -> 'tourism' as "tourism", tags -> 'tower:type' as "tower:type", tags -> 'tunnel' as "tunnel", tags -> 'water' as "water", tags -> 'waterway' as "waterway", tags -> 'wetland' as "wetland", tags -> 'width' as "width", tags -> 'wood' as "wood", o2p_calculate_zorder(tags) as "z_order", geom as way FROM nodes WHERE (tags != ''::hstore AND tags is not null) AND ( exist(tags, 'access') OR exist(tags, 'addr:housename') OR exist(tags, 'addr:housenumber') OR exist(tags, 'addr:interpolation') OR exist(tags, 'admin_level') OR exist(tags, 'aerialway') OR exist(tags, 'aeroway') OR exist(tags, 'amenity') OR exist(tags, 'area') OR exist(tags, 'barrier') OR exist(tags, 'bicycle') OR exist(tags, 'brand') OR exist(tags, 'bridge') OR exist(tags, 'boundary') OR exist(tags, 'building') OR exist(tags, 'capital') OR exist(tags, 'construction') OR exist(tags, 'covered') OR exist(tags, 'culvert') OR exist(tags, 'cutting') OR exist(tags, 'denomination') OR exist(tags, 'disused') OR exist(tags, 'ele') OR exist(tags, 'embankment') OR exist(tags, 'foot') OR exist(tags, 'generator:source') OR exist(tags, 'harbour') OR exist(tags, 'highway') OR exist(tags, 'historic') OR exist(tags, 'horse') OR exist(tags, 'intermittent') OR exist(tags, 'junction') OR exist(tags, 'landuse') OR exist(tags, 'layer') OR exist(tags, 'leisure') OR exist(tags, 'lock') OR exist(tags, 'man_made') OR exist(tags, 'military') OR exist(tags, 'motorcar') OR exist(tags, 'name') OR exist(tags, 'natural') OR exist(tags, 'office') OR exist(tags, 'oneway') OR exist(tags, 'operator') OR exist(tags, 'place') OR exist(tags, 'poi') OR exist(tags, 'population') OR exist(tags, 'power') OR exist(tags, 'power_source') OR exist(tags, 'public_transport') OR exist(tags, 'railway') OR exist(tags, 'ref') OR exist(tags, 'religion') OR exist(tags, 'route') OR exist(tags, 'service') OR exist(tags, 'shop') OR exist(tags, 'sport') OR exist(tags, 'surface') OR exist(tags, 'toll') OR exist(tags, 'tourism') OR exist(tags, 'tower:type') OR exist(tags, 'tunnel') OR exist(tags, 'water') OR exist(tags, 'waterway') OR exist(tags, 'wetland') OR exist(tags, 'width') OR exist(tags, 'wood'));


DROP VIEW render_osm_point;
CREATE VIEW render_osm_line AS
SELECT
  id as osm_id,
  tags,
  o2p_calculate_zorder(tags),
  way_area,
  o2p_calculate_nodes_to_line(way)
FROM
  ways;

  SELECT
    g.id as osm_id,
    g.tags as tags,
    o2p_calculate_zorder(g.tags) as z_order,
    st_area(g.way) as way_area,
    g.way as way
  FROM
    (SELECT id, tags, ST_TRANSFORM(o2p_calculate_nodes_to_line(nodes),900913) as way from ways
  WHERE
    (tags != ''::hstore AND tags is not null) AND ( exist(tags, 'access')) AND nodes[1] != nodes[array_length(nodes, 1)]) g;
