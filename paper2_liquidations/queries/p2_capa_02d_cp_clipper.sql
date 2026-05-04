-- CAPA 2 — CP Clipper: concentración posicional período completo
WITH kicks AS (
    SELECT
        bytearray_to_uint256(topic2)                       AS usr,
        bytearray_to_uint256(substr(data, 65, 32)) / 1e18  AS lot_eth
    FROM ethereum.logs
    WHERE contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
      AND topic0 = 0x7c5bfdc0a5e8192f6cd4972f382cec69116862fb62e6abff8003874c58e064b8
),
positions AS (
    SELECT usr, SUM(lot_eth) AS total_lot
    FROM kicks
    GROUP BY usr
)
SELECT
    usr,
    total_lot,
    ROUND(100.0 * total_lot / SUM(total_lot) OVER (), 4) AS share_pct,
    SUM(total_lot) OVER () AS grand_total_eth
FROM positions
ORDER BY total_lot DESC
LIMIT 10
