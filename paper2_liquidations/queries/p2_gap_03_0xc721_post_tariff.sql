-- GAP 3: Actividad de 0xc721 después del 6 de abril 2025
SELECT
    DATE_TRUNC('month', block_time) AS month,
    COUNT(*)                         AS takes
FROM ethereum.logs
WHERE contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
  AND topic0 = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
  AND topic2 = 0x000000000000000000000000c721b4adb7ae6b1547809db207bc380ddc898887
  AND block_time >= TIMESTAMP '2025-04-07 00:00:00'
  AND block_time <  TIMESTAMP '2026-04-01'
GROUP BY 1
ORDER BY 1
