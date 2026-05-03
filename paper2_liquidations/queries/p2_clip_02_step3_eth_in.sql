-- clip_02 STEP 3: ETH nativo entrante
-- Resultado confirmado: total_txs_in=0, first_tx=null, last_tx=null, total_eth_in=0
SELECT
    COUNT(*)                          AS total_txs_in,
    MIN(block_time)                   AS first_tx,
    MAX(block_time)                   AS last_tx,
    SUM(CAST(value AS DOUBLE) / 1e18) AS total_eth_in
FROM ethereum.transactions
WHERE "to"       = 0xc721b4adb7ae6b1547809db207bc380ddc898887
  AND block_time >= TIMESTAMP '2022-01-01'
  AND block_time <  TIMESTAMP '2026-03-01'
