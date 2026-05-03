-- clip_02 STEP 2: Funding ERC-20 entrante
-- Resultado confirmado: 0 transfers — 0xc721 no recibe ERC-20 en ningún período
SELECT
    contract_address                AS token,
    "from"                          AS funder,
    COUNT(*)                        AS n_transfers,
    SUM(value / 1e18)               AS total_amount,
    MIN(evt_block_time)             AS first_transfer,
    MAX(evt_block_time)             AS last_transfer
FROM erc20_ethereum.evt_transfer
WHERE "to"             = 0xc721b4adb7ae6b1547809db207bc380ddc898887
  AND evt_block_time >= TIMESTAMP '2023-01-01'
  AND evt_block_time <  TIMESTAMP '2026-03-01'
GROUP BY 1, 2
ORDER BY total_amount DESC
LIMIT 20
