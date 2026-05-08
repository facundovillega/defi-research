-- P3_27: Pesos reales MKR al Chief — spell GSM feb 2025
WITH locks AS (
    SELECT
        call_tx_from AS voter,
        SUM(wad / 1e18) AS mkr_locked
    FROM maker_ethereum.dschief_call_lock
    WHERE call_block_time BETWEEN TIMESTAMP '2025-02-10' AND TIMESTAMP '2025-02-20 06:26:59'
    GROUP BY 1
),
frees AS (
    SELECT
        call_tx_from AS voter,
        SUM(wad / 1e18) AS mkr_freed
    FROM maker_ethereum.dschief_call_free
    WHERE call_block_time BETWEEN TIMESTAMP '2025-02-10' AND TIMESTAMP '2025-02-20 06:26:59'
    GROUP BY 1
)
SELECT
    l.voter,
    l.mkr_locked,
    COALESCE(f.mkr_freed, 0) AS mkr_freed,
    l.mkr_locked - COALESCE(f.mkr_freed, 0) AS mkr_net,
    ROUND(100.0 * (l.mkr_locked - COALESCE(f.mkr_freed, 0)) /
        SUM(l.mkr_locked - COALESCE(f.mkr_freed, 0)) OVER (), 4) AS share_pct
FROM locks l
LEFT JOIN frees f ON l.voter = f.voter
WHERE l.mkr_locked - COALESCE(f.mkr_freed, 0) > 0
ORDER BY mkr_net DESC
LIMIT 20
