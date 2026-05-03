-- clip_01_market_share.sql
-- Dune: @facundovillega / clip_01_market_share
-- Contract: MCD_CLIP_ETH_A = 0xc67963a226eddd77b91ad8c421630a1b0adff270
-- Event: Take — topic0 = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
-- Keeper: topic2 (usr — segundo parámetro indexed)
-- Período: 2023-01-01 – 2026-03-01
-- Status: ✅ validado
 
WITH keeper_takes AS (
    SELECT
        topic2                                      AS keeper,
        COUNT(*)                                    AS takes
    FROM ethereum.logs
    WHERE contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
      AND topic0           = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
      AND block_time >= TIMESTAMP '2023-01-01'
      AND block_time <  TIMESTAMP '2026-03-01'
    GROUP BY topic2
)
SELECT
    keeper,
    takes,
    ROUND(100.0 * takes / SUM(takes) OVER (), 2)            AS market_share_pct,
    ROUND(POWER(100.0 * takes / SUM(takes) OVER (), 2), 2)  AS hhi_contribution
FROM keeper_takes
ORDER BY takes DESC
LIMIT 30
