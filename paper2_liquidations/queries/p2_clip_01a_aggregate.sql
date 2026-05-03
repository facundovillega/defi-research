-- clip_01_aggregate.sql
-- Dune: @facundovillega / clip_01_aggregate
-- Totales del mercado Clipper ETH-A: n_keepers, total_takes, HHI
-- Status: ✅ validado
-- Resultado: n_keepers=73, total_takes=238, HHI=2962
 
WITH takes AS (
    SELECT
        topic2          AS keeper,
        COUNT(*)        AS n_takes
    FROM ethereum.logs
    WHERE contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
      AND topic0           = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
      AND block_time >= TIMESTAMP '2023-01-01'
      AND block_time <  TIMESTAMP '2026-03-01'
    GROUP BY topic2
),
grand_total AS (
    SELECT
        COUNT(DISTINCT keeper)  AS n_keepers,
        SUM(n_takes)            AS total_takes
    FROM takes
),
hhi_calc AS (
    SELECT
        ROUND(SUM(POWER(100.0 * t.n_takes / g.total_takes, 2)), 0) AS hhi
    FROM takes t
    CROSS JOIN grand_total g
)
SELECT
    g.n_keepers,
    g.total_takes,
    h.hhi
FROM grand_total g
CROSS JOIN hhi_calc h
 
