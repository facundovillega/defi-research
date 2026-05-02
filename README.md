# defi-research

**Facundo Villega · Independent Research · On-chain Analysis · April 2026**

---

## Papers

### Paper 1 — Inertial Deposits and Monetary Transmission: A Theory of Programmatic Intermediation

**Working Paper v19 · JEL: E40 · E52 · G20 · G23 · O33**

An (S,s) Model of DeFi Deposit Markets with Non-Discretionary Agents

This paper develops a formal theoretical framework for monetary markets in which a fraction λ of the deposit stock is managed by autonomous contracts — Programmatic Deposit Agents (PDAs) — that execute predefined logic without continuous human intervention. The entry and exit thresholds of PDAs are derived as optimal solutions to an (S,s) inventory policy problem with asymmetric activation costs, not as *ad hoc* assumptions.

Five propositions with quantitative and falsifiable implications are established: the entry elasticity exceeds the exit elasticity by a ratio empirically identified at 8.44; the stock persists under negative spread for a finite and derivable interval; event studies underestimate long-run passthrough by a factor proportional to 1−δ; stock variance under migration shocks is increasing in concentration; and the monetary lever of the issuer fragments when two instruments with diverging rates coexist.

Empirical evidence comes from MakerDAO's Pot (2023–2025): 17.572M DAI persistent under negative DSR/Aave USDC spread in 2H2025, with λ≈0.86 and δ=0.5703 identified on sDAI microdata. The DSR/Aave USDC spread is the dominant predictor of governance adjustments (β=0.64, p=0.003, R²=0.353). The Surplus Buffer — operationalized as weekly flap auction frequency — precedes DSR adjustments with a 1-week lag.

**Key parameters:**

| Parameter | Value | Description |
|-----------|-------|-------------|
| λ | 0.86 | Programmatic fraction of Pot |
| δ | 0.5703 | Share of stock in APD_formal accounts |
| κ | 17.72 | OU reversion speed (half-life ≈ 2 weeks) |
| μ | 1.08% | Long-run spread mean |
| σ | 15.36% | Annualized spread volatility |
| Ein/Eout | 8.44 | Entry/exit elasticity ratio |

**Scripts (PIT):**

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

**Queries (PIT):**

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

**Plots (PIT):**

| Plot | Description |
|------|-------------|
| `plots/01_surplus_dsr_eventos.png` | Surplus Buffer + DSR + governance events |
| `plots/02_correlacion_lags.png` | Lagged spread × DSR correlations (Table 4.2) |
| `plots/03_spread_dsr_aave.png` | DSR/Aave USDC spread time series |
| `plots/04_cooks_d_m3.png` | Cook's D — outlier diagnostics |
| `plots/05_sensibilidad_delta.png` | δ sensitivity across thresholds |
| `plots/08_figura_stock_spread_regimen.png` | Stock × spread by regime |
| `plots/12_flujos_DSR_SSR.png` | Net flows DSR vs SSR |

**Key contracts:**

| Contract | Address |
|----------|---------|
| MakerDAO Pot | `0x197e90f9fad81970ba7976f33cbd77088e5d7cf7` |
| sDAI | `0x83f20f44975d03b1b09e64809b757c47f942beea` |
| sUSDS | `0xa3931d71877c0e7a3148cb7eb4463524fec27fbd` |
| DSPause (GSM) | `0xbe286431454714f511008713973d3b053a2d38f3` |

