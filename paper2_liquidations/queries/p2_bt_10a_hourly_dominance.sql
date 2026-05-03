WITH hourly AS (
    SELECT
        DATE_TRUNC('hour', block_time)          AS hour_utc,
        bytearray_substring(topic1, 13, 20)     AS keeper,
        COUNT(*)                                AS bids
    FROM ethereum.logs
    WHERE contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
      AND bytearray_substring(topic0, 1, 4) = 0x4b43ed12
      AND block_time >= TIMESTAMP '2020-01-01'
      AND block_time <  TIMESTAMP '2021-07-01'
    GROUP BY 1, 2
)
SELECT
    hour_utc,
    keeper,
    bids,
    ROUND(100.0 * bids / SUM(bids) OVER (PARTITION BY hour_utc), 2) AS hourly_share_pct
FROM hourly
ORDER BY hour_utc, bids DESC
