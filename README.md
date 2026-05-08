# defi-research
Facundo Villega · Independent Research · On-chain Analysis · 2026

## Overview

This repository contains three interconnected working papers on MakerDAO/Sky protocol, built on Ethereum on-chain data retrieved via Dune Analytics. The papers study the same protocol through complementary layers: the deposit market, the liquidation market, and the governance layer.

**Public Dune dashboard (Paper 1):** [PIT — Inertial Deposits & Monetary Transmission · MakerDAO 2020–2026](https://dune.com/facundovillega/pit-inertial-deposits-makerdao-2020-2026)

**Public Dune dashboard (Paper 2):** [Auction Design & Market Concentration · MakerDAO Liquidations 2020–2025](https://dune.com/facundovillega/makerdao-liquidations-2020-2025)

**Public Dune dashboard (Paper 3):** [Governance Dynamics & Information Asymmetry · MakerDAO 2024–2025](https://dune.com/facundovillega/governance-dynamics-and-information-asymmetry-makerdao-2024-2025)

---

## Papers

### Paper 1 — Inertial Deposits and Monetary Transmission
**A Theory of Programmatic Intermediation**

`paper1_PIT/` · Working Paper v19 · JEL: E40 · E52 · G20 · G23 · O33

An (S,s) model of DeFi deposit markets where a fraction λ of the deposit stock is managed by autonomous contracts (Programmatic Deposit Agents, PDAs) that execute predefined logic without continuous human intervention. Five propositions with quantitative and falsifiable implications are established and tested on MakerDAO Pot data (2023–2025).

Key results: λ≈0.86, δ=0.5703, entry/exit elasticity ratio=8.44, DSR/Aave USDC spread as dominant DSR predictor (β=0.64, R²=0.353), Surplus Buffer precedes DSR adjustments with 1-week lag.

→ [paper1_PIT/README.md](paper1_PIT/README.md)

---

### Paper 2 — Auction Design and Market Concentration in MakerDAO Liquidations
**Evidence from Black Thursday, the LUNA Crash, and the Tariff Shock**

`paper2_liquidations/` · Working Paper v09 · Keywords: DeFi liquidations · keeper market structure · Dutch auction · HHI · MEV

Keeper market concentration across two liquidation mechanisms (Flip and Clipper) through three crisis episodes. The transition to Clipper did not reduce concentration — it increased it substantially under extreme stress. HHI varies from ~26 (LUNA Crash) to ~9,546 (Tariff Shock), demonstrating that concentration is a function of shock speed and intensity, not a stable property of the mechanism.

Key results: Under the Tariff Shock, a single keeper (0xc721) captured 97.68% of ETH liquidated in a 67-minute window. Mann-Whitney tests (Monte Carlo, 50,000 permutations) confirm statistically significant differences across all event pairs.

→ [paper2_liquidations/README.md](paper2_liquidations/README.md)

---

### Paper 3 — Governance Dynamics and Information Asymmetry in Decentralized Protocols
**Evidence from MakerDAO/Sky Executive Spells and Voting Concentration**

`paper3_governance/` · Working Paper v00 · In preparation · Keywords: DeFi governance · GSM · MKR · voting concentration · executive spells · spell timing

Empirical study of the Governance Security Module (GSM) Pause Delay as a variable of interest — its evolution, the conditions under which it changes, and the on-chain voting dynamics surrounding out-of-schedule executive spells. Case study: February 20, 2025 executive spell reducing the GSM delay from 30h to 18h.

Preliminary results: the February 2025 out-of-schedule spell shows anomalous MKR pre-positioning (50,000 MKR re-locked 8 days prior) and required multi-actor coordination (HHI≈3,894, 17 voters) relative to the immediately subsequent regular spell (HHI≈9,931, 1 dominant voter). The GSM delay series shows systematic oscillation between 16h and 30h throughout 2024 before the anomalous reduction to 18h.

→ [paper3_governance/README.md](paper3_governance/README.md)

---

## Theoretical Connection

All three papers study MakerDAO through complementary layers and share a structural mechanism.

The common mechanism is fixed integration cost K (Lemma 3, Paper 1):

| Layer | Paper | Fixed cost K | Predicted n* | Observed |
|---|---|---|---|---|
| Deposit | Paper 1 | Cost of deploying + auditing a PDA contract | 2 | sDAI and Spark dominate |
| Liquidation | Paper 2 | MEV execution infrastructure | ≈1 under instantaneous shocks | 0xc721 captures 97.68% |
| Governance | Paper 3 | Governance coordination cost | TBD — empirical question | Multi-actor coordination observed in out-of-schedule spells |

The GSM Pause Delay appears in all three papers as a structural link:

- **Paper 1** → fixed parameter that lengthens PDA inertia intervals
- **Paper 2** → operational criterion for shock classification (events resolved before the GSM can activate are ones against which governance has no available institutional response)
- **Paper 3** → variable of interest — its evolution and determinants are the object of study

---

## Repository Structure

```
defi-research/
├── README.md
├── paper1_PIT/
│   ├── README.md
│   ├── scripts/                    # R scripts 01–12
│   └── queries/                    # DuneSQL queries
├── paper2_liquidations/
│   ├── README.md
│   ├── scripts/                    # R scripts
│   └── queries/                    # DuneSQL queries (~50)
├── paper3_governance/
│   ├── README.md
│   └── queries/                    # DuneSQL queries (31)
└── plots/                          # All figures (centralized)
```

---

## Data Sources

- Dune Analytics: primary source for all on-chain data
- DeFi Llama yields API: Aave USDC V3 rate series
- Ethereum mainnet tables: `ethereum.logs`, `ethereum.transactions`, `ethereum.traces`, `erc20_ethereum.evt_Transfer`
- MakerDAO-specific tables: `maker_ethereum.Pot_call_join`, `maker_ethereum.Vow_call_flap`, `maker_ethereum.Pot_call_file`, `maker_ethereum.dschief_call_lock`, `maker_ethereum.dschief_call_free`, `sky_ethereum.susds_call_ssr`

---

## Citation

Villega, F. (2026a). *Inertial Deposits and Monetary Transmission: A Theory of Programmatic Intermediation*. Working Paper v19. Independent Research.

Villega, F. (2026b). *Auction Design and Market Concentration in MakerDAO Liquidations: Evidence from Black Thursday, the LUNA Crash, and the Tariff Shock*. Working Paper v09. Independent Research.

Villega, F. (2026c). *Governance Dynamics and Information Asymmetry in Decentralized Protocols: Evidence from MakerDAO/Sky Executive Spells and Voting Concentration*. Working Paper v00. Independent Research. In preparation.

---

*Draft. Do not cite without permission.*
