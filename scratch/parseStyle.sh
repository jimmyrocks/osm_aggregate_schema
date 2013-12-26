# Define the file (maybe should be form $1?)
file='default.style'

# Get the list of columns from the style file
nodeStyles=`egrep -v "(^#|^$| delete$| phstore$| z_order | way_area )"  "$file" | egrep "(^|,)node[, ]" | perl -pe 's/^[a-z,]+?[ ]+?(\w.+?)\s.+/$1/g'`
wayStyles=`egrep -v "(^#|^$| delete$| phstore$| z_order | way_area )"  "$file" | egrep "(^|,)way[, ]" | egrep ' linear( |$)' | perl -pe 's/^[a-z,]+?[ ]+?(\w.+?)\s.+/$1/g'`
polyStyles=`egrep -v "(^#|^$| delete$| phstore$ z_order | way_area )"  "$file" | egrep "(^|,)way[, ]" | egrep ' polygon( |$)' | perl -pe 's/^[a-z,]+?[ ]+?(\w.+?)\s.+/$1/g'`

## Views
## Points
#select id as "osm_id", tags, o2p_calculate_zorder(tags) as z_order, ST_Transform(geom, 900913) as way;
node_head="CREATE VIEW render_osm_point AS SELECT id as osm_id, "
node_columns=""
node_middle="o2p_calculate_zorder(tags) as \"z_order\", ST_Transform(geom, 900913) as way FROM nodes WHERE "
node_where="(tags != ''::hstore AND tags is not null) AND ("

for node in $nodeStyles; do
  node_columns=$node_columns"  tags -> '$node' as \"$node\", "
  node_where=$node_where"  exist(tags, '$node') OR "
done
node_where=${node_where:0:-4}");"

node_view=$node_head$node_columns$node_middle$node_where
$node_view >> render_osm_point.sql

## Lines
select id as "osm_id", tags, o2p_calculate_zorder(tags) as z_order from ways
