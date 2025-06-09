# Compare GCP with Hector LUC inputs

library(dplyr)
library(tidyr)
library(readxl)
library(hector)
library(ggplot2)

theme_set(theme_bw())


# 1. Load Hector ---------------------------------------------------------------
read.csv("selected_GCP.csv") %>%
    mutate(GCP = as.character(GCP)) ->
    GCP_data

system.file(package = "hector", "input/tables") %>%
    file.path("ssp245_emiss-constraints_rf.csv") %>%
    read.csv(comment.char = ";") %>%
    filter(Date <= 2024) %>%
    select(year = Date, value = luc_emissions) %>%
    mutate(variable = "luc_emissions", units = getunits(LUC_EMISSIONS())) %>%
    mutate(GCP = "rcmip") ->
    hector


ggplot() +
    geom_line(data = GCP_data, aes(year, value, color = GCP))



ggplot() +
    geom_line(data = GCP_data, aes(year, value, by = GCP, color = "GCP"), alpha = 0.5) +
    geom_line(data = hector, aes(year, value, color = "hector")) +
    scale_color_manual(values = c("GCP" = "black", "hector" = "red")) +
    theme(legend.title = element_blank()) +
    labs(x = NULL, y = getunits(LUC_EMISSIONS()), title =  LUC_EMISSIONS())

