-- bt_03_funding_L1_0x6066.sql
-- Funding directo al keeper dominante 0x6066 durante Black Thursday
-- Resultado: 1 funder único, 5.5M DAI, 1229 transfers
-- Token: DAI (0x6b175474e89094c44da98b954eedeac495271d0f)
-- Funder L1: 0x4c8745fd25ba4b64d1b9af30ea07e617339faea8

SELECT
    contract_address                AS token,
    "from"                          AS funder,
    COUNT(*)                        AS n_transfers,
    SUM(value / 1e18)               AS total_dai
FROM erc20_ethereum.evt_transfer
WHERE "to"       = 0x6066be9369b4eaf5847c9f01eb52ae1e81f2d6b0
  AND evt_block_time >= TIMESTAMP '2020-03-01'
  AND evt_block_time <  TIMESTAMP '2020-03-30'
GROUP BY 1, 2
ORDER BY total_dai DESC
LIMIT 20
