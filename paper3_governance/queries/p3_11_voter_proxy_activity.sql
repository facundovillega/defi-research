-- P3_11: MKR weight de los voters del spell feb 2025
SELECT
    block_time,
    "from" AS caller,
    "to" AS proxy_contract,
    hash
FROM ethereum.transactions
WHERE "to" IN (
    0xde08aef2b221274231b3547491ec8f0fc80917e1,
    0x1f68d75a0c7c2af84ef48d079a95cb5a0f413347,
    0xf1b837ec2ad556de5490f3fab600afb36670380d,
    0x0a3f6849f78076aefadf113f5bed87720274ddc0,
    0x5d4a96afadb5505a8ff21ddeca2baf3a63301396,
    0xb02e05c257291acd65a527227aca6b7662e047f4,
    0xe21125f4c35f11a1b4978c9cf9a7de4d2ecea406,
    0x389acaa51d1c4cc0e6a79c56920504551f650590
)
  AND block_time BETWEEN TIMESTAMP '2025-02-10' AND TIMESTAMP '2025-02-20'
ORDER BY block_time
