-- Colateral liquidado por keeper BT (corregido)
WITH tends AS (
    SELECT
        bytearray_substring(topic1, 13, 20)  AS keeper,
        bytearray_to_uint256(topic2)          AS auction_id,
        block_time
    FROM ethereum.logs
    WHERE contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
      AND bytearray_substring(topic0, 1, 4) = 0x4b43ed12
      AND block_time >= TIMESTAMP '2020-03-12 00:00:00'
      AND block_time <  TIMESTAMP '2020-03-14 00:00:00'
),
kicks AS (
    SELECT
        bytearray_to_uint256(bytearray_substring(data, 1,  32))        AS auction_id,
        bytearray_to_uint256(bytearray_substring(data, 33, 32)) / 1e18 AS lot_eth
    FROM ethereum.logs
    WHERE contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
      AND topic0 = 0xc84ce3a1172f0dec3173f04caaa6005151a4bfe40d4c9f3ea28dba5f719b2a7a
      AND block_time >= TIMESTAMP '2020-03-12 00:00:00'
      AND block_time <  TIMESTAMP '2020-03-14 00:00:00'
),
first_tend AS (
    SELECT
        auction_id,
        MIN(block_time) AS first_time
    FROM tends
    GROUP BY auction_id
),
winner AS (
    SELECT t.auction_id, t.keeper
    FROM tends t
    JOIN first_tend f ON t.auction_id = f.auction_id AND t.block_time = f.first_time
)
SELECT
    w.keeper,
    COUNT(*)                                                             AS auctions_won,
    ROUND(SUM(k.lot_eth), 4)                                            AS total_lot_eth,
    ROUND(100.0 * SUM(k.lot_eth) / SUM(SUM(k.lot_eth)) OVER (), 4)     AS share_pct
FROM winner w
JOIN kicks k ON w.auction_id = k.auction_id
GROUP BY w.keeper
ORDER BY total_lot_eth DESC
LIMIT 10
