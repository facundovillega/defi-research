# ─────────────────────────────────────────────────────────────────────────────
# P4 — Coordinación On-chain y Costo de Integración en Governance Descentralizada
# Script: p4_04_kappa_regression_v1.R
# Autor:  Facundo Villega (Rigel231)
# Fecha:  2026-05
# Desc:   Re-especificación de κ_coord con datos corregidos de p4_01_v3
#         Variable dependiente: log(1 + mkr_movilizado × gsm_delay_hours)
#         Fuentes: Dune query 7503629 (p4_01_locks_dsChief_v3)
#                  Dune query 7486567 (p4_03_master_table)
# ─────────────────────────────────────────────────────────────────────────────

library(httr)
library(jsonlite)
library(sandwich)
library(lmtest)
library(texreg)
library(car)

# ── 0. Credenciales ───────────────────────────────────────────────────────────
DUNE_API_KEY <- Sys.getenv("DUNE_API_KEY")  # setenv o reemplazar directamente

# ── 1. Función auxiliar Dune ──────────────────────────────────────────────────
dune_fetch <- function(query_id, api_key) {
  exec <- POST(
    paste0("https://api.dune.com/api/v1/query/", query_id, "/execute"),
    add_headers("X-Dune-API-Key" = api_key),
    body = list(performance = "medium"),
    encode = "json"
  )
  execution_id <- content(exec)$execution_id
  cat("Query", query_id, "— Execution ID:", execution_id, "\n")

  repeat {
    st    <- GET(paste0("https://api.dune.com/api/v1/execution/", execution_id, "/status"),
                 add_headers("X-Dune-API-Key" = api_key))
    state <- content(st)$state
    cat("  Estado:", state, "\n")
    if (state == "QUERY_STATE_COMPLETED") break
    if (state == "QUERY_STATE_FAILED")    stop("Query falló: ", query_id)
    Sys.sleep(5)
  }

  res <- GET(paste0("https://api.dune.com/api/v1/execution/", execution_id, "/results"),
             add_headers("X-Dune-API-Key" = api_key))
  as.data.frame(fromJSON(toJSON(content(res)$result$rows)))
}

# ── 2. Carga de datos ─────────────────────────────────────────────────────────
# p4_01: lock events corregidos (DSChief real, ventana 14d pre-plot)
raw_p401 <- dune_fetch("7503629", DUNE_API_KEY)

# p4_03: tabla maestra con HHI y variables de concentración
raw_p403 <- dune_fetch("7486567", DUNE_API_KEY)

