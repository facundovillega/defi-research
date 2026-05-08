-- P3_10: Votos sobre el spell feb 2025 en el Chief
SELECT
    block_time,
    "from" AS caller,
    "to" AS contrato,
    data,
    hash
FROM ethereum.transactions
WHERE CAST(data AS VARCHAR) LIKE '%1c8f5979a93ba0412677a9d315451de1570b3d03%'
  AND block_time BETWEEN TIMESTAMP '2025-02-15' AND TIMESTAMP '2025-02-20'
ORDER BY block_time
