# Paper 3 — Governance Dynamics and Information Asymmetry in Decentralized Protocols
*Evidence from MakerDAO/Sky Emergency Spells and Voting Concentration*

**Working Paper v00 · In preparation · Keywords: DeFi governance · GSM · MKR · SKY · voting concentration · executive spells · governance design**

→ Back to [repository index](../README.md)

---

## Status

**In preparation.** This README documents the research design and theoretical framework. Empirical work has not yet begun.

---

## Motivation

Decentralized governance protocols face a fundamental tension between decision speed and deliberative legitimacy. MakerDAO/Sky's Governance Security Module (GSM) operationalizes this tension as a configurable time delay between spell approval and execution. This delay is the central institutional parameter studied in Papers 1 and 2 of this series; in Paper 3 it becomes the object of analysis rather than a fixed constraint.

This paper studies how governance parameters — particularly the GSM Pause Delay — evolve over time, and whether the timing and structure of executive spells contain systematic patterns that are detectable on-chain prior to execution.

---

## Central Case Study — February 2025 Executive Spell

**Event:** Out-of-schedule executive vote — Risk Parameter Changes — February 2025

**Key parameter changes:**

| Parameter | Before | After |
|-----------|--------|-------|
| LSE-MKR-A debt ceiling | $20M | $45M |
| LSE-MKR-A collateral ratio | 200% | 125% |
| LSE-MKR-A liquidation penalty | standard | 0% |
| LSE-MKR-A exit fee | 5% | 0% |
| GSM Pause Delay | 30 hours | 18 hours |

The spell was executed outside the regular weekly governance schedule. It modified both risk parameters and the GSM delay simultaneously — making it an unusual event for empirical analysis.

---

## Research Questions

**RQ1 — Pre-positioning:** Is there statistically anomalous MKR/SKY vote weight accumulation or delegation activity in the 48–72 hours preceding out-of-schedule spells relative to regular weekly spells?

**RQ2 — GSM as dependent variable:** Does the GSM Pause Delay exhibit a systematic trend across executive spells over the 2020–2026 period? What governance conditions predict changes to this parameter?

**RQ3 — Voting concentration:** How does the HHI of voting weight distribution differ between out-of-schedule spells and regular weekly spells? Is concentration episodic or structural?

**RQ4 — Leading indicators:** Do Surplus Buffer dynamics or DSR spread series — already documented in Paper 1 — contain predictive information about the timing of out-of-schedule governance activity?

---

## Theoretical Connection to Papers 1 and 2

| Layer | Paper | Fixed cost K | Predicted n* | Observed |
|-------|-------|-------------|--------------|----------|
| Deposit | Paper 1 | PDA deployment cost | 2 | sDAI + Spark |
| Liquidation | Paper 2 | MEV infrastructure | ≈1 under stress | 0xc721 (97.68%) |
| Governance | Paper 3 | Governance coordination cost | TBD | TBD — empirical question |

**GSM as structural link:** The GSM Pause Delay appears in all three papers:
- Paper 1 → lengthens PDA inertia intervals (fixed parameter)
- Paper 2 → operational criterion for shock classification (fixed parameter)
- Paper 3 → variable of interest — its evolution and determinants are the object of study

---

## Hypotheses (Preliminary — subject to revision upon data inspection)

**H1 — Pre-positioning:** Vote weight accumulation in the 48 hours preceding out-of-schedule spells exceeds that of regular spells by a statistically significant margin.

**H2 — GSM trend:** The GSM Pause Delay has changed over time through executive spells. Whether the trend is monotone, episodic, or responsive to specific protocol conditions is an empirical question.

**H3 — Episodic concentration:** Voting HHI is higher during out-of-schedule spells than during regular weekly spells — consistent with a lower number of active voters under compressed deliberation windows.

**H4 — Surplus Buffer as signal:** Surplus Buffer dynamics predict the timing of out-of-schedule governance activity with a measurable lead, extending the CCF analysis from Paper 1 to the governance layer.

*All hypotheses are falsifiable and directionally agnostic — the data may support or contradict each one.*

---

## Proposed Empirical Strategy

**Data sources:**
- `ethereum.logs` — DSPause Lift/Cast events (spell timeline reconstruction)
- `ethereum.transactions` / `ethereum.traces` — MKR/SKY vote weight changes pre-spell
- `maker_ethereum.Vow_call_flap` — Surplus Buffer proxy (Paper 1 infrastructure)
- Sky Governance Forum — off-chain deliberation timeline
- Dune Analytics — on-chain voting panels

**Methods:**
- Full spell inventory (2020–2026) from DSPause logs — classify regular vs. out-of-schedule
- HHI of vote weight distribution per spell — compare across spell types
- Event study: vote weight accumulation in pre-spell windows (24h, 48h, 72h)
- Cross-correlation: Surplus Buffer → out-of-schedule spell frequency

---

## Key Contracts

| Contract | Address |
|----------|---------|
| DSPause (GSM) | `0xbe286431454714f511008713973d3b053a2d38f3` |
| Chief (MKR voting) | TBD |
| New Chief (SKY voting) | `0x929d9A1435662357F54AdcF64DcEE4d6b867a6f9` |
| LSE-MKR-A (Seal Engine) | TBD |

---

## Pending

- [ ] Full spell inventory from DSPause logs (2020–2026)
- [ ] Classify spells: regular weekly vs. out-of-schedule
- [ ] Build voting weight panel per spell from Chief contract
- [ ] Confirm LSE-MKR-A and Chief contract addresses
- [ ] Reconstruct February 2025 spell on-chain timeline
- [ ] Cross-reference with Forum post timestamps

---

*In preparation. Do not cite.*
