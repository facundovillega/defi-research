-- CAPA 3 — HHI horario BT
WITH hourly_keepers AS (
    SELECT
        DATE_TRUNC('hour', block_time)              AS hour,
        bytearray_substring(topic1, 13, 20)         AS keeper,
        COUNT(*)                                     AS tends
    FROM ethereum.logs
    WHERE contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
      AND bytearray_substring(topic0, 1, 4) = 0x4b43ed12
      AND block_time >= TIMESTAMP '2020-03-12 00:00:00'
      AND block_time <  TIMESTAMP '2020-03-14 00:00:00'
    GROUP BY 1, 2
),
hourly_totals AS (
    SELECT hour, SUM(tends) AS total FROM hourly_keepers GROUP BY hour
),
hhi AS (
    SELECT
        h.hour,
        t.total,
        SUM(POWER(CAST(h.tends AS DOUBLE) / t.total, 2)) * 10000 AS hhi
    FROM hourly_keepers h
    JOIN hourly_totals t ON h.hour = t.hour
    GROUP BY h.hour, t.total
)
SELECT hour, total AS tends, ROUND(hhi, 0) AS hhi
FROM hhi
ORDER BY hour
