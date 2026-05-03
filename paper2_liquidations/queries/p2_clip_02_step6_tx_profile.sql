-- clip_02 STEP 6: Perfil de transacciones — tx_sender y bot_contract
-- Resultado: 128 takes, 19 EOAs distintas, todo en 2025-04-06 22:15-23:22 UTC
-- Top sender: 0xc0ffeebabe... con 38 takes via 0xe08d97...
-- 5 senders llaman directo al Clipper con gas ~141k y gwei alto
-- 0xc9a5... outlier con 4.2M gas — lógica multi-hop
SELECT
    t."from"                         AS tx_sender,
    t."to"                           AS bot_contract,
    COUNT(*)                         AS n_takes,
    ROUND(AVG(t.gas_used), 0)        AS avg_gas,
    ROUND(AVG(t.gas_price / 1e9), 2) AS avg_gas_gwei,
    MIN(t.block_time)                AS first_take,
    MAX(t.block_time)                AS last_take
FROM ethereum.logs l
INNER JOIN ethereum.transactions t ON l.tx_hash = t.hash
WHERE l.contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
  AND l.topic0           = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
  AND bytearray_substring(l.topic2, 13, 20) = 0xc721b4adb7ae6b1547809db207bc380ddc898887
  AND l.block_time >= TIMESTAMP '2023-01-01'
  AND l.block_time <  TIMESTAMP '2026-03-01'
GROUP BY 1, 2
ORDER BY n_takes DESC
