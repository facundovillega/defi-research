-- P3_24: Verificar que 0xa618e54d es el Chief
SELECT
    topic0,
    COUNT(*) AS n
FROM ethereum.logs
WHERE contract_address = 0xa618e54de493ec29432ebd2ca7f14efbf6ac17f7
  AND block_time BETWEEN TIMESTAMP '2025-02-18' AND TIMESTAMP '2025-02-20'
GROUP BY 1
ORDER BY n DESC
