-- ============================================================
-- PIT_OU_spread_calibration_v1.sql
-- Spread semanal DSR / Aave USDC — calibración proceso OU
-- Muestra: jul 2023 – abr 2026 (forward-fill DSR entre spells)
-- Paper: "Inertial Deposits and Monetary Transmission"
-- Autor: Facundo Villega · Abril 2026
-- Plataforma: Dune Analytics · DuneSQL dialect
-- ============================================================

WITH

-- ── 1. Cambios de DSR (Pot.file) ─────────────────────────────────────────────
-- Se trae historial desde 2022 para garantizar valor inicial en el forward-fill.
-- what = bytes32("dsr") = 0x6473720000...0000
dsr_changes AS (
  SELECT
    call_block_time                                          AS ts,
    POWER(CAST(data AS double) / 1e27, 31557600) - 1        AS dsr_rate
  FROM maker_ethereum.Pot_call_file
  WHERE what = 0x6473720000000000000000000000000000000000000000000000000000000000
    AND call_block_time >= DATE '2022-01-01'
    AND call_block_time <  DATE '2026-05-01'
),

-- ── 2. Serie semanal completa ─────────────────────────────────────────────────
-- Genera todas las semanas del período de análisis.
weeks AS (
  SELECT week_start
  FROM UNNEST(
    SEQUENCE(DATE '2023-07-03', DATE '2026-04-28', INTERVAL '7' DAY)
  ) AS t(week_start)
),

-- ── 3. DSR con forward-fill ───────────────────────────────────────────────────
-- Para cada semana toma el último cambio de DSR ocurrido hasta ese momento.
-- El DSR es constante entre spells de governance; este CTE lo propaga.
dsr_weekly AS (
  SELECT
    w.week_start,
    MAX_BY(d.dsr_rate, d.ts) AS dsr_rate
  FROM weeks w
  JOIN dsr_changes d ON d.ts <= w.week_start + INTERVAL '7' DAY
  GROUP BY w.week_start
),

-- ── 4. Aave V3 USDC supply rate (ReserveDataUpdated) ─────────────────────────
-- Último evento de la semana por semana (snapshot de cierre).
-- reserve = USDC mainnet: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
aave_raw AS (
  SELECT
    date_trunc('week', evt_block_time)    AS week_start,
    CAST(liquidityRate AS double) / 1e27  AS aave_rate,
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
)

-- ── 5. Output final ───────────────────────────────────────────────────────────
SELECT
  dsr_weekly.week_start,
  ROUND(dsr_weekly.dsr_rate  * 100, 4)                            AS dsr_pct,
  ROUND(aave_weekly.aave_rate * 100, 4)                           AS aave_usdc_pct,
  ROUND((dsr_weekly.dsr_rate - aave_weekly.aave_rate) * 100, 4)  AS spread_pct
FROM dsr_weekly
JOIN aave_weekly ON dsr_weekly.week_start = aave_weekly.week_start
ORDER BY dsr_weekly.week_start

-- ── Notas de uso ──────────────────────────────────────────────────────────────
-- Outliers identificados (excluir en calibración OU, Opción A):
--   2023-07-24: aave_usdc_pct = 32.71 (spike de liquidez, no estructural)
--   2026-04-13: aave_usdc_pct = 12.60 (post-tariff shock)
--
-- Muestra de calibración OU (Opción A — metodológicamente correcta):
--   jul 2023 – abr 2025, n = 94 semanas (spread positivo, régimen activo)
--   Resultados: κ = 17.72, μ = 1.08%, σ = 15.36%, semivida = 2 semanas
--   ADF t-stat = -4.32 (rechaza H0 raíz unitaria al 1%, VC = -3.51)
--
-- Cambio de régimen estructural: ~mayo 2025
--   El spread se vuelve negativo de forma sostenida cuando DSR < Aave USDC.
--   El período post-mayo 2025 documenta el fin del régimen activo del modelo.
