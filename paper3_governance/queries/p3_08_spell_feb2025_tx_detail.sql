-- P3_08: Identificar contrato Chief desde la tx del spell feb 2025
SELECT
    block_time,
    hash,
    "to" AS contrato,
    "from" AS caller
FROM ethereum.transactions
WHERE hash = 0xd87e28b4fa44143c21e925404f027ee1ab881ace0540ae65b34cd853213ff4ad
