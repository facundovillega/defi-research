readme <- '# P4 — κ_coord: Governance Coordination Cost
## MakerDAO DSChief 2020–2025

Estimation of the on-chain governance coordination cost (κ_coord)
across 149 executive spells using lock event data from three DSChief
contract versions.

---

## Definition

κ_coord = mkr_movilizado × hours_coordination

Where:
- mkr_movilizado: MKR locked in the DSChief during the spell window [ts_propose, ts_lift]
- hours_coordination: duration of the voting window in hours

---

## Data

Source: Dune Analytics
- p4_01 (query 7485826): lock events all spells — three DSChief contracts
- p4_02 (query 7486415): HHI per spell — historical reconstruction from raw logs
- p4_03 (query 7486567): master table — 149 spells, 2020–2025

DSChief contracts:
- v1: 0x8e2a84d6ade1e7fffee039a35ef5f19f13057152 (2017–2023)
- v2: 0x9ef05f7f6deb616fd37ac3c959a2ddd25a54e4f5 (2019–2026)
- current: 0x0a3f6849f78076aefadf113f5bed87720274ddc0 (2020–present)

---

## Files

| File | Description |
|---|---|
| p4_kcoord_estimation.R | Full estimation script — API pull, cleaning, regressions |
| p4_03_con_kappa.csv | Final dataset (N=149, includes kappa_coord and all dummies) |
| p4_tabla_regresion.tex | LaTeX regression table (5 models, HC3 SE) |
| p4_tabla_regresion.txt | Plain text version |
| p4_diagnosticos_m2.png | Diagnostic plots — Model 2 |

---

## Regression Sample

N = 126 (excludes micro_spell: total_mkr < 1 MKR, n=23)

Dummies:
- whale_present: spell window overlaps with large holder position
  (36,074 MKR locked 2020-09-11 to 2020-12-19, n=12)
- micro_spell: total_mkr < 1 (excluded from regression)
- post_sky: ts_propose >= 2024-09-01 (n=12)

---

## Main Results

| Variable | Coef | SE (HC3) | p |
|---|---|---|---|
| log(1 + hours) | 1.672 | 0.453 | <0.001 |
| n_voters | 0.164 | 0.095 | 0.087 |
| HHI | 0.0002 | 0.0001 | 0.292 |
| whale_present | 1.022 | 0.937 | 0.278 |

R² = 0.190 (Model 2, baseline + whale control)

**Key finding**: κ_coord is driven by the temporal dimension of coordination
(hours to reach majority), not by voting concentration (HHI). MakerDAO
governance is structurally oligopolistic (HHI mean = 8,149) but
concentration does not predict coordination cost.

---

## Diagnostics

- Breusch-Pagan: BP = 3.025, df = 4, p = 0.554 (no heteroskedasticity)
- SE: HC3 robust (sandwich package)
- Outlier 0xffaef7a3 (row 31): 63,230 MKR, kappa = 3,035,819 — audited,
  legitimate large holder, not whale_present dummy
'

writeLines(readme,
  "~/Desktop/defi-research/paper3_governance/p4_kcoord/README.md")
cat("OK:", file.exists(
  "~/Desktop/defi-research/paper3_governance/p4_kcoord/README.md"), "\n")
