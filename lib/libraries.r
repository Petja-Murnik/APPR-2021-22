library(knitr)
library(rvest)
library(gsubfn)
library(tidyr)
library(tmap)
library(shiny)
library(readr)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(dbplyr)
library(maps)
library(viridis)
library(stringr)
library(readxl)
library(rmarkdown)
library(plotly)
  
options(gsubfn.engine="R")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")

