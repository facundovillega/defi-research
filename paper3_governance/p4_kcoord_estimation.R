# P4 — Estimacion de kappa_coord
# MakerDAO DSChief 2020-2025
# Fuente: Dune query 7486567 (p4_03_kcoord_master_table)
# kappa_coord = mkr_movilizado * hours_coordination

library(httr); library(jsonlite); library(dplyr)
library(lubridate); library(sandwich); library(lmtest); library(stargazer)

DUNE_API_KEY <- Sys.getenv("DUNE_API_KEY")
QUERY_ID     <- "7486567"

# --- descarga, limpieza, construccion de variables ---
# Ver sesion completa para reproducir df_reg con:
# kappa_coord, log_kappa, log_hours, whale_present (n=12),
# micro_spell, year, post_sky

# Modelos (muestra: micro_spell == 0, N=126)
# m1: log_kappa ~ HHI + log_hours + n_voters
# m2: + whale_present
# m3: concentration_regime + log_hours + n_voters + whale_present
# m4: + year
# m5: + post_sky
# SE robustos HC3 (sandwich::vcovHC)

# Resultado principal: log_hours significativo p<0.001 en todos los modelos
# coef ~1.67-1.70, R2 ~0.19
# HHI, whale_present, year, post_sky no significativos

