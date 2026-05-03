-- GAP 4: Market share por sub-período LUNA
WITH base AS (
    SELECT
        CASE
            WHEN block_time < TIMESTAMP '2022-05-15' THEN '1_depeg_inicial'
            WHEN block_time < TIMESTAMP '2022-06-01' THEN '2_segunda_oleada'
            ELSE '3_celsius_3ac'
        END     AS sub_periodo,
        topic2  AS keeper,
        COUNT(*) AS takes
    FROM ethereum.logs
    WHERE contract_address = 0xc67963a226eddd77b91ad8c421630a1b0adff270
      AND topic0 = 0x05e309fd6ce72f2ab888a20056bb4210df08daed86f21f95053deb19964d86b1
      AND block_time >= TIMESTAMP '2022-05-01'
      AND block_time <  TIMESTAMP '2022-07-01'
    GROUP BY 1, 2
),
totals AS (
    SELECT sub_periodo, SUM(takes) AS total
    FROM base GROUP BY sub_periodo
)
SELECT
    b.sub_periodo,
    t.total                                                              AS total_takes,
    COUNT(*)                                                             AS n_keepers,
    MAX(b.takes)                                                         AS top1_takes,
    ROUND(100.0 * MAX(b.takes) / t.total, 4)                            AS top1_share_pct,
    ROUND(SUM(POWER(CAST(b.takes AS DOUBLE) / t.total, 2)) * 10000, 0) AS hhi
FROM base b
JOIN totals t ON b.sub_periodo = t.sub_periodo
GROUP BY b.sub_periodo, t.total
ORDER BY b.sub_periodo
