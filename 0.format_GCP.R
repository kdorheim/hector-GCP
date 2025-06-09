# Format the global carbon project data into easy to plot csv file.

library(dplyr)
library(tidyr)
library(readxl)
library(hector)
library(ggplot2)

theme_set(theme_bw())

# 1. 2007 Data Set -------------------------------------------------------------
f <- "CarbonBudget_2007-Data.xls"
yr <- gsub(pattern = "CarbonBudget_|-Data.xls", replacement = "", x = f)

read_excel(f, sheet = "PNAS", skip = 2) %>%
    select(year, luc_emissions = `land use`) %>%
    pivot_longer(-year, names_to = "variable") %>%
    na.omit %>%
    mutate(GCP = yr) %>%
    mutate(year = as.integer(year), value = as.numeric(value)) ->
    data_2007


# 2. 2010 Data Set -------------------------------------------------------------

f <- "CarbonBudget_2010-Data.xls"
yr <- gsub(pattern = "CarbonBudget_|-Data.xls", replacement = "", x = f)
read_excel(f, sheet = 1) %>%
    select(year = time, luc_emissions = `land-use`) %>%
    pivot_longer(-year, names_to = "variable") %>%
    na.omit %>%
    mutate(GCP = yr) %>%
    mutate(year = as.integer(year), value = as.numeric(value)) ->
    data_2010



# 3. 2015 Data Set -------------------------------------------------------------

f <- "CarbonBudget_2015-Data-Global.xlsx"
yr <- gsub(pattern = "CarbonBudget_|-Data-Global.xlsx", replacement = "", x = f)
read_excel(f, sheet = "Historical Budget", skip = 14) %>%
    select(year = Year, luc_emissions = `land-use change emissions`) %>%
    pivot_longer(-year, names_to = "variable") %>%
    na.omit %>%
    mutate(GCP = yr) %>%
    mutate(year = as.integer(year), value = as.numeric(value)) ->
    data_2015

# 4. 2020 Data Set -------------------------------------------------------------
f <- "CarbonBudget_2020-Data-Global.xlsx"
yr <- gsub(pattern = "CarbonBudget_|-Data-Global.xlsx", replacement = "", x = f)
read_excel(f, sheet = "Historical Budget", skip = 14) %>%
    select(year = Year, luc_emissions = `land-use change emissions`) %>%
    pivot_longer(-year, names_to = "variable") %>%
    na.omit %>%
    mutate(GCP = yr) %>%
    mutate(year = as.integer(year), value = as.numeric(value)) ->
    data_2020



# 5. 2023 Data Set -------------------------------------------------------------
f <- "Global_Carbon_Budget_2023v1.1.xlsx"
yr <- gsub(pattern = "Global_Carbon_Budget_|v1.1.xlsx", replacement = "", x = f)
read_excel(f, sheet = "Historical Budget", skip = 15) %>%
    select(year = Year, luc_emissions = `land-use change emissions`) %>%
    pivot_longer(-year, names_to = "variable") %>%
    na.omit %>%
    mutate(GCP = yr) %>%
    mutate(year = as.integer(year), value = as.numeric(value)) ->
    data_2023


# 6. 2024 Data Set -------------------------------------------------------------
f <- "Global_Carbon_Budget_2024_v1.0.xlsx"
yr <- gsub(pattern = "Global_Carbon_Budget_|_v1.0.xlsx", replacement = "", x = f)
read_excel(f, sheet = "Historical Budget", skip = 15) %>%
    select(year = Year, luc_emissions = `land-use change emissions`) %>%
    pivot_longer(-year, names_to = "variable") %>%
    na.omit %>%
    mutate(GCP = yr) %>%
    mutate(year = as.integer(year), value = as.numeric(value)) ->
    data_2024


# 7. Combine ----------------------------------------------------------------------
to_plot <- rbind(data_2007, data_2010, data_2015, data_2020, data_2023, data_2024)
to_plot %>%
    ggplot(aes(year, value, color = GCP)) +
    geom_line()

write.csv(to_plot, "selected_GCP.csv", row.names = FALSE)
