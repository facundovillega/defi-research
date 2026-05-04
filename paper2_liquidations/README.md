# Paper 2 — Auction Design and Market Concentration in MakerDAO Liquidations
*Evidence from Black Thursday, the LUNA Crash, and the Tariff Shock*

**Working Paper v09 · Keywords: MakerDAO · DeFi liquidations · keeper market structure · Dutch auction · HHI · MEV**

→ Back to [repository index](../README.md)

---

## Abstract

This paper studies keeper market concentration across two liquidation mechanisms in MakerDAO: the English auction (Flip, 2020–2021) and the Dutch auction (Clipper, 2021–2026). Using on-chain data from Ethereum logs and transaction traces, we document that the transition to Clipper did not reduce market concentration — it increased it substantially under extreme stress conditions.

Three crisis episodes are analyzed: Black Thursday (March 2020), the LUNA Crash (May–June 2022), and the Tariff Shock (April 2025). The Herfindahl-Hirschman Index (HHI) varies dramatically across events: ~1,562 in Black Thursday, ~26 in the LUNA Crash, and ~8,371–9,546 in the Tariff Shock. This variation reveals that concentration is not a stable property of the mechanism, but a function of shock speed and intensity.

The LUNA Crash — the only event with genuine access competition, with 399 keepers and HHI count ~26 — shows that Clipper can function as designed under moderate and prolonged stress. However, under instantaneous high-magnitude shocks such as the Tariff Shock, a single keeper (0xc721) captured 97.68% of the ETH liquidated in a 67-minute window. Mann-Whitney tests (Monte Carlo, 50,000 permutations) confirm statistically significant differences across events (BT vs. LUNA: p < 0.001, |r| = 0.846; LUNA vs. Tariff: p = 0.005, |r| = 0.438).

The GSM's 48-hour delay serves as the operational criterion for shock classification: events resolved before the GSM can activate are, by definition, ones against which governance has no available institutional response.

---

## Key Results by Event

| Event | Mechanism | HHI (count) | HHI (volume) | Top-1 share | Window |
|-------|-----------|-------------|--------------|-------------|--------|
| Black Thursday (Mar 2020) | Flip | ~1,562 | ~2,100 est. | 30.28% | 25 h |
| LUNA Crash (May–Jun 2022) | Clipper | ~26 | ~221 | 8.70% | 56 h |
| Tariff Shock (Apr 2025) | Clipper | ~8,371 | ~9,546 | 97.68% | 4 h (67 min active) |

---

## Key Contracts

| Contract | Address |
|----------|---------|
| Flipper ETH-A | `0xd8a04f5412223f513dc55f839574430f5ec15531` |
| Clipper ETH-A | `0xc67963a226eddd77b91ad7c421f538d4d7b1551b` |
| Dominant keeper — BT | `0x6066` (abbrev.) |
| Dominant keeper — Tariff Shock | `0xc721` (abbrev.) |

