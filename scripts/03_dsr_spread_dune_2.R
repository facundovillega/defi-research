# 03_dsr_spread_dune.R
# H4: Spread DSR/Aave USDC como predictor del DSR
# Fuente: Dune Analytics, query 7384994 (PIT_OU_spread_calibration_v1)
# Columnas: week_start, dsr_pct, aave_usdc_pct, spread_pct, flap_count
# Muestra: n=141, jul 2023 - abr 2026, excl. 2 outliers
# Outliers: 2023-07-24 (spike Aave 32.7%, rally crypto)
#           2026-04-13 (spike Aave 12.6%, shock arancelario Trump)
# SE: Newey-West lag=4 (Newey & West 1987, Econometrica 55(3): 703-708)

library(conflicted)
library(tidyverse)
library(httr2)
library(jsonlite)
library(sandwich)
library(lmtest)

conflict_prefer("filter",  "dplyr")
conflict_prefer("lag",     "dplyr")
conflict_prefer("flatten", "purrr")


# 1. Configuracion

DUNE_QUERY_ID <- "7384994"
CACHE_PATH    <- "data/cache_query_7384994.rds"
NW_LAG        <- 4
MAX_LAGS      <- 12

OUTLIERS <- as.Date(c(
  "2023-07-24",
  "2026-04-13"
))


# 2. Descarga desde Dune Analytics API v3

fetch_dune <- function(query_id,
                       api_key    = Sys.getenv("DUNE_API_KEY"),
                       cache_path = NULL,
                       refresh    = FALSE) {

  if (!is.null(cache_path) && file.exists(cache_path) && !refresh) {
    message("Cargando desde cache: ", cache_path)
    return(readRDS(cache_path))
  }

  base_url <- "https://api.dune.com/api/v1"

  resp_exec <- request(paste0(base_url, "/query/", query_id, "/execute")) |>
    req_headers("X-Dune-API-Key" = api_key) |>
    req_method("POST") |>
    req_perform()

  exec_id <- resp_body_json(resp_exec)$execution_id
  message("Execution ID: ", exec_id)

  MAX_WAIT_SEC <- 300
  start_time   <- Sys.time()

  repeat {
    Sys.sleep(2)
    resp_status <- request(paste0(base_url, "/execution/", exec_id, "/status")) |>
      req_headers("X-Dune-API-Key" = api_key) |>
      req_perform()

    state <- resp_body_json(resp_status)$state
    message("Estado: ", state)
    if (state %in% c("QUERY_STATE_COMPLETED", "QUERY_STATE_FAILED")) break

    elapsed <- as.numeric(Sys.time() - start_time, units = "secs")
    if (elapsed > MAX_WAIT_SEC) {
      stop("Timeout: la query tardo mas de ", MAX_WAIT_SEC, " segundos.")
    }
  }

  if (state == "QUERY_STATE_FAILED") stop("La query fallo en Dune.")

  resp_results <- request(paste0(base_url, "/execution/", exec_id, "/results")) |>
    req_headers("X-Dune-API-Key" = api_key) |>
    req_perform()

  parsed <- resp_body_json(resp_results, simplifyVector = TRUE)
  df     <- as.data.frame(parsed$result$rows)

  if (!is.null(cache_path)) {
    dir.create(dirname(cache_path), showWarnings = FALSE, recursive = TRUE)
    saveRDS(df, cache_path)
    message("Cache guardado: ", cache_path)
  }

  df
}


# 3. Descarga y construccion del dataset

df_raw <- fetch_dune(DUNE_QUERY_ID, cache_path = CACHE_PATH)

message("Columnas disponibles: ", paste(names(df_raw), collapse = ", "))
message("N filas raw: ", nrow(df_raw))

# Validacion de columnas esperadas de query 7384994
cols_req <- c("week_start", "dsr_pct", "aave_usdc_pct", "spread_pct", "flap_count")
cols_miss <- setdiff(cols_req, names(df_raw))
if (length(cols_miss) > 0) {
  stop("Columnas faltantes en query 7384994: ", paste(cols_miss, collapse = ", "))
}

# Renombrar para consistencia interna y calcular spread si no viene
df_base <- df_raw |>
  rename(week      = week_start,
         aave_rate = aave_usdc_pct,
         spread    = spread_pct) |>
  mutate(week   = as.Date(week),
         spread = as.numeric(spread),
         dsr_pct     = as.numeric(dsr_pct),
         aave_rate   = as.numeric(aave_rate),
         flap_count  = as.numeric(flap_count)) |>
  arrange(week) |>
  filter(!is.na(dsr_pct), !is.na(flap_count), !is.na(spread))

message("N filas post-limpieza (antes de excluir outliers): ", nrow(df_base))


