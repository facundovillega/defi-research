SELECT
    MIN(block_number)   AS first_block,
    MAX(block_number)   AS last_block,
    MIN(block_time)     AS first_time,
    MAX(block_time)     AS last_time,
    COUNT(*)            AS total_tend_events
FROM ethereum.logs
WHERE contract_address = 0xf32836b9e1f47a0515c6ec431592d5ebc276407f
  AND CAST(topic0 AS VARCHAR) LIKE '0x4b43ed12%'
  AND block_time >= TIMESTAMP '2020-01-01'
  AND block_time <  TIMESTAMP '2021-07-01'