# ── 3. Limpieza y tipos ───────────────────────────────────────────────────────
df <- raw_p401
df$ts_plot         <- as.POSIXct(unlist(df$ts_plot),    format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
df$mkr_movilizado  <- as.numeric(unlist(df$mkr_movilizado))
df$gsm_delay_hours <- as.numeric(unlist(df$gsm_delay_hours))
df$n_lock_events   <- as.numeric(unlist(df$n_lock_events))
df$spell_address   <- unlist(df$spell_address)

p403 <- raw_p403
p403$spell_address  <- unlist(p403$spell_address)
p403$hhi            <- as.numeric(unlist(p403$hhi))
p403$top1_share_pct <- as.numeric(unlist(p403$top1_share_pct))

# ── 4. Construcción de variables ──────────────────────────────────────────────
df$kappa_proxy <- df$mkr_movilizado * df$gsm_delay_hours
df$log_kappa   <- log(1 + df$kappa_proxy)
df$log_mkr     <- log(1 + df$mkr_movilizado)
df$log_n_locks <- log(1 + df$n_lock_events)

# Dummies
df$whale_present <- as.integer(
  df$ts_plot >= as.POSIXct("2020-09-11", tz = "UTC") &
  df$ts_plot <= as.POSIXct("2020-12-19", tz = "UTC")
)
df$post_sky <- as.integer(df$ts_plot >= as.POSIXct("2024-09-01", tz = "UTC"))
df$year     <- as.integer(format(df$ts_plot, "%Y"))

# ── 5. Join con p4_03 para HHI ───────────────────────────────────────────────
df <- merge(df, p403[, c("spell_address", "hhi", "top1_share_pct")],
            by = "spell_address", all.x = TRUE)

# ── 6. Muestras ───────────────────────────────────────────────────────────────
# Muestra principal: excluye spells sin MKR observable
smp     <- df[df$mkr_movilizado > 0, ]

# Subsample: solo spells con HHI disponible (p4_03, spells de alta participación)
smp_hhi <- smp[!is.na(smp$hhi), ]

cat("\n── Estadísticos de muestra ─────────────────────────────────\n")
cat("N total p4_01:         ", nrow(df), "\n")
cat("N muestra principal:   ", nrow(smp), "  (mkr_movilizado > 0)\n")
cat("N subsample HHI:       ", nrow(smp_hhi), "  (con concentración observable)\n")
cat("Spells excluidos:      ", nrow(df) - nrow(smp), "\n")
cat("Rango kappa_proxy:     ", round(min(smp$kappa_proxy), 1),
    "→", round(max(smp$kappa_proxy), 0), "\n")
cat("Mediana mkr_movilizado:", round(median(smp$mkr_movilizado), 0), "\n")

# ── 7. Modelos ────────────────────────────────────────────────────────────────
# M1-M3: muestra completa (N=217), sin HHI
M1 <- lm(log_kappa ~ log_mkr + gsm_delay_hours + log_n_locks,
         data = smp)
M2 <- lm(log_kappa ~ log_mkr + gsm_delay_hours + log_n_locks + whale_present,
         data = smp)
M3 <- lm(log_kappa ~ log_mkr + gsm_delay_hours + log_n_locks + whale_present + post_sky,
         data = smp)

# M4-M5: subsample HHI (N=149), robustez con concentración
M4 <- lm(log_kappa ~ log_mkr + gsm_delay_hours + log_n_locks + hhi,
         data = smp_hhi)
M5 <- lm(log_kappa ~ log_mkr + gsm_delay_hours + log_n_locks + hhi + whale_present,
         data = smp_hhi)

# ── 8. SE robustos HC3 ────────────────────────────────────────────────────────
models <- list(M1, M2, M3, M4, M5)
se_hc3 <- lapply(models, function(m) sqrt(diag(vcovHC(m, type = "HC3"))))
pval   <- lapply(seq_along(models), function(i)
  2 * pt(-abs(coef(models[[i]]) / se_hc3[[i]]),
         df = models[[i]]$df.residual))

# ── 9. Tabla principal ────────────────────────────────────────────────────────
cat("\n── Cuadro 6: Determinantes de κ_coord ──────────────────────\n")
screenreg(models,
          override.se      = se_hc3,
          override.pvalues = pval,
          stars   = c(0.001, 0.01, 0.05, 0.1),
          digits  = 3,
          custom.model.names = paste0("M", 1:5),
          custom.coef.names  = c("Constante", "log(1+MKR)", "GSM delay (h)",
                                 "log(1+n_locks)", "Whale dummy",
                                 "Post-Sky dummy", "HHI"))

cat("\nR² M1 (base):", round(summary(M1)$r.squared, 3), "\n")
cat("R² M3:       ", round(summary(M3)$r.squared, 3), "\n")
cat("R² M4:       ", round(summary(M4)$r.squared, 3), "\n")
cat("R² M5:       ", round(summary(M5)$r.squared, 3), "\n")

# ── 10. Diagnósticos M1 y M4 ─────────────────────────────────────────────────
cat("\n── Breusch-Pagan M1 ─────────────────────────────────────────\n")
print(bptest(M1))

cat("\n── Breusch-Pagan M4 ─────────────────────────────────────────\n")
print(bptest(M4))

cat("\n── VIF M4 ───────────────────────────────────────────────────\n")
print(vif(M4))

cat("\n── Correlaciones entre regresores (smp_hhi) ─────────────────\n")
cat("log_mkr ~ gsm_delay_hours:", cor(smp_hhi$log_mkr, smp_hhi$gsm_delay_hours), "\n")
cat("log_mkr ~ hhi:            ", cor(smp_hhi$log_mkr, smp_hhi$hhi, use="complete.obs"), "\n")
cat("gsm_delay_hours ~ hhi:    ", cor(smp_hhi$gsm_delay_hours, smp_hhi$hhi, use="complete.obs"), "\n")

# ── 11. Diagnóstico de muestra: faltantes de HHI ─────────────────────────────
faltantes <- smp[is.na(smp$hhi), ]
cat("\n── Faltantes HHI (N=", nrow(faltantes), ") ──────────────────────────────\n")
cat("Distribución por año:\n")
print(table(format(faltantes$ts_plot, "%Y")))
cat("Mediana mkr faltantes:", round(median(faltantes$mkr_movilizado), 0), "\n")
cat("Mediana mkr smp_hhi:  ", round(median(smp_hhi$mkr_movilizado), 0), "\n")

# ── 12. R² efecto muestra: M1 sobre smp_hhi ──────────────────────────────────
M1_hhi <- lm(log_kappa ~ log_mkr + gsm_delay_hours + log_n_locks, data = smp_hhi)
cat("\n── Efecto muestra sobre R² ──────────────────────────────────\n")
cat("R² M1 muestra completa (N=217):", round(summary(M1)$r.squared, 3), "\n")
cat("R² M1 subsample HHI   (N=149):", round(summary(M1_hhi)$r.squared, 3), "\n")
cat("Diferencia explicada por selección, no por HHI\n")

# ── 13. Outlier principal ─────────────────────────────────────────────────────
cat("\n── Top 5 por kappa_proxy ────────────────────────────────────\n")
top5 <- smp[order(-smp$kappa_proxy), ][1:5, c("spell_address","ts_plot","mkr_movilizado","gsm_delay_hours","kappa_proxy")]
top5$ts_plot <- format(top5$ts_plot, "%Y-%m-%d")
print(top5, row.names = FALSE)
