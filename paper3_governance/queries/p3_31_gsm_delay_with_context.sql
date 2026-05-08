-- P3_31: GSM delay histórico con contexto de eventos
WITH raw AS (
    SELECT
        block_time AS timestamp_change,
        tx_hash,
        CAST(bytearray_to_uint256(topic2) AS DOUBLE) / 3600 AS new_delay_hours
    FROM ethereum.logs
    WHERE contract_address = 0xbe286431454714f511008713973d3b053a2d38f3
      AND topic0 = 0xe177246e00000000000000000000000000000000000000000000000000000000
)
SELECT
    timestamp_change,
    tx_hash,
    new_delay_hours,
    CASE
        WHEN timestamp_change BETWEEN TIMESTAMP '2020-03-12' AND TIMESTAMP '2020-03-20' THEN 'Black Thursday'
        WHEN timestamp_change BETWEEN TIMESTAMP '2025-02-18' AND TIMESTAMP '2025-02-21' THEN 'GSM Spell feb2025'
        ELSE 'regular'
    END AS context,
    LAG(new_delay_hours) OVER (ORDER BY timestamp_change) AS prev_delay_hours,
    new_delay_hours - LAG(new_delay_hours) OVER (ORDER BY timestamp_change) AS delta_hours
FROM raw
ORDER BY timestamp_change
