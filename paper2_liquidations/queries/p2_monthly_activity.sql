SELECT
    DATE_TRUNC('month', block_time) AS month,
    COUNT(*)                         AS takes
FROM ethereum.logs
WHERE contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
  AND topic0           = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
  AND block_time >= TIMESTAMP '2021-01-01'
  AND block_time <  TIMESTAMP '2026-03-01'
GROUP BY 1
ORDER BY 1
