-- P3_20: Actividad en proxy 0x0a3f6849 alrededor del spell regular feb 24 2025
SELECT
    evt_block_time,
    "from",
    "to",
    CAST(value AS DOUBLE) / 1e18 AS mkr_amount
FROM erc20_ethereum.evt_Transfer
WHERE contract_address = 0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2
  AND ("from" = 0x0a3f6849f78076aefadf113f5bed87720274ddc0
    OR "to" = 0x0a3f6849f78076aefadf113f5bed87720274ddc0)
  AND evt_block_time BETWEEN TIMESTAMP '2025-02-20' AND TIMESTAMP '2025-02-25'
ORDER BY evt_block_time
