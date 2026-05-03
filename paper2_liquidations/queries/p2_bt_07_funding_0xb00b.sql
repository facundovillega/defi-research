SELECT
    contract_address                AS token,
    "from"                          AS funder,
    COUNT(*)                        AS n_transfers,
    SUM(value / 1e18)               AS total_amount
FROM erc20_ethereum.evt_transfer
WHERE "to"       = 0xb00b6d69822da235a99d2242376066507c9a97b7
  AND evt_block_time >= TIMESTAMP '2020-03-01'
  AND evt_block_time <  TIMESTAMP '2020-03-30'
GROUP BY 1, 2
ORDER BY total_amount DESC
