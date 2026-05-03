-- CAPA 5B — Keepers LUNA: nuevos vs. preexistentes
WITH luna_keepers AS (
    SELECT DISTINCT topic2 AS keeper
    FROM ethereum.logs
    WHERE contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
      AND topic0 = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
      AND block_time >= TIMESTAMP '2022-05-01 00:00:00'
      AND block_time <  TIMESTAMP '2022-07-01 00:00:00'
),
prior_activity AS (
    SELECT DISTINCT topic2 AS keeper
    FROM ethereum.logs
    WHERE contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
      AND topic0 = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
      AND block_time <  TIMESTAMP '2022-05-01 00:00:00'
)
SELECT
    COUNT(*)                                          AS total_luna_keepers,
    SUM(CASE WHEN p.keeper IS NOT NULL THEN 1 ELSE 0 END) AS con_actividad_previa,
    SUM(CASE WHEN p.keeper IS NULL     THEN 1 ELSE 0 END) AS nuevos
FROM luna_keepers l
LEFT JOIN prior_activity p ON l.keeper = p.keeper
