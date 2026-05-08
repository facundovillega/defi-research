-- P3_15: Fecha de creación del proxy 0x0a3f6849
SELECT
    block_time,
    tx_hash,
    "from" AS deployer
FROM ethereum.traces
WHERE address = 0x0a3f6849f78076aefadf113f5bed87720274ddc0
  AND type = 'create'
ORDER BY block_time
LIMIT 5
