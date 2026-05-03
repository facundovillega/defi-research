-- clip_02 STEP 5: Traces entrantes
-- Resultado confirmado: 0 traces — 0xc721 no recibe ETH via internal calls
SELECT
    block_time,
    tx_hash,
    "from"                          AS sender,
    "to"                            AS receiver,
    CAST(value AS DOUBLE) / 1e18    AS eth_amount,
    call_type
FROM ethereum.traces
WHERE "to"       = 0xc721b4adb7ae6b1547809db207bc380ddc898887
  AND CAST(value AS DOUBLE) > 0
  AND block_time >= TIMESTAMP '2022-01-01'
  AND block_time <  TIMESTAMP '2026-03-01'
ORDER BY eth_amount DESC
LIMIT 20
