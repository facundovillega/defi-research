-- H4 — Capa 1: Actividad mensual de 0x6066 fuera de Black Thursday
-- Flip ETH-A: 0xd8a04f5412223f513dc55f839574430f5ec15531
-- tend() selector: 0x4b43ed12

SELECT
    DATE_TRUNC('month', block_time) AS month,
    COUNT(*)                         AS tends
FROM ethereum.logs
WHERE contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
  AND bytearray_substring(topic0, 1, 4) = 0x4b43ed12
  AND bytearray_substring(topic1, 13, 20) = 0x6066be9369b4eaf5847c9f01eb52ae1e81f2d6b0
  AND block_time >= TIMESTAMP '2019-01-01'
  AND block_time <  TIMESTAMP '2021-07-01'
GROUP BY 1
ORDER BY 1
