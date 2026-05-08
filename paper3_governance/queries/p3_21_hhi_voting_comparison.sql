-- P3_21: HHI de votación — spell feb 2025 vs spell regular
WITH votes AS (
    SELECT
        CASE 
            WHEN evt_block_time <= TIMESTAMP '2025-02-20 06:26:59' 
            THEN 'feb2025_gsm'
            ELSE 'feb2025_dsr'
        END AS spell_type,
        "to" AS proxy,
        SUM(CAST(value AS DOUBLE) / 1e18) AS mkr_in
    FROM erc20_ethereum.evt_Transfer
    WHERE contract_address = 0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2
      AND "to" IN (
        0x0a3f6849f78076aefadf113f5bed87720274ddc0,
        0xde08aef2b221274231b3547491ec8f0fc80917e1,
        0x1f68d75a0c7c2af84ef48d079a95cb5a0f413347,
        0xf1b837ec2ad556de5490f3fab600afb36670380d,
        0x5d4a96afadb5505a8ff21ddeca2baf3a63301396,
        0xb02e05c257291acd65a527227aca6b7662e047f4,
        0xe21125f4c35f11a1b4978c9cf9a7de4d2ecea406,
        0x389acaa51d1c4cc0e6a79c56920504551f650590
      )
      AND evt_block_time BETWEEN TIMESTAMP '2025-02-01' AND TIMESTAMP '2025-02-25'
    GROUP BY 1, 2
),
totals AS (
    SELECT
        spell_type,
        SUM(mkr_in) AS total_mkr
    FROM votes
    GROUP BY spell_type
)
SELECT
    v.spell_type,
    v.proxy,
    v.mkr_in,
    ROUND(100.0 * v.mkr_in / t.total_mkr, 4) AS share_pct,
    ROUND(POWER(100.0 * v.mkr_in / t.total_mkr, 2), 4) AS hhi_contribution
FROM votes v
JOIN totals t ON v.spell_type = t.spell_type
ORDER BY v.spell_type, v.mkr_in DESC
