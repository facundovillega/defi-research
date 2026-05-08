-- P3_23: Chief contract via traces de los proxies
SELECT
    "to" AS contrato,
    COUNT(*) AS n_calls
FROM ethereum.traces
WHERE "from" IN (
    0x0a3f6849f78076aefadf113f5bed87720274ddc0,
    0xde08aef2b221274231b3547491ec8f0fc80917e1,
    0xb02e05c257291acd65a527227aca6b7662e047f4
)
  AND block_time BETWEEN TIMESTAMP '2025-02-18' AND TIMESTAMP '2025-02-20'
  AND type = 'call'
GROUP BY 1
ORDER BY n_calls DESC
LIMIT 10
