-- CAPA 5A — Estructura keepers LUNA: distribución por frecuencia
SELECT
    n_takes,
    COUNT(*) AS n_keepers
FROM (
    SELECT
        topic2        AS keeper,
        COUNT(*)      AS n_takes
    FROM ethereum.logs
    WHERE contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
      AND topic0 = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
      AND block_time >= TIMESTAMP '2022-05-01 00:00:00'
      AND block_time <  TIMESTAMP '2022-07-01 00:00:00'
    GROUP BY topic2
) t
GROUP BY n_takes
ORDER BY n_takes
