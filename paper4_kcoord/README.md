# P4 — κ_coord as a Market Variable

**Empirical Estimation on MakerDAO's DSChief, 2019–2025**

Facundo Villega · Independent Research · On-chain Analysis · May 2026

---

**Series:** Paper 4 of 4 · Villega (2026a, 2026b, 2026c, 2026d)  
**JEL:** D72 · G23 · L14 · O33  
**Status:** Draft v01 · Do not cite without permission  
**Dashboard:** [dune.com/facundovillega](https://dune.com/facundovillega)

→ [Download PDF](./P4_Kappa_coord_EN.pdf)

---

## Abstract

Lemma 3 of Villega (2026a) establishes that the governance coordination cost κ_coord represents 96.6% of the fixed integration cost K≈2.93M DAI — but its value was imputed as a residual, not directly estimated. This paper estimates κ_coord empirically on N=217 executive spells of MakerDAO's DSChief between November 2019 and June 2025, using as on-chain proxy the product `mkr_mobilized × gsm_delay_hours` — capital immobilized during the mandatory institutional period.

In five OLS specifications with HC3 robust standard errors, `log(1+MKR)` and `gsm_delay_hours` are the only significant drivers at 0.1% across all models, with stable coefficients of **1.13** and **0.053** respectively. Voting concentration (HHI) is not significant (subsample N=149). R²=0.672 on the full sample; R²=0.982 on the high-participation subsample reflects sample selection, not an HHI effect.

The coordination cost limiting PA entry is therefore a function of **how long the spell takes to reach majority**, not of **who votes**. The oligopolistic concentration of MakerDAO governance (mean HHI 8,149) does not amplify κ_coord; what amplifies it is the GSM delay and the declining participation that extends voting windows.

---

## Position in the Series

| Paper | Layer | K interpreted as | Central Finding |
|-------|-------|-----------------|-----------------|
| P1 — Programmatic Deposits and Monetary Transmission | Deposits (Pot/DSR) | c_gas + c_audit + κ_coord; K*≈2.93M DAI | λ≈0.86; n*=2 (sDAI+Spark, 86% stock) |
| P2 — Auction Design and Market Concentration in Liquidations | Liquidations (Clipper/Flip) | MEV infrastructure | Tariff Shock: n*≈1 (0xc721, 97.68% in 67 min) |
| P3 — Governance Dynamics and Information Asymmetry | Governance (DSChief/GSM) | Outgoing spell coordination cost | GSM delay endogenous; pre-positioning 10 days before cast |
| **P4 — κ_coord as a Market Variable** | **Governance (κ_coord empirical)** | **κ_coord_proxy = mkr_mobilized × gsm_delay_hours** | **β(log MKR)=1.13; β(gsm_delay_hours)=0.053; HHI not significant; R²=0.672** |

The common thread is Lemma 3 of Villega (2026a): for any protocol layer where entry requires a fixed cost K, the number of viable agents n* is decreasing in K.

---

## The On-chain Proxy

```
κ_coord_proxy = mkr_mobilized × gsm_delay_hours
```

- **mkr_mobilized**: net MKR locked in the Chief in the 14 days prior to ts_plot
- **gsm_delay_hours**: duration of the prevailing GSM delay in hours (ts_exec − ts_plot)

The 14-day capture window is justified on two grounds: (1) the central re-lock in the February 2025 spell occurs exactly 10 days before cast — a 7-day window would exclude it by construction; (2) the OU half-life calibrated in Villega (2026a) (κ=17.72) is ≈2 weeks, marking the relevance horizon for capital movements attributable to a specific spell.

---

## Regression Results

**Table 3. Determinants of κ_coord — MakerDAO DSChief 2020–2025**

*Dependent variable: log(1 + κ_coord_proxy). HC3 robust SEs. M1–M3: N=217. M4–M5: N=149 (HHI subsample).*

| Variable | M1 | M2 | M3 | M4 | M5 |
|----------|----|----|----|----|-----|
| Constant | 2.057*** | 2.126*** | 2.185*** | 2.439*** | 2.344*** |
| log(1+MKR) | 1.130*** | 1.120*** | 1.118*** | 1.031*** | 1.039*** |
| gsm_delay_hours | 0.053*** | 0.053*** | 0.053*** | 0.025*** | 0.025*** |
| log(1+n_locks) | −0.808** | −0.809** | −0.818** | −0.069 | −0.063 |
| whale_present | — | 0.355 | 0.351 | — | −0.237* |
| post_sky | — | — | −0.137 | — | — |
| hhi | — | — | — | −0.000 | 0.000 |
| **R²** | **0.672** | **0.673** | **0.673** | **0.982** | **0.983** |
| Obs. | 217 | 217 | 217 | 149 | 149 |

*HC3 robust SEs. BP=14.531 (M1, df=3, p=0.006). Max VIF M4: 1.26. \*p<0.05; \*\*p<0.01; \*\*\*p<0.001.*

**Three conclusions:**

1. **log_mkr and gsm_delay_hours are the only robust drivers.** A spell with GSM delay 48h vs. 12h has κ_coord_proxy ≈ e^(0.053×36) ≈ 6.9 times larger, all else equal.
2. **HHI is not significant (M4–M5, N=149).** Oligopolistic concentration does not amplify coordination cost. What matters is how much MKR is immobilized and for how long.
3. **Regime dummies are not significant.** whale_present, year, and post_sky show no statistically distinguishable effect once controlling for log_hours.

---

## The Causal Chain

```
GSM delay ↑ → mandatory immobilization ↑ → κ_coord ↑ → K* ↑ → n* ↓
```

Each arrow has an empirical anchor:

- **Arrow 1** — β(gsm_delay_hours) = 0.053 (this paper). Each additional hour of delay raises κ_coord_proxy by 5.3%.
- **Arrow 2** — κ_coord ≈ 2.83M DAI = 96.6% of K* (Villega (2026a), calibration).
- **Arrow 3** — n* ≤ D_total · r / (ρ · K) (Lemma 3). With K*≈2.93M DAI, predicts n*=2, consistent with sDAI and Spark capturing 86% of stock.

The 62% decline in spell frequency between 2020 and 2025 raises κ_coord endogenously — without requiring any actor to manipulate the delay.

---

## Key Contracts

| Contract | Address | Period |
|----------|---------|--------|
| DSChief v1 | `0x8e2a84d6ade1e7fffee039a35ef5f19f13057152` | 2017–2023 |
| DSChief v2 | `0x9ef05f7f6deb616fd37ac3c959a2ddd25a54e4f5` | 2019–2026 |
| DSChief (current) | `0xa618e54de493ec29432ebd2ca7f14efbf6ac17f7` | 2020–present |

---

## Query Inventory

| Query | Dune ID | Description |
|-------|---------|-------------|
| p4_01 | 7503629 | Lock events — three DSChief contracts |
| p4_02 | 7486415 | HHI per spell — reconstruction from raw logs |
| p4_03 | 7486567 | Master table — subsample N=149 spells with HHI |

---

## Files

| File | Description |
|------|-------------|
| `P4_Kappa_coord_EN.pdf` | Full paper |
| `scripts/p4_kcoord_estimation.R` | Estimation script — data pull, cleaning, regressions |

---

*Villega (2026d) · Working Paper v01 · In preparation · Do not cite without permission*
