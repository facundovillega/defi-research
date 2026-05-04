# defi-research

**Facundo Villega · Independent Research · On-chain Analysis · 2026**

---

## Overview

This repository contains two interconnected working papers on MakerDAO/Sky protocol, built on Ethereum on-chain data retrieved via Dune Analytics. Both papers study the same protocol through complementary layers: the deposit market and the liquidation market. A third paper on decentralized governance is in preparation.

**Public Dune dashboard (Paper 1):** [PIT — Inertial Deposits & Monetary Transmission · MakerDAO 2020–2026](https://dune.com/facundovillega/pitevidences9makerdao20232025)

---

## Papers

### Paper 1 — Inertial Deposits and Monetary Transmission
*A Theory of Programmatic Intermediation*

`paper1_PIT/` · Working Paper v19 · JEL: E40 · E52 · G20 · G23 · O33

An (S,s) model of DeFi deposit markets where a fraction λ of the deposit stock is managed by autonomous contracts (Programmatic Deposit Agents, PDAs) that execute predefined logic without continuous human intervention. Five propositions with quantitative and falsifiable implications are established and tested on MakerDAO Pot data (2023–2025).

**Key results:** λ≈0.86, δ=0.5703, entry/exit elasticity ratio=8.44, DSR/Aave USDC spread as dominant DSR predictor (β=0.64, R²=0.353), Surplus Buffer precedes DSR adjustments with 1-week lag.

→ [`paper1_PIT/README.md`](paper1_PIT/README.md)

---

### Paper 2 — Auction Design and Market Concentration in MakerDAO Liquidations
*Evidence from Black Thursday, the LUNA Crash, and the Tariff Shock*

`paper2_liquidations/` · Working Paper v09 · Keywords: DeFi liquidations · keeper market structure · Dutch auction · HHI · MEV

Keeper market concentration across two liquidation mechanisms (Flip and Clipper) through three crisis episodes. The transition to Clipper did not reduce concentration — it increased it substantially under extreme stress. HHI varies from ~26 (LUNA Crash) to ~9,546 (Tariff Shock), demonstrating that concentration is a function of shock speed and intensity, not a stable property of the mechanism.

**Key results:** Under the Tariff Shock, a single keeper (0xc721) captured 97.68% of ETH liquidated in a 67-minute window. Mann-Whitney tests (Monte Carlo, 50,000 permutations) confirm statistically significant differences across all event pairs.

→ [`paper2_liquidations/README.md`](paper2_liquidations/README.md)

---

## Theoretical Connection

Both papers study MakerDAO through complementary lenses and share a structural mechanism.

**The common mechanism is fixed integration cost K (Lemma 3, Paper 1):**

| Layer | K | Predicted n* | Observed |
|-------|---|--------------|----------|
| Deposit (Paper 1) | Cost of deploying + auditing a PDA contract | 2 | sDAI and Spark dominate |
| Liquidation (Paper 2) | MEV execution infrastructure | ≈1 under instantaneous shocks | 0xc721 captures 97.68% |

**The GSM 48-hour delay** appears in both papers: as the institutional constraint that lengthens PDA inertia intervals in Paper 1, and as the operational criterion for shock classification in Paper 2 — events resolved before the GSM can activate are, by definition, ones against which governance has no available institutional response.

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
├── plots/                          # All figures (centralized)
└── data/                           # CSV exports from Dune (not versioned)
```

---

## Data Sources

- **Dune Analytics:** primary source for all on-chain data
- **DeFi Llama yields API:** Aave USDC V3 rate series
- **Ethereum mainnet tables:** `ethereum.logs`, `ethereum.transactions`, `ethereum.traces`, `erc20_ethereum.evt_transfer`
- **MakerDAO-specific tables:** `maker_ethereum.Pot_call_join`, `maker_ethereum.Vow_call_flap`, `maker_ethereum.Pot_call_file`, `sky_ethereum.susds_call_ssr`

---

## Citation

Villega, F. (2026a). *Inertial Deposits and Monetary Transmission: A Theory of Programmatic Intermediation*. Working Paper v19. Independent Research.

Villega, F. (2026b). *Auction Design and Market Concentration in MakerDAO Liquidations: Evidence from Black Thursday, the LUNA Crash, and the Tariff Shock*. Working Paper v09. Independent Research.

---

*Draft. Do not cite without permission.*
