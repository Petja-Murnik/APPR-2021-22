# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(rvest)
library(tidyverse)
library(readxl)

sl <- locale("sl", decimal_mark=".", grouping_mark=",")

padavine <- read_csv("podatki/mesecne_padavine_2.csv", na="...",
              locale=locale(encoding="Windows-1250"),col_names =TRUE)



#########

temperature <- read_csv("podatki/temperature.csv", na="...",
                     locale=locale(encoding="Windows-1250"),col_names =TRUE)


######

gostota_prebivalci = read_csv("podatki/gostota_prebivalcev.csv", na="...",
                              locale=locale(encoding="Windows-1250"))


#######

nadmorske = read_excel("podatki/nadmorske_visine.xlsx", sheet=1,
                       col_names = FALSE)

colnames(nadmorske) = c("naselje","nmv")
