-- P3_19: MKR total depositado en los proxies votantes al momento del spell
SELECT
    "to" AS proxy,
    SUM(CAST(value AS DOUBLE) / 1e18) AS mkr_total
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
  AND evt_block_time <= TIMESTAMP '2025-02-19 00:30:00'
  AND evt_block_time >= TIMESTAMP '2025-02-01'
GROUP BY 1
ORDER BY mkr_total DESC
