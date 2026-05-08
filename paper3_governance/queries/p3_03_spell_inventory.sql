-- P3_03: Inventario completo de spells DSPause — 1:1 (primer lift, primer cast)
WITH lifts AS (
    SELECT
        MIN(block_time) AS timestamp_lift,
        bytearray_substring(topic2, 13, 20) AS spell_address
    FROM ethereum.logs
    WHERE contract_address = 0xbe286431454714f511008713973d3b053a2d38f3
      AND topic0 = 0x168ccd6700000000000000000000000000000000000000000000000000000000
    GROUP BY bytearray_substring(topic2, 13, 20)
),
casts AS (
    SELECT
        MIN(block_time) AS timestamp_cast,
        bytearray_substring(topic2, 13, 20) AS spell_address
    FROM ethereum.logs
    WHERE contract_address = 0xbe286431454714f511008713973d3b053a2d38f3
      AND topic0 = 0x46d2fbbb00000000000000000000000000000000000000000000000000000000
    GROUP BY bytearray_substring(topic2, 13, 20)
)
SELECT
    l.spell_address,
    l.timestamp_lift,
    c.timestamp_cast,
    DATE_DIFF('hour', l.timestamp_lift, c.timestamp_cast) AS hours_lift_to_cast
FROM lifts l
LEFT JOIN casts c ON l.spell_address = c.spell_address
ORDER BY l.timestamp_lift
