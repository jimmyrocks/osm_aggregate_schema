-- roads example view

-- useful regex
-- exist\((.+?), '(.+?)'\).+
-- $1 -> '$2' as "$2",

SELECT 
  osm_id,
-------------
"minor",
"road",
"unclassified",
"residential",
"tertiary_link",
"tertiary",
"secondary_link",
"secondary",
"primary_link",
"primary",
"trunk_link",
"trunk",
"motorway_link",
"motorway",
---------------
  z_order,
  way_area,
  way
FROM
  line_sample_view
WHERE
"minor" IS NOT NULL OR
"road" IS NOT NULL OR
"unclassified" IS NOT NULL OR
"residential" IS NOT NULL OR
"tertiary_link" IS NOT NULL OR
"tertiary" IS NOT NULL OR
"secondary_link" IS NOT NULL OR
"secondary" IS NOT NULL OR
"primary_link" IS NOT NULL OR
"primary" IS NOT NULL OR
"trunk_link" IS NOT NULL OR
"trunk" IS NOT NULL OR
"motorway_link" IS NOT NULL OR
"motorway" IS NOT NULL;
