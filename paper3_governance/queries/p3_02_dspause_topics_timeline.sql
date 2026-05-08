SELECT
    topic0,
    MIN(block_time) AS primer_evento,
    MAX(block_time) AS ultimo_evento
FROM ethereum.logs
WHERE contract_address = 0xbe286431454714f511008713973d3b053a2d38f3
GROUP BY topic0
ORDER BY primer_evento
