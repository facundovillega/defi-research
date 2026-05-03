-- GAP 2: Actividad de 0xc721 en todos los contratos Clipper
SELECT
    contract_address,
    COUNT(*)         AS takes,
    MIN(block_time)  AS first_take,
    MAX(block_time)  AS last_take
FROM ethereum.logs
WHERE topic0 = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
  AND topic2 = 0x000000000000000000000000c721b4adb7ae6b1547809db207bc380ddc898887
  AND block_time >= TIMESTAMP '2023-01-01'
  AND block_time <  TIMESTAMP '2026-04-01'
GROUP BY contract_address
ORDER BY takes DESC
