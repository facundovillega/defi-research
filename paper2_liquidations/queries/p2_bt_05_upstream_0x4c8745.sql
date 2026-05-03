SELECT
    "from"                          AS funder_l2,
    COUNT(*)                        AS n_transfers,
    SUM(value / 1e18)               AS total_dai,
    MIN(evt_block_time)             AS first_transfer,
    MAX(evt_block_time)             AS last_transfer
FROM erc20_ethereum.evt_transfer
WHERE "to"             = 0x4c8745fd25ba4b64d1b9af30ea07e617339faea8
  AND contract_address = 0x6b175474e89094c44da98b954eedeac495271d0f
  AND evt_block_time >= TIMESTAMP '2020-03-01'
  AND evt_block_time <  TIMESTAMP '2020-03-30'
GROUP BY 1
ORDER BY total_dai DESC
