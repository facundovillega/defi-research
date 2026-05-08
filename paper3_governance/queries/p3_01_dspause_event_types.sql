SELECT
    topic0,
    COUNT(*) AS n
FROM ethereum.logs
WHERE contract_address = 0xbe286431454714f511008713973d3b053a2d38f3
GROUP BY topic0
ORDER BY n DESC
