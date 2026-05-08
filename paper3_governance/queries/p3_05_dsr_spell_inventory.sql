-- P3_05: Inventario de spells que cambiaron el DSR con timing
SELECT
    f.call_block_time AS timestamp_cast,
    f.call_tx_hash,
    f.call_tx_to AS spell_address,
    (bytearray_to_uint256(f.addr) / 1e27 - 1) * 100 * 365 * 24 * 3600 AS dsr_apy_approx,
    EXTRACT(DOW FROM f.call_block_time) AS day_of_week,
    EXTRACT(HOUR FROM f.call_block_time) AS hour_of_day
FROM maker_ethereum.Pot_call_file f
WHERE f.what = 0x6473720000000000000000000000000000000000000000000000000000000000
ORDER BY f.call_block_time
