# Paper 1 — Inertial Deposits and Monetary Transmission
*A Theory of Programmatic Intermediation*

**Working Paper v19 · JEL: E40 · E52 · G20 · G23 · O33**

→ Back to [repository index](../README.md)

---

## Abstract

This paper develops a formal theoretical framework for monetary markets in which a fraction λ of the deposit stock is managed by autonomous contracts — Programmatic Deposit Agents (PDAs) — that execute predefined logic without continuous human intervention. The entry and exit thresholds of PDAs are derived as optimal solutions to an (S,s) inventory policy problem with asymmetric activation costs, not as *ad hoc* assumptions.

Five propositions with quantitative and falsifiable implications are established: the entry elasticity exceeds the exit elasticity by a ratio empirically identified at 8.44; the stock persists under negative spread for a finite and derivable interval; event studies underestimate long-run passthrough by a factor proportional to 1−δ; stock variance under migration shocks is increasing in concentration; and the monetary lever of the issuer fragments when two instruments with diverging rates coexist.

Empirical evidence comes from MakerDAO's Pot (2023–2025): 17.572M DAI persistent under negative DSR/Aave USDC spread in 2H2025, with λ≈0.86 and δ=0.5703 identified on sDAI microdata. The DSR/Aave USDC spread is the dominant predictor of governance adjustments (β=0.64, p=0.003, R²=0.353). The Surplus Buffer — operationalized as weekly flap auction frequency — precedes DSR adjustments with a 1-week lag.

---

## Key Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| λ | 0.86 | Programmatic fraction of Pot |
| δ | 0.5703 | Share of stock in APD_formal accounts |
| κ | 17.72 | OU reversion speed (half-life ≈ 2 weeks) |
| μ | 1.08% | Long-run spread mean |
| σ | 15.36% | Annualized spread volatility |
| Ein/Eout | 8.44 | Entry/exit elasticity ratio |

---

## Key Contracts

| Contract | Address |
|----------|---------|
| MakerDAO Pot | `0x197e90f9fad81970ba7976f33cbd77088e5d7cf7` |
| sDAI | `0x83f20f44975d03b1b09e64809b757c47f942beea` |
| sUSDS | `0xa3931d71877c0e7a3148cb7eb4463524fec27fbd` |
| DSPause (GSM) | `0xbe286431454714f511008713973d3b053a2d38f3` |

---

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/01_chi_simulation.R` | Chi accumulator simulation |
| `scripts/02_surplus_buffer.R` | Surplus Buffer proxy via flap auctions |
| `scripts/03_dsr_spread.R` | DSR/Aave USDC spread series |
| `scripts/04_cascade_regression.R` | Cascade regression |
| `scripts/05_sensibilidad_delta.R` | δ sensitivity by frequency threshold |
| `scripts/06_regresion_spread.R` | Spread regression (H4) |
| `scripts/07_ccf_flap_dsr.R` | Cross-correlation flap/DSR |
| `scripts/08_figura_stock_spread_regimen.R` | Stock × spread × regime figure |
| `scripts/09_regresion_elasticidades_clase.R` | Elasticity regression by agent class |
| `scripts/10_correlacion_spells_inercia.R` | Spell frequency × inertia correlation |
| `scripts/11_regresion_spread_neg_P5.R` | Negative spread regression (P5) |
| `scripts/12_flujos_DSR_SSR.R` | DSR/SSR flow comparison |

---

## Queries

| Query | Description |
|-------|-------------|
| `queries/PIT_11_delta_por_umbral_v1.sql` | δ by frequency threshold (Table A1) |
| `queries/PIT_13_flujos_por_clase_v1.sql` | Daily flows by agent class |
| `queries/PIT_14_flujos_netos_DSR_SSR_v1.sql` | Net flows DSR vs SSR |
| `queries/PIT_A1_composicion_pot_v1.sql` | Pot composition by agent type (Table 1) |
| `queries/PIT_A3_flujos_DSR_SSR_v2.sql` | DSR/SSR flow series |
| `queries/PIT_A4_datos_regresion_v1.sql` | Regression dataset |
| `queries/PIT_A5_ccf_flap_dsr_v1.sql` | CCF flap × DSR dataset |
| `queries/pot_dsr_history.sql` | Full DSR history from Pot |
| `queries/gsm_spells_por_anio.sql` | DSPause spell count by year (Table 4.1) |
| `queries/panel_submuestra_b_regression.sql` | Panel subsample B for regression |

---

## Plots

| Plot | Description |
|------|-------------|
| `../plots/01_surplus_dsr_eventos.png` | Surplus Buffer + DSR + governance events |
| `../plots/02_correlacion_lags.png` | Lagged spread × DSR correlations (Table 4.2) |
| `../plots/03_spread_dsr_aave.png` | DSR/Aave USDC spread time series |
| `../plots/04_cooks_d_m3.png` | Cook's D — outlier diagnostics |
| `../plots/05_sensibilidad_delta.png` | δ sensitivity across thresholds |
| `../plots/08_figura_stock_spread_regimen.png` | Stock × spread by regime |
| `../plots/12_flujos_DSR_SSR.png` | Net flows DSR vs SSR |

---

## Dune Dashboard

[dune.com/facundovillega/pitevidences9makerdao20232025](https://dune.com/facundovillega/pitevidences9makerdao20232025)

---

*Draft. Do not cite without permission.*
