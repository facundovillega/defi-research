-- P3_09: Actividad sobre el spell feb 2025 antes de su ejecución
SELECT
    block_time,
    "from" AS caller,
    "to" AS contrato,
    hash
FROM ethereum.transactions
WHERE "to" = 0x1c8f5979a93ba0412677a9d315451de1570b3d03
  AND block_time < TIMESTAMP '2025-02-20 06:26:59'
ORDER BY block_time DESC
LIMIT 20
