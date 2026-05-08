-- P3_29: HHI real por spell — todos los spells 2024-2025
WITH spell_windows AS (
    SELECT
        call_block_time AS timestamp_cast,
        call_tx_to AS spell_address,
        LAG(call_block_time) OVER (ORDER BY call_block_time) AS prev_cast
    FROM maker_ethereum.Pot_call_file
    WHERE call_block_time >= TIMESTAMP '2024-01-01'
),
locks AS (
    SELECT
        s.timestamp_cast,
        s.spell_address,
        l.call_tx_from AS voter,
        SUM(l.wad / 1e18) AS mkr_locked
    FROM spell_windows s
    JOIN maker_ethereum.dschief_call_lock l
        ON l.call_block_time > COALESCE(s.prev_cast, TIMESTAMP '2024-01-01')
        AND l.call_block_time <= s.timestamp_cast
    GROUP BY 1, 2, 3
),
frees AS (
    SELECT
        s.timestamp_cast,
        l.call_tx_from AS voter,
        SUM(l.wad / 1e18) AS mkr_freed
    FROM spell_windows s
    JOIN maker_ethereum.dschief_call_free l
        ON l.call_block_time > COALESCE(s.prev_cast, TIMESTAMP '2024-01-01')
        AND l.call_block_time <= s.timestamp_cast
    GROUP BY 1, 2
),
net AS (
    SELECT
        l.timestamp_cast,
        l.spell_address,
        l.voter,
        l.mkr_locked - COALESCE(f.mkr_freed, 0) AS mkr_net
    FROM locks l
    LEFT JOIN frees f ON l.timestamp_cast = f.timestamp_cast AND l.voter = f.voter
    WHERE l.mkr_locked - COALESCE(f.mkr_freed, 0) > 0
),
totals AS (
    SELECT
        timestamp_cast,
        SUM(mkr_net) AS total_mkr
    FROM net
    GROUP BY 1
)
SELECT
    n.timestamp_cast,
    n.spell_address,
    COUNT(DISTINCT n.voter) AS n_voters,
    t.total_mkr,
    SUM(POWER(100.0 * n.mkr_net / t.total_mkr, 2)) AS hhi,
    MAX(100.0 * n.mkr_net / t.total_mkr) AS top1_share_pct
FROM net n
JOIN totals t ON n.timestamp_cast = t.timestamp_cast
GROUP BY 1, 2, t.total_mkr
ORDER BY n.timestamp_cast
