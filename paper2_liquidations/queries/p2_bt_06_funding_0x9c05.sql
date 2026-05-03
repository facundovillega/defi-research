-- bt_06_funding_0x9c05.sql
-- Resultado: sin funding externo durante BT (marzo 2020)
-- 0x9c05 operaba con saldo pre-cargado — capital propio
-- ERC-20: 5 transfers en febrero 2020 (pre-BT), ninguna en marzo
-- ETH nativo: 0 transfers en marzo 2020

SELECT
    'ERC20_pre_BT'                  AS period,
    contract_address                AS token,
    "from"                          AS funder,
    COUNT(*)                        AS n_transfers,
    SUM(value / 1e18)               AS total_amount,
    MIN(evt_block_time)             AS first_transfer,
    MAX(evt_block_time)             AS last_transfer
FROM erc20_ethereum.evt_transfer
WHERE "to"       = 0x9c05a05893ada984fc20d0da0c046de5cc0e8273
  AND evt_block_time >= TIMESTAMP '2020-01-01'
  AND evt_block_time <  TIMESTAMP '2021-01-01'
GROUP BY 1, 2, 3
ORDER BY total_amount DESC
