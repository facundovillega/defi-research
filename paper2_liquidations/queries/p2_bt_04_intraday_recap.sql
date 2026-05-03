SELECT
    DATE_TRUNC('hour', block_time)                      AS hour_utc,
    bytearray_substring(topic1, 13, 20)                 AS keeper,
    COUNT(*)                                            AS bids,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (
        PARTITION BY DATE_TRUNC('hour', block_time)
    ), 2)                                               AS share_in_hour
FROM ethereum.logs
WHERE contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
  AND bytearray_substring(topic0, 1, 4) = 0x4b43ed12
  AND block_time >= TIMESTAMP '2020-03-12'
  AND block_time <  TIMESTAMP '2020-03-14'
GROUP BY 1, 2
ORDER BY 1, bids DESC
