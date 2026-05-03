-- Colateral por keeper Tariff Shock — lot del Take event directamente
SELECT
    topic2                                                                AS keeper,
    COUNT(*)                                                              AS takes_won,
    ROUND(SUM(bytearray_to_uint256(substr(data, 65, 32)) / 1e18), 4)    AS total_lot_eth,
    ROUND(100.0 * SUM(bytearray_to_uint256(substr(data, 65, 32)) / 1e18)
          / SUM(SUM(bytearray_to_uint256(substr(data, 65, 32)) / 1e18)) OVER (), 4) AS share_pct
FROM ethereum.logs
WHERE contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
  AND topic0 = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
  AND block_time >= TIMESTAMP '2025-04-06 00:00:00'
  AND block_time <  TIMESTAMP '2025-04-07 00:00:00'
GROUP BY topic2
ORDER BY total_lot_eth DESC
LIMIT 10
