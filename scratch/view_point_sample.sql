-- points sample view

SELECT
  id,
  tags,
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