Dune dashboard: [dune.com/facundovillega/pitevidences9makerdao20232025](https://dune.com/facundovillega/pitevidences9makerdao20232025)

---

### Paper 2 — Auction Design and Market Concentration in MakerDAO Liquidations: Evidence from Black Thursday, the LUNA Crash, and the Tariff Shock

**Working Paper v09 · Keywords: MakerDAO · DeFi liquidations · keeper market structure · Dutch auction · HHI · MEV**

This paper studies keeper market concentration across two liquidation mechanisms in MakerDAO: the English auction (Flip, 2020–2021) and the Dutch auction (Clipper, 2021–2026). Using on-chain data from Ethereum logs and transaction traces, we document that the transition to Clipper did not reduce market concentration — it increased it substantially under extreme stress conditions.

Three crisis episodes are analyzed: Black Thursday (March 2020), the LUNA Crash (May–June 2022), and the Tariff Shock (April 2025). The Herfindahl-Hirschman Index (HHI) varies dramatically across events: ~1,562 in Black Thursday, ~26 in the LUNA Crash, and ~8,371–9,546 in the Tariff Shock. This variation reveals that concentration is not a stable property of the mechanism, but a function of shock speed and intensity.

The LUNA Crash — the only event with genuine access competition, with 399 keepers and HHI count ~26 — shows that Clipper can function as designed under moderate and prolonged stress. However, under instantaneous high-magnitude shocks such as the Tariff Shock, a single keeper (0xc721) captured 97.68% of the ETH liquidated in a 67-minute window. Mann-Whitney tests (Monte Carlo, 50,000 permutations) confirm statistically significant differences across events (BT vs. LUNA: p < 0.001, |r| = 0.846; LUNA vs. Tariff: p = 0.005, |r| = 0.438).

The GSM's 48-hour delay — analyzed institutionally in Paper 1 — serves as the operational criterion for shock classification: events resolved before the GSM can activate are, by definition, ones against which governance has no available institutional response.

**Key results by event:**

| Event | Mechanism | HHI (count) | HHI (volume) | Top-1 share | Window |
|-------|-----------|-------------|--------------|-------------|--------|
| Black Thursday (Mar 2020) | Flip | ~1,562 | ~2,100 est. | 30.28% | 25 h |
| LUNA Crash (May–Jun 2022) | Clipper | ~26 | ~221 | 8.70% | 56 h |
| Tariff Shock (Apr 2025) | Clipper | ~8,371 | ~9,546 | 97.68% | 4 h (67 min active) |

**Queries (Paper 2):**

| Query | Description |
|-------|-------------|
| `queries/clipper_eth_a_cascade_intensity.sql` | Clipper ETH-A liquidation intensity by hour |

**Key contracts:**

| Contract | Address |
|----------|---------|
| Flipper ETH-A | `0xd8a04f5412223f513dc55f839574430f5ec15531` |
| Clipper ETH-A | `0xc67963a226eddd77b91ad7c421f538d4d7b1551b` |
| Dominant keeper — BT | `0x6066` (abbrev.) |
| Dominant keeper — Tariff | `0xc721` (abbrev.) |

---

## Repository Structure

```
defi-research/
├── README.md
├── .gitignore
├── data/                              # CSV exports from Dune (not versioned)
├── scripts/
│   ├── 01_chi_simulation.R            # PIT
│   ├── 02_surplus_buffer.R            # PIT
│   ├── 03_dsr_spread.R                # PIT
│   ├── 04_cascade_regression.R        # PIT
│   ├── 05_sensibilidad_delta.R        # PIT
│   ├── 06_regresion_spread.R          # PIT
│   ├── 07_ccf_flap_dsr.R              # PIT
│   ├── 08_figura_stock_spread_regimen.R  # PIT
│   ├── 09_regresion_elasticidades_clase.R  # PIT
│   ├── 10_correlacion_spells_inercia.R    # PIT
│   ├── 11_regresion_spread_neg_P5.R   # PIT
│   └── 12_flujos_DSR_SSR.R            # PIT + Paper 2
├── queries/
│   ├── PIT_11_delta_por_umbral_v1.sql        # PIT — Table A1
│   ├── PIT_13_flujos_por_clase_v1.sql        # PIT — Table 1
│   ├── PIT_14_flujos_netos_DSR_SSR_v1.sql    # PIT — DSR/SSR flows
│   ├── PIT_A1_composicion_pot_v1.sql         # PIT — Pot composition
│   ├── PIT_A3_flujos_DSR_SSR_v2.sql          # PIT
│   ├── PIT_A4_datos_regresion_v1.sql         # PIT — H4 dataset
│   ├── PIT_A5_ccf_flap_dsr_v1.sql            # PIT — CCF dataset
│   ├── clipper_eth_a_cascade_intensity.sql   # Paper 2 — Tariff Shock
│   ├── gsm_spells_por_anio.sql               # PIT — Table 4.1
│   ├── panel_submuestra_b_regression.sql     # PIT
│   └── pot_dsr_history.sql                   # PIT
├── plots/
│   ├── 01_surplus_dsr_eventos.png     # PIT
│   ├── 02_correlacion_lags.png        # PIT — Table 4.2
│   ├── 03_spread_dsr_aave.png         # PIT
│   ├── 04_cooks_d_m3.png              # PIT
│   ├── 05_sensibilidad_delta.png      # PIT
│   ├── 08_figura_stock_spread_regimen.png  # PIT
│   └── 12_flujos_DSR_SSR.png          # PIT + Paper 2
└── results/
```

---

## Theoretical Connection Between Papers

Both papers study the same protocol (MakerDAO) through complementary lenses:

**Paper 1 (PIT)** models the deposit layer: why programmatic agents (PDAs) maintain deposits under negative spread, and why the issuer's monetary lever fragments.

**Paper 2 (Liquidations)** models the liquidation layer: why keeper market concentration is not a stable property of the mechanism but a function of shock speed.

The structural link is **Lemma 3 of PIT**: the fixed integration cost K predicts endogenous low n* and concentration. In the deposit layer, K is the cost of deploying and auditing a PDA contract (n*=2: sDAI and Spark). In the liquidation layer, K is MEV execution infrastructure cost (n*≈1 under instantaneous shocks: 0xc721 in the Tariff Shock). The mechanism is the same; the layer is different.

The **GSM's 48-hour delay** appears in both papers: as the operational criterion for shock classification in Paper 2, and as the institutional constraint that lengthens PDA inertia intervals in Paper 1.

---

## Data Sources

- **Dune Analytics:** primary source for all on-chain data. Public dashboard: [dune.com/facundovillega/pitevidences9makerdao20232025](https://dune.com/facundovillega/pitevidences9makerdao20232025)
- **DeFi Llama yields API:** Aave USDC V3 rate series (`script 03_dsr_spread.R`)
- **Ethereum mainnet:** `ethereum.logs`, `ethereum.transactions`, `ethereum.traces`, `erc20_ethereum.evt_transfer`
- **MakerDAO-specific tables:** `maker_ethereum.Pot_call_join`, `maker_ethereum.Vow_call_flap`, `maker_ethereum.Pot_call_file`, `sky_ethereum.susds_call_ssr`

---

## Citation

Villega, F. (2026a). *Inertial Deposits and Monetary Transmission: A Theory of Programmatic Intermediation*. Working Paper v19. Independent Research.

Villega, F. (2026b). *Auction Design and Market Concentration in MakerDAO Liquidations: Evidence from Black Thursday, the LUNA Crash, and the Tariff Shock*. Working Paper v09. Independent Research.

---

*Draft. Do not cite without permission.*
