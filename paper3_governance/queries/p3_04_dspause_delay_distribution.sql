-- P3_04: Distribución del delay lift→cast por año
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
),
spells AS (
    SELECT
        l.spell_address,
        l.timestamp_lift,
        c.timestamp_cast,
        DATE_DIFF('hour', l.timestamp_lift, c.timestamp_cast) AS hours_lift_to_cast
    FROM lifts l
    LEFT JOIN casts c ON l.spell_address = c.spell_address
)
SELECT
    YEAR(timestamp_cast) AS anio,
    COUNT(*) AS n_spells,
    MIN(hours_lift_to_cast) AS min_hours,
    MAX(hours_lift_to_cast) AS max_hours,
    AVG(hours_lift_to_cast) AS avg_hours,
    COUNT(CASE WHEN hours_lift_to_cast < 0 THEN 1 END) AS n_negativos,
    COUNT(CASE WHEN hours_lift_to_cast BETWEEN 0 AND 30 THEN 1 END) AS n_rapidos
FROM spells
GROUP BY YEAR(timestamp_cast)
ORDER BY anio
