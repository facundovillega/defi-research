-- =============================================================================
-- PIT_H4_regression_data_v1.sql
-- Datos para regresión H4: DSR_t ~ spread_{t-1} + flap_count_{t-1}
-- Paper: "Programmatic Intermediation and Monetary Transmission"
-- Muestra: julio 2023 – abril 2026 (n≈95 semanas)
--
-- Fuentes:
--   maker_ethereum.Pot_call_file        → DSR (con forward-fill)
--   maker_ethereum.Vow_call_flap        → flap auctions (Surplus Buffer)
--   aave_v3_ethereum.Pool_evt_ReserveDataUpdated → Aave USDC V3
--
-- Output: week_start | dsr_pct | aave_usdc_pct | spread_pct
--         | flap_count | spread_lag1 | flap_count_lag1
--         → listo para lm(dsr_pct ~ spread_lag1 + flap_count_lag1)
-- =============================================================================

WITH

-- ── 1. DSR con forward-fill ────────────────────────────────────────────────
-- Traemos historial desde 2022 para tener valor inicial antes de la muestra
dsr_changes AS (
  SELECT
    call_block_time                                        AS ts,
    POWER(CAST(data AS double) / 1e27, 31557600) - 1      AS dsr_rate
  FROM maker_ethereum.Pot_call_file
  WHERE what = 0x6473720000000000000000000000000000000000000000000000000000000000
    AND call_block_time >= DATE '2022-01-01'
    AND call_block_time <  DATE '2026-05-01'
),

-- ── 2. Serie semanal completa (lunes a lunes) ──────────────────────────────
weeks AS (
  SELECT week_start
  FROM UNNEST(
    SEQUENCE(DATE '2023-07-03', DATE '2026-04-28', INTERVAL '7' DAY)
  ) AS t(week_start)
),

-- ── 3. DSR semanal por forward-fill ───────────────────────────────────────
dsr_weekly AS (
  SELECT
    w.week_start,
    MAX_BY(d.dsr_rate, d.ts) AS dsr_rate
  FROM weeks w
  JOIN dsr_changes d
    ON d.ts <= w.week_start + INTERVAL '7' DAY
  GROUP BY w.week_start
),

-- ── 4. Aave USDC V3 – último evento semanal ───────────────────────────────
aave_raw AS (
  SELECT
    date_trunc('week', evt_block_time)   AS week_start,
    CAST(liquidityRate AS double) / 1e27 AS aave_rate,
    evt_block_time,
    ROW_NUMBER() OVER (
      PARTITION BY date_trunc('week', evt_block_time)
      ORDER BY evt_block_time DESC
    ) AS rn
  FROM aave_v3_ethereum.Pool_evt_ReserveDataUpdated
  WHERE reserve = from_hex('A0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48')
    AND evt_block_time >= DATE '2023-07-01'
    AND evt_block_time <  DATE '2026-05-01'
),

aave_weekly AS (
  SELECT week_start, aave_rate
  FROM aave_raw
  WHERE rn = 1
),

-- ── 5. flap count semanal ─────────────────────────────────────────────────
-- Cada llamada a Vow.flap() es un auction del Surplus Buffer
flap_raw AS (
  SELECT
    date_trunc('week', call_block_time) AS week_start,
    COUNT(*)                            AS flap_count
  FROM maker_ethereum.Vow_call_flap
  WHERE call_block_time >= DATE '2023-07-01'
    AND call_block_time <  DATE '2026-05-01'
    AND call_success = TRUE
  GROUP BY 1
),

-- ── 6. Join y cálculo del spread ──────────────────────────────────────────
base AS (
  SELECT
    d.week_start,
    ROUND(d.dsr_rate * 100, 4)                             AS dsr_pct,
    ROUND(a.aave_rate * 100, 4)                            AS aave_usdc_pct,
    ROUND((d.dsr_rate - a.aave_rate) * 100, 4)            AS spread_pct,
    COALESCE(f.flap_count, 0)                              AS flap_count
  FROM dsr_weekly d
  JOIN aave_weekly a ON d.week_start = a.week_start
  LEFT JOIN flap_raw f ON d.week_start = f.week_start
),

-- ── 7. Lags para la regresión H4 ──────────────────────────────────────────
-- spread_{t-1} y flap_count_{t-1}: rezago de 1 semana
lagged AS (
  SELECT
    week_start,
    dsr_pct,
    aave_usdc_pct,
    spread_pct,
    flap_count,
    LAG(spread_pct,  1) OVER (ORDER BY week_start) AS spread_lag1,
    LAG(flap_count,  1) OVER (ORDER BY week_start) AS flap_count_lag1
  FROM base
)

-- ── 8. Output final ────────────────────────────────────────────────────────
-- Excluir primera fila (lag = NULL) y los dos outliers de alta volatilidad:
--   2023-07-24: aave_usdc = 32.7% (spike anómalo de liquidez)
--   2026-04-13: aave_usdc = 12.6% (post-tariff shock)
-- Para la regresión base se incluyen; filtrar en R si se desea muestra limpia.
SELECT
  week_start,
  dsr_pct,
  aave_usdc_pct,
  spread_pct,
  flap_count,
  spread_lag1,
  flap_count_lag1
FROM lagged
WHERE spread_lag1 IS NOT NULL          -- descarta primera observación
ORDER BY week_start

-- =============================================================================
-- USO EN R:
--
-- df <- <resultado de Dune>
-- modelo <- lm(dsr_pct ~ spread_lag1 + flap_count_lag1, data = df)
-- library(sandwich); library(lmtest)
-- nw <- coeftest(modelo, vcov = NeweyWest(modelo, lag = 4))
-- print(nw); cat("R2:", summary(modelo)$r.squared, "\n")
--
-- Resultados esperados (previos, SE OLS):
--   β_spread ≈ 0.734, β_flap ≈ -0.0077, R² ≈ 0.576, n ≈ 95
-- =============================================================================
