# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(rvest)

sl <- locale("sl", decimal_mark=".", grouping_mark=",")

padavine <- read_csv("podatki/mesecne_padavine_2.csv", na="...",
              locale=locale(encoding="Windows-1250"),col_names =TRUE)
padavine1 = pivot_longer(padavine,
                        cols = padavine[1],
                        names_to = "po",
                        values_to = "P"
                        )
