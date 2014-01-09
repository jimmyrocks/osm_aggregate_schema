osm_aggregate_schema
================

Postgres and PostGIS Views, Functions, and scripts that convert data in the pgsnapshot schema to match the osm2pgsql schema. This allows the same tilemill/mapnik styles that are used with the osm2pgsql schema to be used with pgsnapshot data.

This is especially useful with the NPS poi service (https://github.com/nationalparkservice/poi-api), which automatically pushes all changesets into the pgsnapshot format for faster vector rendering.  Using this set of scripts, any updates to the map can be pushed directly to the rendering database.  This can be combined with mapnik/tilemill to allow the map tiles to be updated within a very short time form when the changes are commited.
