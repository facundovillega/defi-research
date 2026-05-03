-- GAP 1 corregido v2: offsets tomados de bt_02_zerobid_split
WITH kicks AS (
    SELECT
        bytearray_to_uint256(topic1)                                    AS usr,
        bytearray_to_uint256(bytearray_substring(data, 33, 32)) / 1e18 AS lot_eth
    FROM ethereum.logs
    WHERE contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
      AND topic0 = 0xc84ce3a1172f0dec3173f04caaa6005151a4bfe40d4c9f3ea28dba5f719b2a7a
      AND block_time >= TIMESTAMP '2020-03-12 00:00:00'
      AND block_time <  TIMESTAMP '2020-03-14 00:00:00'
),
positions AS (
    SELECT usr, SUM(lot_eth) AS total_lot
    FROM kicks GROUP BY usr
)
SELECT
    usr,
    total_lot,
    ROUND(100.0 * total_lot / SUM(total_lot) OVER (), 4) AS share_pct,
    SUM(total_lot) OVER ()                                AS grand_total_eth
FROM positions
ORDER BY total_lot DESC
LIMIT 10
