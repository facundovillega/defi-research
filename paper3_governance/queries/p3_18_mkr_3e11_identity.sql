-- P3_18: Identidad de 0x3e11b0f1 y movimientos posteriores
SELECT
    evt_block_time,
    "from",
    "to",
    CAST(value AS DOUBLE) / 1e18 AS mkr_amount
FROM erc20_ethereum.evt_Transfer
WHERE contract_address = 0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2
  AND ("from" = 0x3e11b0f10e52bce034e4924d913e29a20e7cda9d
    OR "to" = 0x3e11b0f10e52bce034e4924d913e29a20e7cda9d)
  AND evt_block_time BETWEEN TIMESTAMP '2025-02-01' AND TIMESTAMP '2025-03-15'
ORDER BY evt_block_time
