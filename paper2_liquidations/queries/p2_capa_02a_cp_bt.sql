-- CAPA 2 — CP BT: concentración posicional Black Thursday (Flipper ETH-A)
WITH keeper_bids AS (
    SELECT
        bytearray_substring(topic1, 13, 20) AS keeper,
        COUNT(*) AS bids
    FROM ethereum.logs
    WHERE contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
      AND bytearray_substring(topic0, 1, 4) = 0x4b43ed12
      AND block_time >= TIMESTAMP '2020-03-12'
      AND block_time <  TIMESTAMP '2020-03-14'
    GROUP BY 1
)
SELECT
    keeper,
    bids,
    ROUND(100.0 * bids / SUM(bids) OVER (), 4) AS share_pct,
    SUM(bids) OVER () AS grand_total_bids
FROM keeper_bids
ORDER BY bids DESC
LIMIT 10
