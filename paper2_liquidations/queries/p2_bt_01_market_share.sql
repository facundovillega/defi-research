WITH keeper_bids AS (
    SELECT
        topic1          AS keeper,
        COUNT(*)        AS bids
    FROM ethereum.logs
    WHERE contract_address = 0xf32836b9e1f47a0515c6ec431592d5ebc276407f
      AND CAST(topic0 AS VARCHAR) LIKE '0x4b43ed12%'
      AND block_time >= TIMESTAMP '2020-01-01'
      AND block_time <  TIMESTAMP '2021-07-01'
    GROUP BY topic1
)
SELECT
    keeper,
    bids,
    ROUND(100.0 * bids / SUM(bids) OVER (), 2)            AS market_share_pct,
    ROUND(POWER(100.0 * bids / SUM(bids) OVER (), 2), 2)  AS hhi_contribution
FROM keeper_bids
ORDER BY bids DESC
