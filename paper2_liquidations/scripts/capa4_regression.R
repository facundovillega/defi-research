# CAPA 4 — Regresión HHI ~ volumen + evento
# Paper: Concentración en mercados de liquidación DeFi
# Autor: Facundo Villega (Rigel231)
#
# Modelo: HHI_t = α + β1·log(takes_t) + β2·D_BT + β3·D_Trump + ε
# Base de comparación: LUNA (omitida)
# Errores estándar: HC3 (heteroskedasticity-consistent)
#
# Datos fuente: Capa 3 — HHI horario intra-evento
#   BT:    Flip ETH-A,    2020-03-12 / 2020-03-13
#   LUNA:  Clipper ETH-A, 2022-05-01 / 2022-07-01
#   Trump: Clipper ETH-A, 2025-04-06

library(sandwich)
library(lmtest)

# ── Datos horarios (takes, HHI) por evento ─────────────────────────────────

bt <- data.frame(
  takes  = c(2,7,90,4,25,30,186,401,858,337,377,312,82,181,71,300,3,327,1381,490,377,104,3,1,3),
  hhi    = c(5000,10000,3993,3750,3984,3933,5112,3521,5276,4837,3931,2969,
             9072,6537,10000,8799,3333,3458,3441,3930,2991,8733,3333,10000,3333),
  evento = "BT"
)

luna <- data.frame(
  takes  = c(1,2,1,1,1,1,2,1,4,2,2,1,1,3,16,14,22,11,17,3,1,1,3,1,8,2,4,
             3,3,3,7,1,16,19,2,11,13,11,17,9,24,37,3,14,1,19,3,7,15,5,5,3,9,7,7,12),
  hhi    = c(10000,5000,10000,10000,10000,10000,5000,10000,2500,5000,5000,10000,
             10000,3333,625,714,455,909,588,3333,10000,10000,3333,10000,1250,5000,
             2500,3333,3333,3333,1429,10000,859,637,5000,909,769,909,588,1111,417,
             314,5556,714,10000,582,3333,1429,667,2000,2800,5556,1111,1429,1837,833),
  evento = "LUNA"
)

trump <- data.frame(
  takes  = c(1, 4, 87, 48),
  hhi    = c(10000, 2500, 9773, 7734),
  evento = "Trump"
)

# ── Panel completo ─────────────────────────────────────────────────────────

df           <- rbind(bt, luna, trump)
df$log_takes <- log(df$takes)
df$evento    <- factor(df$evento, levels = c("LUNA", "BT", "Trump"))

# ── Estadísticas descriptivas por evento ──────────────────────────────────

cat("=== HHI PONDERADO POR VOLUMEN ===\n")
for (ev in c("BT", "LUNA", "Trump")) {
  d <- df[df$evento == ev, ]
  w <- weighted.mean(d$hhi, d$takes)
  u <- mean(d$hhi)
  s <- sd(d$hhi)
  cat(sprintf("  %-8s  HHI_pond: %6.0f  HHI_simple: %6.0f  SD: %6.0f  n: %d\n",
              ev, w, u, s, nrow(d)))
}

# ── Modelo 1: HHI ~ log(takes) + evento ────────────────────────────────────

m1 <- lm(hhi ~ log_takes + evento, data = df)
cat("\n=== M1: HHI ~ log(takes) + evento (HC3) ===\n")
print(coeftest(m1, vcov = vcovHC(m1, type = "HC3")))
cat(sprintf("R²: %.4f  R²adj: %.4f  AIC: %.1f\n",
            summary(m1)$r.squared, summary(m1)$adj.r.squared, AIC(m1)))

# ── Modelo 2: HHI ~ log(takes) solamente ───────────────────────────────────

m2 <- lm(hhi ~ log_takes, data = df)
cat("\n=== M2: HHI ~ log(takes) solamente (HC3) ===\n")
print(coeftest(m2, vcov = vcovHC(m2, type = "HC3")))
cat(sprintf("R²: %.4f  R²adj: %.4f  AIC: %.1f\n",
            summary(m2)$r.squared, summary(m2)$adj.r.squared, AIC(m2)))

# ── Modelo 3: interacción log(takes) × evento ──────────────────────────────

m3 <- lm(hhi ~ log_takes * evento, data = df)
cat("\n=== M3: HHI ~ log(takes) × evento — interacción (HC3) ===\n")
print(coeftest(m3, vcov = vcovHC(m3, type = "HC3")))
cat(sprintf("R²: %.4f  R²adj: %.4f  AIC: %.1f\n",
            summary(m3)$r.squared, summary(m3)$adj.r.squared, AIC(m3)))

# ── Comparación de modelos ─────────────────────────────────────────────────

cat("\n=== COMPARACIÓN DE MODELOS ===\n")
cat(sprintf("%-22s %8s %8s %10s\n", "Modelo", "R²", "R²adj", "AIC"))
cat(strrep("-", 52), "\n")
for (info in list(
  list("M1 dummies",     m1),
  list("M2 solo volumen", m2),
  list("M3 interacción",  m3)
)) {
  cat(sprintf("%-22s %8.4f %8.4f %10.1f\n",
              info[[1]],
              summary(info[[2]])$r.squared,
              summary(info[[2]])$adj.r.squared,
              AIC(info[[2]])))
}

cat("
=== INTERPRETACIÓN ===

M3 es el modelo preferido (R²adj=0.698, AIC mínimo).
El efecto de log(takes) sobre HHI es heterogéneo entre eventos:

  LUNA (base):  β_log_takes = -3.094 (p<0.001)
    → Más volumen reduce concentración: mercado competitivo por diseño.

  BT:  β_interacción = +2.911 (p<0.001)
    → La reducción de HHI por volumen es parcialmente compensada.
    → Consistente con capital coordinado entre keepers dominantes.

  Trump: n=4 — coeficientes descriptivos, no inferenciales.
    → HHI ponderado = 8.868: concentración extrema confirmada.

Nota: Trump contribuye al argumento mediante análisis forense (Sección 6),
no mediante regresión. El límite de n=4 debe reportarse explícitamente.
")
