-- P3_06: Historial de cambios al GSM Pause Delay
SELECT
    block_time,
    tx_hash,
    bytearray_to_uint256(topic2) / 3600 AS new_delay_hours
FROM ethereum.logs
WHERE contract_address = 0xbe286431454714f511008713973d3b053a2d38f3
  AND topic0 = 0xe177246e00000000000000000000000000000000000000000000000000000000
ORDER BY block_time
