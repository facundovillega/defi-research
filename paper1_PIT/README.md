
# P1 — Programmatic Deposits and Monetary Transmission

**A Framework of Programmatic Intermediation**

Facundo Villega · Independent Research · On-chain Analysis · April 2026

---

**Series:** Paper 1 of 4 · Villega (2026a, 2026b, 2026c, 2026d)  
**JEL:** E40 · E52 · G20 · G23 · O33  
**Status:** Draft v19 · Do not cite without permission  
**Dashboard:** [PIT — Inertial Deposits & Monetary Transmission · MakerDAO 2020–2026](https://dune.com/facundovillega/pitevidences9makerdao20232025)

→ [Download PDF](./P1_EN.pdf)

---

## Abstract

We develop a formal framework for monetary markets in which a fraction λ of the deposit stock is managed by Programmatic Deposit Agents (PDAs) — autonomous smart contracts that execute predefined logic without continuous human intervention. PDA entry and exit thresholds are derived as optimal solutions to an (S,s) inventory policy problem with asymmetric activation costs.

Five quantitative and falsifiable implications follow: entry inflow exceeds exit outflow by a ratio of 8.44; the deposit stock persists under negative spread during a finite and derivable interval; event studies underestimate long-run passthrough by a factor of 1−δ; stock variance under migration shocks is quadratic in concentration; and the monetary lever fragments when two instruments with divergent rates coexist.

Empirical evidence comes from the MakerDAO Pot (2023–2025): 17.572M DAI persist under sustained negative DSR/Aave USDC spread in 2H2025, with λ≈0.86 and δ=0.5703 identified from sDAI microdata. The DSR/Aave USDC spread is the dominant predictor of governance adjustments one week ahead (β=0.64, p=0.003, R²=0.353, n=144 weeks, Newey-West SE). MakerDAO governance operates de facto as a monetary policy reaction function with a single institutional lag.

---

## Position in the Series

| Paper | Layer | K interpreted as | Central Finding |
|-------|-------|-----------------|-----------------|
| **P1 — Programmatic Deposits and Monetary Transmission** | **Deposits (Pot/DSR)** | **c_gas + c_audit + κ_coord; K*≈2.93M DAI** | **λ≈0.86; δ=0.5703; n*=2 (sDAI+Spark, 86% stock); governance as monetary reaction function** |
| P2 — Auction Design and Market Concentration in Liquidations | Liquidations (Clipper/Flip) | MEV infrastructure | Tariff Shock: n*≈1 (0xc721, 97.68% in 67 min); LUNA: n*≈399 |
| P3 — Governance Dynamics and Information Asymmetry | Governance (DSChief/GSM) | Outgoing spell coordination cost | GSM delay endogenous; pre-positioning 10 days before cast |
| P4 — κ_coord as a Market Variable | Governance (κ_coord empirical) | κ_coord_proxy = mkr_mobilized × gsm_delay_hours | β(log MKR)=1.13; β(gsm_delay_hours)=0.053; HHI not significant; R²=0.672 |

The common thread is **Lemma 3**: for any protocol layer where entry requires a fixed cost K, the number of viable agents n* is decreasing in K. With K≈2.93M DAI calibrated from observed n*=2, governance coordination accounts for 96.6% of K*.

---

## Key Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| λ | 0.86 | Programmatic fraction of Pot |
| δ | 0.5703 | Share of stock in APD_formal accounts |
| κ | 17.72 | OU reversion speed (half-life ≈ 2 weeks) |
| μ | 1.08% | Long-run spread mean |
| σ | 15.36% | Annualized spread volatility |
| E_in/E_out | 8.44 | Entry/exit flow ratio (robust: 8.44–11.33) |
| K* | ≈2.93M DAI | Fixed integration cost consistent with n*=2 |
| κ_coord | ≈2.83M DAI | Governance coordination cost (96.6% of K*) |

---

## Decomposition of K*

```
K* = c_gas + c_audit + κ_coord
   ≈ 800 DAI + 100,000 DAI + 2,830,000 DAI
   ≈ 2.93M DAI
```

- **c_gas** (~800 DAI, 0.03%): spell contract deployment gas, directly observable on-chain
- **c_audit** (~100,000 DAI, 3.4%): code audit cost, market-observable in executive votes
- **κ_coord** (~2.83M DAI, 96.6%): governance coordination, inferred residual — empirically estimated in Villega (2026d)

---

## Governance Reaction Function (H4)

Weekly flap_count and the DSR/Aave USDC spread jointly predict the DSR one week ahead:

| Specification | R² | β(spread) | β(flap_count) |
|---------------|-----|-----------|---------------|
| Spread only | 0.279 | 0.690*** | — |
| flap_count only | 0.118 | — | −0.008 |
| Joint model | **0.353** | **0.639*** (p=0.003)** | **−0.007† (p=0.096)** |

*N=144 weeks, July 2023–April 2026. Newey-West SE (lag=4). †p<0.10; \*\*\*p<0.001.*

The spread is the dominant driver. The Surplus Buffer (flap_count) adds bounded incremental explanatory power — a second-order confirmation variable, not an independent driver.

---

## Key Contracts

| Contract | Address |
|----------|---------|
| MakerDAO Pot | `0x197e90f9fad81970ba7976f33cbd77088e5d7cf7` |
| sDAI | `0x83f20f44975d03b1b09e64809b757c47f942beea` |
| sUSDS | `0xa3931d71877c0e7a3148cb7eb4463524fec27fbd` |
| DSPause (GSM) | `0xbe286431454714f511008713973d3b053a2d38f3` |

---

## Query Inventory

| Query | Description |
|-------|-------------|
| `PIT_OU_spread_calibration_v1` (7384994) | OU spread calibration — DSR vs Aave USDC (2023–2026) |
| `PIT_A1_composicion_pot_v1` | Pot composition by agent type (Table 1) |
| `PIT_11_delta_por_umbral_v1` | δ by frequency threshold (Table A1) |
| `PIT_13_flujos_por_clase_v1` | Daily flows by agent class |
| `PIT_14_flujos_netos_DSR_SSR_v1` | Net flows DSR vs SSR |
| `PIT_A3_flujos_DSR_SSR_v2` | DSR/SSR flow series |
| `PIT_A4_datos_regresion_v1` | Regression dataset |
| `PIT_A5_ccf_flap_dsr_v1` | CCF flap × DSR dataset |
| `pot_dsr_history` | Full DSR history from Pot |
| `gsm_spells_por_anio` | DSPause spell count by year (Table 4.1) |

---

## Files

| File | Description |
|------|-------------|
| `P1_EN.pdf` | Full paper |
| `scripts/01_chi_simulation.R` | Chi accumulator simulation |
| `scripts/02_surplus_buffer.R` | Surplus Buffer proxy via flap auctions |
| `scripts/03_dsr_spread.R` | DSR/Aave USDC spread series |
| `scripts/04_cascade_regression.R` | Cascade regression |
| `scripts/06_regresion_spread.R` | Spread regression (H4) |
| `scripts/07_ccf_flap_dsr.R` | Cross-correlation flap/DSR |
| `scripts/09_regresion_elasticidades_clase.R` | Elasticity regression by agent class |

---

*Villega (2026a) · Working Paper v19 · In preparation · Do not cite without permission*
