-- P3_22: HHI de votación por spell — todos los spells 2024-2025
WITH spell_casts AS (
    SELECT
        call_block_time AS timestamp_cast,
        call_tx_hash,
        call_tx_to AS spell_address
    FROM maker_ethereum.Pot_call_file
    WHERE call_block_time >= TIMESTAMP '2024-01-01'
),
proxy_votes AS (
    SELECT
        DATE_TRUNC('day', evt_block_time) AS dia,
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
      AND evt_block_time >= TIMESTAMP '2024-01-01'
    GROUP BY 1, 2
),
spell_hhi AS (
    SELECT
        s.timestamp_cast,
        s.spell_address,
        v.proxy,
        v.mkr_in,
        SUM(v.mkr_in) OVER (PARTITION BY s.timestamp_cast) AS total_mkr,
        ROUND(POWER(100.0 * v.mkr_in / 
            SUM(v.mkr_in) OVER (PARTITION BY s.timestamp_cast), 2), 4) AS hhi_contribution
    FROM spell_casts s
    JOIN proxy_votes v 
        ON DATE_TRUNC('day', s.timestamp_cast) = v.dia
)
SELECT
    timestamp_cast,
    spell_address,
    SUM(hhi_contribution) AS hhi_total,
    MAX(mkr_in / total_mkr * 100) AS top1_share_pct,
    COUNT(DISTINCT proxy) AS n_proxies
FROM spell_hhi
GROUP BY 1, 2
ORDER BY timestamp_cast
