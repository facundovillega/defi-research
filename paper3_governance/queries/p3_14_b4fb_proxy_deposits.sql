-- P3_14: Historial completo de depósitos al proxy por 0xb4fb31e7
SELECT
    evt_block_time,
    "from",
    "to",
    CAST(value AS DOUBLE) / 1e18 AS mkr_amount
FROM erc20_ethereum.evt_Transfer
WHERE contract_address = 0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2
  AND "from" = 0xb4fb31e7b1471a8e52dd1e962a281a732ead59c1
  AND "to" = 0x0a3f6849f78076aefadf113f5bed87720274ddc0
ORDER BY evt_block_time
