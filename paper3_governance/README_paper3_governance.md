# P3 — Governance Dynamics and Information Asymmetry in Decentralized Protocols

**Evidence from MakerDAO/Sky Executive Spells and Voting Concentration**

Facundo Villega · Independent Research · On-chain Analysis · May 2026

---

**Series:** Paper 3 of 4 · Villega (2026a, 2026b, 2026c, 2026d)  
**JEL:** D72 · D82 · G23 · O33  
**Status:** Draft v00 · Do not cite without permission  
**Dashboard:** [dune.com/facundovillega/governance-dynamics-and-information-asymmetry-makerdao-2024-2025](https://dune.com/facundovillega/governance-dynamics-and-information-asymmetry-makerdao-2024-2025)

→ [Download PDF](./P3_EN.pdf)

---

## Abstract

We study the Governance Security Module (GSM) of MakerDAO/Sky as a dependent variable: its temporal evolution, the determinants of its changes, and the on-chain patterns of voting concentration and MKR pre-positioning preceding executive spells. The central case study is the out-of-schedule executive spell of February 20, 2025 (spell `0x1c8f5979`), which reduced the GSM delay from 30 to 18 hours while simultaneously loosening five LSE-MKR-A risk parameters.

Three findings:

1. **GSM as contested variable.** The delay series (17 changes, 2019–2025) exhibits a systematic 16h–30h oscillation throughout 2024 (four complete cycles, ±14h amplitude) before the anomalous reduction to 18h — a value without precedent in the historical series. The subsequent corrective response (+30h in May 2025) is the largest single upward adjustment since Black Thursday. The pattern is consistent with a contested equilibrium between coalitions with opposing preferences over institutional response speed.

2. **Structured pre-positioning (H1).** For the February 2025 spell: 50,000 MKR re-locked into the dominant voting proxy on February 10 (ten days before cast) via a single-block consolidation; eight wallets voted within a 52-minute window the night before execution; one wallet activated a voting proxy for the first time thirteen days before the vote, with no prior voting activity.

3. **Counterintuitive concentration result (H3).** The out-of-schedule spell exhibits *lower* voting concentration (HHI=3,894, 17 voters, dominant actor at 54.0%) than the immediately subsequent regular spell (HHI=9,931, dominant actor at 99.7%, effectively a single-voter outcome). This inverts the standard hypothesis. The result is consistent with Lemma 3 of Villega (2026a): salient out-of-schedule spells require explicit multi-actor coordination rather than single-actor capture.

All findings are documented through 31 reproducible DuneSQL queries.

---

## Position in the Series

| Paper | Layer | K interpreted as | Main Method |
|-------|-------|-----------------|-------------|
| P1 — Programmatic Deposits and Monetary Transmission | Deposits (Pot/DSR) | c_gas + c_audit + κ_coord; K*≈2.93M DAI | S,s model; OLS Newey-West |
| P2 — Auction Design and Market Concentration in Liquidations | Liquidations (Clipper/Flip) | MEV infrastructure | HHI; bootstrap; Mann-Whitney |
| **P3 — Governance Dynamics and Information Asymmetry** | **Governance (DSChief/GSM)** | **Coordination cost of salient spell** | **31 DuneSQL queries; case analysis** |
| P4 — κ_coord as a Market Variable | Governance (κ_coord empirical) | κ_coord_proxy = mkr_mobilized × gsm_delay_hours | OLS HC3; N=217 spells |

The common thread is Lemma 3 of Villega (2026a): for any protocol layer in which entry requires a fixed cost K, the number of viable agents n* is decreasing in K.

---

## Central Case Study — February 20, 2025 Spell (`0x1c8f5979`)

| Parameter | Before | After |
|-----------|--------|-------|
| LSE-MKR-A debt ceiling | $20M | $45M |
| LSE-MKR-A collateral ratio | 200% | 125% |
| LSE-MKR-A liquidation penalty | standard | 0% |
| LSE-MKR-A exit fee | 5% | 0% |
| GSM Pause Delay | 30 hours | **18 hours** |

Out-of-schedule (Thursday 06:26 UTC). The simultaneous modification of risk parameters and the institutional delay in a single spell is the analytically relevant event.

---

## Key Contracts

| Contract | Address |
|----------|---------|
| DSPause (GSM) | `0xbe286431454714f511008713973d3b053a2d38f3` |
| DSChief | `0xa618e54de493ec29432ebd2ca7f14efbf6ac17f7` |
| MKR token | `0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2` |
| Feb 2025 Spell | `0x1c8f5979a93ba0412677a9d315451de1570b3d03` |
| Main voting proxy | `0x0a3f6849f78076aefadf113f5bed87720274ddc0` |

---

## Query Inventory

| Range | Content |
|-------|---------|
| p3_01 – p3_07 | DSPause event structure, spell inventory, GSM delay history |
| p3_08 – p3_11 | Feb 2025 spell timeline, activity over voting proxies |
| p3_12 – p3_20 | MKR flows by wallet, proxy detail, post-cast activity |
| p3_21 – p3_26 | HHI comparison, Chief identification, vote delegate structure verification |
| p3_27 – p3_31 | Net MKR weights, full HHI series, GSM delay with context |

31 reproducible queries available in `paper3_governance/queries/` and on the Dune dashboard.

---

*Villega (2026c) · Working Paper v00 · In preparation · Do not cite without permission*
