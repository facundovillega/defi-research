SELECT
    block_time,
    block_number,
    tx_hash,
    bytearray_substring(topic1, 13, 20)     AS keeper,
    topic2                                   AS auction_id
FROM ethereum.logs
WHERE contract_address = 0xd8a04f5412223f513dc55f839574430f5ec15531
  AND bytearray_substring(topic0, 1, 4) = 0x4b43ed12
  AND bytearray_substring(topic1, 13, 20) = 0x6066be9369b4eaf5847c9f01eb52ae1e81f2d6b0
  AND block_time >= TIMESTAMP '2020-01-01'
  AND block_time <  TIMESTAMP '2021-07-01'
ORDER BY block_time