# 4. Construccion de la muestra H4
# Variable dependiente : dsr_next = DSR semana siguiente
# Predictores         : spread, flap_count (contemporaneos)
# Periodo             : julio 2023 - abril 2026

df_h4 <- df_base |>
  mutate(dsr_next = lead(dsr_pct, 1)) |>
  filter(week >= as.Date("2023-07-01"),
         week <= as.Date("2026-04-30")) |>
  filter(!week %in% OUTLIERS) |>
  filter(!is.na(dsr_next))

n_final <- nrow(df_h4)
message("\nMuestra H4 final: n = ", n_final)
message("Periodo: ", min(df_h4$week), " a ", max(df_h4$week))
message("Outliers excluidos: ", paste(format(OUTLIERS), collapse = ", "))

if (n_final != 141) {
  warning("N esperado = 141, obtenido = ", n_final,
          ". Verificar fechas de outliers o rango temporal.")
}


# 5. Regresiones

# 5a. Modelo conjunto
modelo_conjunto <- lm(dsr_next ~ spread + flap_count, data = df_h4)

cat("\n=== MODELO CONJUNTO: dsr_next ~ spread + flap_count ===\n")
cat("n =", n_final, "| jul 2023 - abr 2026\n")
cat("Outliers excluidos: 2023-07-24 y 2026-04-13\n\n")
print(summary(modelo_conjunto))

nw_conjunto <- coeftest(modelo_conjunto,
                        vcov = NeweyWest(modelo_conjunto, lag = NW_LAG))
cat("\n--- SE Newey-West (lag =", NW_LAG, ") ---\n")
print(nw_conjunto)

r2_conjunto <- summary(modelo_conjunto)$r.squared
r2_adj_conj <- summary(modelo_conjunto)$adj.r.squared

fstat_nw <- waldtest(modelo_conjunto,
                     vcov = NeweyWest(modelo_conjunto, lag = NW_LAG))
cat("\nF-stat Newey-West:\n")
print(fstat_nw)

cat("\nR²     =", round(r2_conjunto, 4))
cat("\nR² adj =", round(r2_adj_conj, 4), "\n")


# 5b. Modelo univariado: spread solo
modelo_spread <- lm(dsr_next ~ spread, data = df_h4)

cat("\n=== MODELO UNIVARIADO: dsr_next ~ spread ===\n")
print(summary(modelo_spread))

nw_spread <- coeftest(modelo_spread,
                      vcov = NeweyWest(modelo_spread, lag = NW_LAG))
cat("\n--- SE Newey-West (lag =", NW_LAG, ") ---\n")
print(nw_spread)

r2_spread <- summary(modelo_spread)$r.squared
cat("\nR² spread solo =", round(r2_spread, 4), "\n")


# 5c. Modelo univariado: flap solo
modelo_flap <- lm(dsr_next ~ flap_count, data = df_h4)

cat("\n=== MODELO UNIVARIADO: dsr_next ~ flap_count ===\n")
print(summary(modelo_flap))

r2_flap <- summary(modelo_flap)$r.squared
cat("\nR² flap solo =", round(r2_flap, 4), "\n")


# 6. Tabla resumen — Cuadro 5b

p_spread <- nw_conjunto["spread",     "Pr(>|t|)"]
p_flap   <- nw_conjunto["flap_count", "Pr(>|t|)"]

fmt_p <- function(p) {
  if (p < 0.001) "< 0.001"
  else if (p < 0.01) paste0("= ", round(p, 3))
  else paste0("= ", round(p, 3))
}

cat("\n")
cat("=============================================================\n")
cat("  CUADRO 5b -- Estadisticos H4 para el paper\n")
cat("=============================================================\n")
cat(sprintf("  Muestra  : n = %d semanas (jul 2023 - abr 2026)\n", n_final))
cat(sprintf("  Outliers : 2 excluidos (rally crypto jul-23; shock arancelario abr-26)\n\n"))
cat("  Modelo conjunto (dsr_next ~ spread + flap_count):\n")
cat(sprintf("    beta_spread = %.4f  (SE NW = %.4f, t = %.2f, p %s)\n",
            coef(modelo_conjunto)["spread"],
            nw_conjunto["spread", "Std. Error"],
            nw_conjunto["spread", "t value"],
            fmt_p(p_spread)))
cat(sprintf("    beta_flap   = %.4f  (SE NW = %.4f, t = %.2f, p %s)\n",
            coef(modelo_conjunto)["flap_count"],
            nw_conjunto["flap_count", "Std. Error"],
            nw_conjunto["flap_count", "t value"],
            fmt_p(p_flap)))
