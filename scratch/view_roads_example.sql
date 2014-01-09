-- roads Example view

-- useful regex
-- exist\((.+?), '(.+?)'\).+
-- $1 -> '$2' as "$2",

CREATE OR REPLACE VIEW planet_osm_roads_view AS
SELECT 
  osm_id,
-------------
"access",
"addr:housename",
"addr:housenumber",
"addr:interpolation",
"admin_level",
"aerialway",
"aeroway",
"amenity",
"area",
"barrier",
"bicycle",
"brand",
"bridge",
"boundary",
"building",
"construction",
"covered",
"culvert",
"cutting",
"denomination",
"disused",
"embankment",
"foot",
"generator:source",
"harbour",
"highway",
"historic",
"horse",
"intermittent",
"junction",
"landuse",
"layer",
"leisure",
"lock",
"man_made",
"military",
"motorcar",
"name",
"natural",
"office",
"oneway",
"operator",
"place",
"population",
"power",
"power_source",
"public_transport",
"railway",
"ref",
"religion",
"route",
"service",
"shop",
"sport",
"surface",
"toll",
"tourism",
"tower:type",
"tracktype",
"tunnel",
"water",
"waterway",
"wetland",
"width",
"wood",
---------------
  z_order,
  way_area,
  way
FROM
  planet_osm_line_view
WHERE --- https://github.com/openstreetmap/osm2pgsql/blob/master/style.lua
  railway IS NOT NULL OR
  boundary = 'administrative' OR
  highway = 'residential' OR
  highway = 'tertiary_link' OR
  highway = 'tertiary' OR
  highway = 'secondary_link' OR
  highway = 'secondary' OR
  highway = 'primary_link' OR
  highway = 'primary' OR
  highway = 'trunk_link' OR
  highway = 'trunk' OR
  highway = 'motorway_link' OR
  highway = 'motorway'
