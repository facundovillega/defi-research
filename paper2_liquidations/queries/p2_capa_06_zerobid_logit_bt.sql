WITH kicks AS (
    SELECT
        bytearray_to_uint256(bytearray_substring(data, 1,  32))          AS auction_id,
        bytearray_to_uint256(bytearray_substring(data, 33, 32)) / 1e18   AS lot_eth,
        bytearray_to_uint256(bytearray_substring(data, 97, 32)) / 1e45   AS tab_dai,
        block_time                                                         AS kick_time,
        DATE_DIFF('hour', TIMESTAMP '2020-03-12 00:00:00', block_time)    AS hours_from_start,
        CASE WHEN block_time >= TIMESTAMP '2020-03-13 00:00:00'
             THEN 1 ELSE 0 END                                            AS day2
    FROM ethereum.logs
    WHERE contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
      AND topic0 = 0xc84ce3a1172f0dec3173f04caaa6005151a4bfe40d4c9f3ea28dba5f719b2a7a
      AND block_time BETWEEN TIMESTAMP '2020-03-12 00:00:00'
                         AND TIMESTAMP '2020-03-14 00:00:00'
),
tends AS (
    SELECT
        bytearray_to_uint256(topic2) AS auction_id,
        COUNT(*)                      AS n_bids
    FROM ethereum.logs
    WHERE contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
      AND topic0 = 0x4b43ed1200000000000000000000000000000000000000000000000000000000
      AND bytearray_to_uint256(topic2) BETWEEN 1822 AND 2749
    GROUP BY 1
)
SELECT
    k.auction_id,
    k.lot_eth,
    k.tab_dai,
    k.hours_from_start,
    k.day2,
    CASE WHEN COALESCE(t.n_bids, 0) = 0 THEN 1 ELSE 0 END AS zero_bid
FROM kicks k
LEFT JOIN tends t ON k.auction_id = t.auction_id
ORDER BY k.auction_id
