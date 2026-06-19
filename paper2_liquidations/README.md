# P2 — Auction Design and Market Concentration in MakerDAO Liquidations

**Evidence from Black Thursday, the LUNA Crash, and the Tariff Shock**

Facundo Villega · Independent Research · On-chain Analysis · May 2026

---

**Series:** Paper 2 of 4 · Villega (2026a, 2026b, 2026c, 2026d)  
**JEL:** D44 · G23 · L11 · G01  
**Status:** Draft v11 · Do not cite without permission  
**Dashboard:** [Auction Design & Market Concentration · MakerDAO Liquidations 2020–2025](https://dune.com/facundovillega)

→ [Download PDF](./P2_EN.pdf)

---

## Abstract

We study keeper market concentration across two liquidation mechanisms in MakerDAO: the English auction (Flip, 2020–2021) and the Dutch auction (Clipper, 2021–2026). Using on-chain data from Ethereum event logs and transaction traces, we document that the transition to Clipper did not reduce market concentration — it substantially increased it under extreme stress conditions.

Three crisis episodes are analyzed: Black Thursday (March 2020), the LUNA Crash (May–June 2022), and the Tariff Shock (April 2025). The HHI varies dramatically across events — ~1,562, ~26, and ~8,371–9,546 respectively — revealing that concentration is not a stable property of the mechanism, but a function of shock speed and intensity.

The LUNA Crash (399 keepers, count HHI ~26) demonstrates that Clipper can function as designed under moderate, prolonged stress. The Tariff Shock demonstrates the opposite: a single keeper (0xc721) captured 97.68% of the ETH liquidated in a 67-minute window, operating exclusively via flash loans with no pre-positioned capital.

Mann-Whitney tests (Monte Carlo, 50,000 permutations) confirm statistically significant differences: BT vs. LUNA (p < 0.001, |r| = 0.846) and LUNA vs. Tariff (p = 0.005, |r| = 0.438).

---

## Position in the Series

| Paper | Layer | K interpreted as | Central Finding |
|-------|-------|-----------------|-----------------|
| P1 — Programmatic Deposits and Monetary Transmission | Deposits (Pot/DSR) | c_gas + c_audit + κ_coord; K*≈2.93M DAI | λ≈0.86; n*=2 (sDAI+Spark, 86% stock) |
| **P2 — Auction Design and Market Concentration in Liquidations** | **Liquidations (Clipper/Flip)** | **MEV infrastructure (latency, gas, bots)** | **Concentration = f(shock speed); Tariff Shock: n*≈1 (0xc721, 97.68% in 67 min); LUNA: n*≈399** |
| P3 — Governance Dynamics and Information Asymmetry | Governance (DSChief/GSM) | Outgoing spell coordination cost | GSM delay endogenous; pre-positioning 10 days before cast |
| P4 — κ_coord as a Market Variable | Governance (κ_coord empirical) | κ_coord_proxy = mkr_mobilized × gsm_delay_hours | β(log MKR)=1.13; β(gsm_delay_hours)=0.053; HHI not significant; R²=0.672 |

The common thread is Lemma 3 of Villega (2026a): for any protocol layer where entry requires a fixed cost K, the number of viable agents n* is decreasing in K. In the liquidation layer, K corresponds to MEV infrastructure costs. Under this interpretation, the Tariff Shock is not an anomaly: it is the case where the liquidation window T is sufficiently short for K to become binding and only n*≈1 keeper is viable.

---

## Key Results by Event

| Event | Mechanism | HHI (count) | HHI (volume) | Top-1 share | Window |
|-------|-----------|-------------|--------------|-------------|--------|
| Black Thursday (Mar 2020) | Flip | ~1,562 | ~2,100 est. | 30.28% | 25 h |
| LUNA Crash (May–Jun 2022) | Clipper | ~26 | ~221 | 8.70% | 56 h |
| Tariff Shock (Apr 2025) | Clipper | ~8,371 | ~9,546 | 97.68% | 4 h (67 min active) |

*HHI scale 0–10,000. DOJ/FTC thresholds: < 1,500 competitive, 1,500–2,500 moderate, > 2,500 concentrated.*

---

## The Speed-Concentration Trade-off

The transition to Clipper produced a comparable number of active keepers (68 vs. 73) but the HHI increased ~90% (1,562 → 2,962), with the dominant keeper's share nearly doubling (28.24% → 53.78%). However, the aggregate Clipper HHI is dominated by the Tariff Shock. Excluding that event, the Clipper HHI falls well below the DOJ/FTC moderate concentration threshold.

**The trade-off does not reside in the mechanism but in its interaction with shock speed:**

- Under gradual shocks (LUNA Crash, 56h): Clipper produces competitive markets (count HHI ~26, 399 keepers).
- Under instantaneous shocks (Tariff Shock, 67 min): Clipper produces de facto monopoly (HHI ~8,371–9,546).

The barrier shift: Flip concentrated capital (coordinated DAI funding networks); Clipper eliminated the capital barrier but introduced an execution infrastructure barrier (latency, contract optimization, gas management) that only becomes binding under instantaneous shocks.

---

## Statistical Robustness

**Weighted HHI and 95% bootstrap confidence intervals (10,000 resamples):**

| Event | Weighted HHI | 95% CI |
|-------|-------------|--------|
| Black Thursday | 4,496 | [3,851 – 5,522] |
| LUNA Crash | 1,429 | [1,124 – 1,905] |
| Tariff Shock | 8,868 | [4,000 – ~10,000] |

**Mann-Whitney U (Monte Carlo, 50,000 permutations):**

| Pair | p-value | Effect \|r\| |
|------|---------|-------------|
| BT vs. LUNA Crash | < 0.001 | 0.846 (very large) |
| LUNA vs. Tariff Shock | 0.005 | 0.438 (medium) |

---

## Key Contracts

| Contract | Address |
|----------|---------|
| Flipper ETH-A | `0xd8a04f5412223f513dc55f839574430f5ec15531` |
| Clipper ETH-A | `0xc67963a226eddd77b91ad7c421f538d4d7b1551b` |
| Dominant keeper — BT | `0x6066...` |
| Dominant keeper — Tariff Shock | `0xc721...` |

---

## Query Inventory

**Black Thursday (Flip mechanism)**

| Query | Description |
|-------|-------------|
| `p2_bt_00_block_range.sql` | Block range delimitation |
| `p2_bt_01_market_share.sql` | Keeper market share |
| `p2_bt_02a/b/c_caller_*.sql` | Caller profiles — top 3 keepers |
| `p2_bt_03–09_funding_*.sql` | Funding trees — all major keepers |
| `p2_bt_10a_hourly_dominance.sql` | Hourly dominance profile |
| `p2_bt_10b_gas_strategies.sql` | Gas strategies — external keepers |

**Clipper mechanism**

| Query | Description |
|-------|-------------|
| `p2_clip_01a_aggregate.sql` | Aggregate Clipper activity |
| `p2_clip_01b_market_share.sql` | Keeper market share — full Clipper period |
| `p2_clip_02_step1–6_*.sql` | Tariff Shock — full reconstruction (6 steps) |

**CAPA layers (cross-event)**

| Query | Description |
|-------|-------------|
| `p2_capa_02a/b/c/d_cp_*.sql` | Positional concentration — all events |
| `p2_capa_03a/b/c_hhi_*.sql` | Hourly HHI — all events |
| `p2_capa_06_zerobid_logit_bt.sql` | Zero-bid logit — BT individual auction data |
| `p2_capa_07a/b/c_colateral_*.sql` | Collateral by keeper — all events |

**GAP checks**

| Query | Description |
|-------|-------------|
| `p2_gap_02_0xc721_all_clipper.sql` | 0xc721 activity across all Clipper contracts |
| `p2_gap_03_0xc721_post_tariff.sql` | 0xc721 activity after April 6, 2025 |
| `p2_gap_04_market_share_luna.sql` | Market share by sub-period — LUNA Crash |

---

## Files

| File | Description |
|------|-------------|
| `P2_EN.pdf` | Full paper |
| `scripts/capa4_regression.R` | Cascade regression — main model |
| `queries/` | All 30+ DuneSQL queries organized by event and layer |

---

*Villega (2026b) · Working Paper v11 · In preparation · Do not cite without permission*
