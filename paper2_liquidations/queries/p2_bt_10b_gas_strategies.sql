SELECT
    bytearray_substring(l.topic1, 13, 20)               AS keeper,
    COUNT(*)                                             AS n_bids,
    ROUND(AVG(t.gas_price / 1e9), 1)                    AS avg_gas_gwei,
    ROUND(MAX(t.gas_price / 1e9), 1)                    AS max_gas_gwei,
    ROUND(AVG(CAST(t.gas_used AS DOUBLE)), 0)           AS avg_gas_used,
    ROUND(AVG(t.gas_price / 1e9 * t.gas_used / 1e9), 4) AS avg_cost_eth
FROM ethereum.logs l
INNER JOIN ethereum.transactions t ON l.tx_hash = t.hash
WHERE l.contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
  AND bytearray_substring(l.topic0, 1, 4) = 0x4b43ed12
  AND l.block_time >= TIMESTAMP '2020-03-12'
  AND l.block_time <  TIMESTAMP '2020-03-14'
GROUP BY 1
ORDER BY avg_gas_gwei DESC
