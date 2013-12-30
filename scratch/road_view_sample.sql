-- roads sample view

SELECT * FROM
  line_sample_view
WHERE
exist(tags, 'minor') OR
exist(tags, 'road') OR
exist(tags, 'unclassified') OR
exist(tags, 'residential') OR
exist(tags, 'tertiary_link') OR
exist(tags, 'tertiary') OR
exist(tags, 'secondary_link') OR
exist(tags, 'secondary') OR
exist(tags, 'primary_link') OR
exist(tags, 'primary') OR
exist(tags, 'trunk_link') OR
exist(tags, 'trunk') OR
exist(tags, 'motorway_link') OR
exist(tags, 'motorway');
