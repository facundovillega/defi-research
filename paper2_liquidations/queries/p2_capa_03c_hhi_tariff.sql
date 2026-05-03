WITH hourly_keepers AS (
    SELECT
        DATE_TRUNC('hour', block_time) AS hour,
        topic2                          AS keeper,
        COUNT(*)                        AS takes
    FROM ethereum.logs
    WHERE contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
      AND topic0 = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
      AND block_time >= TIMESTAMP '2025-04-06 00:00:00'
      AND block_time <  TIMESTAMP '2025-04-07 00:00:00'
    GROUP BY 1, 2
),
hourly_totals AS (
    SELECT hour, SUM(takes) AS total FROM hourly_keepers GROUP BY hour
),
hhi AS (
    SELECT
        h.hour,
        t.total,
        SUM(POWER(CAST(h.takes AS DOUBLE) / t.total, 2)) * 10000 AS hhi
    FROM hourly_keepers h
    JOIN hourly_totals t ON h.hour = t.hour
    GROUP BY h.hour, t.total
)
SELECT hour, total AS takes, ROUND(hhi, 0) AS hhi
FROM hhi
ORDER BY hour
