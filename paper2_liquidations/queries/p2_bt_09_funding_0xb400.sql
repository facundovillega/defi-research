SELECT
    contract_address                AS token,
    "from"                          AS funder,
    COUNT(*)                        AS n_transfers,
    SUM(value / 1e18)               AS total_amount,
    MIN(evt_block_time)             AS first_transfer,
    MAX(evt_block_time)             AS last_transfer
FROM erc20_ethereum.evt_transfer
WHERE "to"             = 0x9631a838a81d4050c43c66bc03a0cf414243f661
  AND evt_block_time >= TIMESTAMP '2020-03-01'
  AND evt_block_time <  TIMESTAMP '2020-03-30'
GROUP BY 1, 2
ORDER BY total_amount DESC
