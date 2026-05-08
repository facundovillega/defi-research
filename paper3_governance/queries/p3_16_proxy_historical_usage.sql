-- P3_16: Actividad histórica del proxy 0x0a3f6849 — quién lo usó antes de feb 2025
SELECT
    DATE_TRUNC('month', evt_block_time) AS mes,
    "from" AS wallet,
    SUM(CAST(value AS DOUBLE) / 1e18) AS mkr_depositado
FROM erc20_ethereum.evt_Transfer
WHERE contract_address = 0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2
  AND "to" = 0x0a3f6849f78076aefadf113f5bed87720274ddc0
  AND evt_block_time < TIMESTAMP '2025-02-01'
GROUP BY 1, 2
ORDER BY mes DESC
LIMIT 30
