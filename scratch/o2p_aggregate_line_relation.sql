--DROP FUNCTION o2p_aggregate_line_relation(bigint);
CREATE OR REPLACE FUNCTION o2p_aggregate_line_relation(
  bigint
) returns geometry[] AS $o2p_aggregate_line_relation$
DECLARE
  v_rel_id ALIAS for $1;
  v_way geometry[];
BEGIN

SELECT
  geom as route
FROM
  o2p_aggregate_relation(v_rel_id) -- (2301099) rt 13 for testing
  INTO
    v_way;

 RETURN v_way;
END;
$o2p_aggregate_line_relation$ LANGUAGE plpgsql;
