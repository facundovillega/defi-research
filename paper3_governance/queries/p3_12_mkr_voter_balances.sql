-- P3_12: Transferencias MKR de los callers antes del voto
SELECT
    DATE_TRUNC('day', evt_block_time) AS dia,
    "from" AS wallet,
    SUM(CAST(value AS DOUBLE) / 1e18) AS mkr_transferido
FROM erc20_ethereum.evt_Transfer
WHERE contract_address = 0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2
  AND "from" IN (
    0x37d58532a985c2ad7a84ec61b0413cc4b2c48977,
    0xfe67cbec68b6e00d9327b4ecf32c0d526b60668d,
    0x4c2134abe86109db784a5d0a34c98251bb82a859,
    0xb4fb31e7b1471a8e52dd1e962a281a732ead59c1,
    0xd0b44469d0f230fc67d2e6d2e8d239699ed76bb5,
    0xd352a360cccb06fb23a8681c44e6b12a999ae7a0,
    0x0527c1f35cfae1051e3a3c28eb2255d7f0138469,
    0x8b4c184918947b52f615fc2ab350e092906b54cb,
    0x9ee034a566d5a5c583c1a74beff9014cfcaab77c
  )
  AND evt_block_time BETWEEN TIMESTAMP '2025-01-01' AND TIMESTAMP '2025-02-20'
GROUP BY 1, 2
ORDER BY dia, wallet
