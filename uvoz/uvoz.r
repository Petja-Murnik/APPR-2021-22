# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(rvest)
library(tidyverse)
#library(ghit)
#ghit::install_github(c("ropensci/tabulizerjars","ropensci/tabulizer"))

sl <- locale("sl", decimal_mark=".", grouping_mark=",")

padavine <- read_csv("podatki/mesecne_padavine_2.csv", na="...",
              locale=locale(encoding="Windows-1250"),col_names =TRUE)

#padavine %>% rownames_to_column() %>%
#  pivot_longer(!rowname, names_to = "col1", values_to = "col2") %>%
#  pivot_wider(names_from = "rowname", values_from = "col2")

#padavine1 = pivot_longer(padavine,
#                        cols = colnames(padavine),
#                        names_to = "po",
#                        values_to = "P"
#                        )

#########

temperature <- read_csv("podatki/temperature.csv", na="...",
                     locale=locale(encoding="Windows-1250"),col_names =TRUE)


######