cat(sprintf("    R2          = %.4f\n", r2_conjunto))
cat(sprintf("    R2 adj      = %.4f\n", r2_adj_conj))
cat(sprintf("    SE          : Newey-West, lag = %d\n\n", NW_LAG))
cat("  Modelos univariados:\n")
cat(sprintf("    R2 spread solo  = %.4f\n", r2_spread))
cat(sprintf("    R2 flap solo    = %.4f\n", r2_flap))
cat(sprintf("    DeltaR2 (incr.) = %.4f\n", r2_conjunto - r2_spread))
cat("=============================================================\n\n")


# 7. Correlaciones por lag (diagnostico)

correlaciones_spread <- map_dfr(1:MAX_LAGS, function(k) {
  tibble(
    lag_semanas = k,
    correlacion = cor(dplyr::lag(df_h4$spread, k),
                      df_h4$dsr_next,
                      use = "complete.obs")
  )
})

cat("--- Correlaciones spread x dsr_next por lag ---\n")
print(correlaciones_spread)


# 8. Graficos

dir.create("plots", showWarnings = FALSE)

p_series <- df_h4 |>
  select(week, dsr_pct, aave_rate, spread) |>
  pivot_longer(-week, names_to = "variable", values_to = "valor") |>
  mutate(variable = recode(variable,
    dsr_pct   = "DSR (%)",
    aave_rate = "Aave USDC V3 (%)",
    spread    = "Spread DSR/Aave (pp)")) |>
  ggplot(aes(x = week, y = valor, color = variable)) +
  geom_line(linewidth = 0.8) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  scale_color_manual(values = c("#1F77B4", "#D62728", "#2CA02C")) +
  labs(title    = "DSR, Aave USDC V3 y Spread — julio 2023 – abril 2026",
       subtitle = sprintf("Muestra H4 (n = %d, outliers excluidos)", n_final),
       x = NULL, y = "Tasa / Spread (%)", color = NULL) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom")

ggsave("plots/03_series_dsr_aave_spread.png",
       p_series, width = 10, height = 5, dpi = 150)

p_scatter <- ggplot(df_h4, aes(x = spread, y = dsr_next)) +
  geom_point(alpha = 0.5, color = "#D62728", size = 1.5) +
  geom_smooth(method = "lm", se = TRUE, color = "gray30", linewidth = 0.8) +
  labs(
    title    = "Spread DSR/Aave USDC vs DSR (t+1)",
    subtitle = sprintf("n = %d | R2 = %.4f | beta = %.4f (SE NW = %.4f)",
                       n_final, r2_spread,
                       coef(modelo_spread)["spread"],
                       nw_spread["spread", "Std. Error"]),
    x = "Spread DSR/Aave USDC (pp)",
    y = "DSR semana siguiente (%)") +
  theme_minimal(base_size = 12)

ggsave("plots/03_scatter_spread_dsr_next.png",
       p_scatter, width = 7, height = 5, dpi = 150)

p_lags <- ggplot(correlaciones_spread, aes(x = lag_semanas, y = correlacion)) +
  geom_col(fill = "#D62728", alpha = 0.8) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray40") +
  scale_x_continuous(breaks = 1:MAX_LAGS) +
  labs(title    = "Spread DSR/Aave como predictor del DSR (t+1)",
       subtitle = "Correlacion de Pearson por lag",
       x = "Lag (semanas)", y = "Correlacion de Pearson") +
  theme_minimal(base_size = 12)

ggsave("plots/03_correlacion_spread_lags_dune.png",
       p_lags, width = 8, height = 5, dpi = 150)

message("\nGraficos guardados en plots/")


# 9. Export resultados

sink("resultados_h4_dune.txt")
cat("=== H4: SPREAD DSR/AAVE USDC COMO PREDICTOR DEL DSR ===\n")
cat("Fecha:", format(Sys.Date()), "\n")
cat("Fuente: Dune Analytics — query 7384994 (PIT_OU_spread_calibration_v1)\n")
cat("Muestra: n =", n_final, "| jul 2023 – abr 2026\n")
cat("Outliers excluidos: 2023-07-24 (rally crypto), 2026-04-13 (shock arancelario)\n\n")
cat("--- Modelo conjunto (SE Newey-West, lag=4) ---\n\n")
print(nw_conjunto)
cat("\nR2 =", round(r2_conjunto, 4), "| R2 adj =", round(r2_adj_conj, 4), "\n")
cat("\n--- Modelo univariado spread ---\n")
print(nw_spread)
cat("\nR2 spread solo =", round(r2_spread, 4), "\n")
cat("\n--- Modelo univariado flap ---\n")
print(summary(modelo_flap))
cat("\nR2 flap solo =", round(r2_flap, 4), "\n")
cat("\n--- Correlaciones spread x dsr_next por lag ---\n")
print(as.data.frame(correlaciones_spread))
sink()

