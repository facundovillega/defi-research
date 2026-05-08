-- P3_17: Actividad de 0xdeb2f1 en el proxy antes del spell feb 2025
SELECT
    evt_block_time,
    "from",
    "to",
    CAST(value AS DOUBLE) / 1e18 AS mkr_amount
FROM erc20_ethereum.evt_Transfer
WHERE contract_address = 0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2
  AND ("from" = 0xdeb2f18819985145ef6c9ad1854744edc3c504e9
    OR "to" = 0xdeb2f18819985145ef6c9ad1854744edc3c504e9)
  AND evt_block_time BETWEEN TIMESTAMP '2024-10-01' AND TIMESTAMP '2025-02-20'
ORDER BY evt_block_time