---

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/capa4_regression.R` | Cascade regression — main model |

---

## Queries

Queries are organized by analysis layer (CAPA), event-specific series (BT / LUNA / Tariff), and gap-filling checks (GAP).

### Black Thursday (Flip mechanism)

| Query | Description |
|-------|-------------|
| `queries/p2_bt_00_block_range.sql` | Block range delimitation |
| `queries/p2_bt_01_market_share.sql` | Keeper market share |
| `queries/p2_bt_02a_caller_0x6066.sql` | Caller profile — dominant keeper |
| `queries/p2_bt_02b_caller_0x9c05.sql` | Caller profile — secondary keeper |
| `queries/p2_bt_02c_caller_0x00ab.sql` | Caller profile — tertiary keeper |
| `queries/p2_bt_03_funding_0x6066.sql` | L1 funding tree — 0x6066 |
| `queries/p2_bt_04_intraday_recap.sql` | Intraday activity recap |
| `queries/p2_bt_05_upstream_0x4c8745.sql` | Upstream funding — 0x4c8745 |
| `queries/p2_bt_06_funding_0x9c05.sql` | Funding tree — 0x9c05 |
| `queries/p2_bt_07_funding_0xb00b.sql` | Funding tree — 0xb00b |
| `queries/p2_bt_08_funding_0x00ab.sql` | Funding tree — 0x00ab |
| `queries/p2_bt_09_funding_0xb400.sql` | Funding tree — 0xb400 |
| `queries/p2_bt_10a_hourly_dominance.sql` | Hourly dominance profile |
| `queries/p2_bt_10b_gas_strategies.sql` | Gas strategies — external keepers |

### Clipper mechanism — aggregate

| Query | Description |
|-------|-------------|
| `queries/p2_clip_01a_aggregate.sql` | Aggregate Clipper activity |
| `queries/p2_clip_01b_market_share.sql` | Keeper market share — full Clipper period |
| `queries/p2_clip_02_step1.sql` | Tariff Shock — step 1: active keepers |
| `queries/p2_clip_02_step1b.sql` | Tariff Shock — step 1b: keepers on 6 Apr 2025 |
| `queries/p2_clip_02_step2_erc20_funding.sql` | Tariff Shock — ERC20 funding sources |
| `queries/p2_clip_02_step3_eth_in.sql` | Tariff Shock — ETH inflows |
| `queries/p2_clip_02_step4_eth_out.sql` | Tariff Shock — ETH outflows |
| `queries/p2_clip_02_step5_traces.sql` | Tariff Shock — transaction traces |
| `queries/p2_clip_02_step6_tx_profile.sql` | Tariff Shock — full tx profile |

### CAPA layers (cross-event analysis)

| Query | Description |
|-------|-------------|
| `queries/p2_capa_01_h4_keeper_activity.sql` | H4: dominant keeper activity outside event window |
| `queries/p2_capa_02a_cp_bt.sql` | Positional concentration — Black Thursday |
| `queries/p2_capa_02b_cp_luna.sql` | Positional concentration — LUNA Crash |
| `queries/p2_capa_02c_cp_tariff.sql` | Positional concentration — Tariff Shock |
| `queries/p2_capa_02d_cp_clipper.sql` | Positional concentration — Clipper full period |
| `queries/p2_capa_03a_hhi_bt.sql` | Hourly HHI — Black Thursday |
| `queries/p2_capa_03b_hhi_luna.sql` | Hourly HHI — LUNA Crash |
| `queries/p2_capa_03c_hhi_tariff.sql` | Hourly HHI — Tariff Shock |
| `queries/p2_capa_05a_keepers_luna_freq.sql` | LUNA keepers — frequency distribution |
| `queries/p2_capa_05b_keepers_luna_new.sql` | LUNA keepers — new vs. preexisting |
| `queries/p2_capa_06_zerobid_logit_bt.sql` | Zero-bid logit — BT individual auction data |
| `queries/p2_capa_07a_colateral_bt.sql` | Collateral by keeper — BT (Take events) |
| `queries/p2_capa_07b_colateral_luna.sql` | Collateral by keeper — LUNA (Take events) |
| `queries/p2_capa_07c_colateral_tariff.sql` | Collateral by keeper — Tariff Shock (Take events) |

### GAP checks

| Query | Description |
|-------|-------------|
| `queries/p2_gap_01_offsets_bt.sql` | BT offsets — from bt_02_zerobid_split |
| `queries/p2_gap_02_0xc721_all_clipper.sql` | 0xc721 activity across all Clipper contracts |
| `queries/p2_gap_03_0xc721_post_tariff.sql` | 0xc721 activity after 6 Apr 2025 |
| `queries/p2_gap_04_market_share_luna.sql` | Market share by sub-period — LUNA Crash |

### Supplementary

| Query | Description |
|-------|-------------|
| `queries/p2_tariff_market_share_full.sql` | Full market share — Tariff Shock (no LIMIT) |
| `queries/p2_luna_market_share_full.sql` | Full market share — LUNA Crash (no LIMIT) |
| `queries/p2_keeper_temporal_profile.sql` | Temporal profile — dominant keeper |
| `queries/p2_monthly_activity.sql` | Monthly activity — event delimitation |
| `queries/p2_keeper_market_share_full.sql` | Market share — full period, all keepers |

---

## Dune Dashboard

[Auction Design & Market Concentration · MakerDAO Liquidations 2020–2025](https://dune.com/facundovillega/makerdao-liquidations-2020-2025)

---

*Draft. Do not cite without permission.*