message("Resultados exportados a resultados_h4_dune.txt")
message("Script completado. Verificar n=141 en Cuadro 5b.")


# 10. Especificaciones alternativas — busqueda de significancia de flap
# Variables disponibles en query 7384994: flap_count_lag1, spread_lag1

cat("\n")
cat("=============================================================\n")
cat("  ESPECIFICACIONES ALTERNATIVAS\n")
cat("=============================================================\n\n")

# 10a. Con flap_count_lag1 (flap rezagado 1 semana)
df_h4_lag <- df_base |>
  rename(flap_count_lag1 = flap_count_lag1,
         spread_lag1     = spread_lag1) |>
  mutate(flap_count_lag1 = as.numeric(flap_count_lag1),
         spread_lag1     = as.numeric(spread_lag1),
         dsr_next        = lead(dsr_pct, 1)) |>
  filter(week >= as.Date("2023-07-01"),
         week <= as.Date("2026-04-30")) |>
  filter(!week %in% OUTLIERS) |>
  filter(!is.na(dsr_next))

# Especificacion A: spread + flap_lag1
cat("--- Especificacion A: dsr_next ~ spread + flap_count_lag1 ---\n")
mod_A <- lm(dsr_next ~ spread + flap_count_lag1, data = df_h4_lag)
nw_A  <- coeftest(mod_A, vcov = NeweyWest(mod_A, lag = NW_LAG))
print(nw_A)
cat("R2 =", round(summary(mod_A)$r.squared, 4), "\n\n")

# Especificacion B: spread_lag1 + flap_count (ambos rezagados 1 semana)
cat("--- Especificacion B: dsr_next ~ spread_lag1 + flap_count ---\n")
mod_B <- lm(dsr_next ~ spread_lag1 + flap_count, data = df_h4_lag)
nw_B  <- coeftest(mod_B, vcov = NeweyWest(mod_B, lag = NW_LAG))
print(nw_B)
cat("R2 =", round(summary(mod_B)$r.squared, 4), "\n\n")

# Especificacion C: spread_lag1 + flap_count_lag1 (ambos con lag1)
cat("--- Especificacion C: dsr_next ~ spread_lag1 + flap_count_lag1 ---\n")
mod_C <- lm(dsr_next ~ spread_lag1 + flap_count_lag1, data = df_h4_lag)
nw_C  <- coeftest(mod_C, vcov = NeweyWest(mod_C, lag = NW_LAG))
print(nw_C)
cat("R2 =", round(summary(mod_C)$r.squared, 4), "\n\n")

# Especificacion D: spread + flap_count (baseline, sin lag — para comparar)
cat("--- Especificacion D (baseline): dsr_next ~ spread + flap_count ---\n")
cat("(ya corrida arriba — se replica aqui para comparacion directa)\n")
print(nw_conjunto)
cat("R2 =", round(r2_conjunto, 4), "\n\n")

# Tabla comparativa
cat("=============================================================\n")
cat("  TABLA COMPARATIVA DE ESPECIFICACIONES\n")
cat("=============================================================\n")
cat(sprintf("  %-12s %-8s %-8s %-8s %-8s %-8s %-8s\n",
            "Spec", "b_spread", "p_spr", "b_flap", "p_flap", "R2", "n"))
cat(sprintf("  %s\n", paste(rep("-", 70), collapse="")))

specs <- list(
  list(name="A: spr+flap1",  mod=mod_A, nw=nw_A,  sv="spread",     fv="flap_count_lag1"),
  list(name="B: spr1+flap",  mod=mod_B, nw=nw_B,  sv="spread_lag1", fv="flap_count"),
  list(name="C: spr1+flap1", mod=mod_C, nw=nw_C,  sv="spread_lag1", fv="flap_count_lag1"),
  list(name="D: spr+flap",   mod=modelo_conjunto, nw=nw_conjunto, sv="spread", fv="flap_count")
)

for (s in specs) {
  b_s  <- coef(s$mod)[s$sv]
  p_s  <- s$nw[s$sv,        "Pr(>|t|)"]
  b_f  <- coef(s$mod)[s$fv]
  p_f  <- s$nw[s$fv,        "Pr(>|t|)"]
  r2   <- summary(s$mod)$r.squared
  n_s  <- nobs(s$mod)
  cat(sprintf("  %-12s %-8.4f %-8.3f %-8.4f %-8.3f %-8.4f %-8d\n",
              s$name, b_s, p_s, b_f, p_f, r2, n_s))
}
cat("=============================================================\n\n")
cat("Nota: p_flap < 0.05 indica significancia al 5% con SE Newey-West\n\n")
