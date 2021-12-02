# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(rvest)
library(tidyverse)
library(readxl)

sl <- locale("sl", decimal_mark=".", grouping_mark=",")


##PADAVINE

padavine <- read_csv("podatki/mesecne_padavine_2.csv", na="...",
              locale=locale(encoding="Windows-1250"),col_names =TRUE)

padavine = pivot_longer(padavine,
                          cols = colnames(padavine)[-1],
                          names_to = "datum",
                          values_to = "padavine"
                          )

padavine = separate(padavine,
                    col = "datum",
                    into = c("leto", "mesec"),
                    sep = " "
                    )

padavine = rename(padavine, "naselje"="METEOROLOŠKA POSTAJA")

#želim še nekako zrihtat imena
vzorec = "([a-zA-Zčšž ]+)(\\,)([a-zA-Zčšž ]*)$"
p = str_replace_all(padavine$naselje, vzorec, "\\1")
padavine$naselje = p

##TEMPERATUE

temperature <- read_csv("podatki/temperature.csv", na="...",
                     locale=locale(encoding="Windows-1250"),col_names =TRUE)

temperature = pivot_longer(temperature,
                           cols = colnames(temperature)[c(-1,-2)],
                           names_to = "mesec",
                           values_to = "temperature"
                           )

temperature = rename(temperature, "naselje" = "METEOROLOŠKA POSTAJA" , "leto" = "OBDOBJE, LETO" )

temperature$naselje = p
  
######

gostota_prebivalci = read_csv("podatki/gostota_prebivalcev.csv", na="...",
                              locale=locale(encoding="Windows-1250"),
                              )
                            
gostota_prebivalci[2] = as.double(unlist(gostota_prebivalci[2]))
gostota_prebivalci[3] = as.double(unlist(gostota_prebivalci[3]))
gostota_prebivalci[4] = as.double(unlist(gostota_prebivalci[4]))
gostota_prebivalci[5] = as.double(unlist(gostota_prebivalci[5]))
                                   
vzorec_stolpci = "(\\d{4})( [a-zA-ZčšžČŠŽ ]*)$"
colnames(gostota_prebivalci)[-1] = str_replace_all(colnames(gostota_prebivalci)[-1], vzorec_stolpci,"\\1")
gostota_prebivalci = rename(gostota_prebivalci, "naselje"="OBČINA/NASELJE")

gostota_prebivalci <- pivot_longer(gostota_prebivalci,
                                  cols = colnames(gostota_prebivalci)[-1],
                                  names_to = "datum",
                                  values_to = "gostota"
                                  )


vzorec_stolpci = "(\\d{4})( [a-zA-ZčšžČŠŽ ]*)$"

vzorec_preb = "(\\d{0,8} )([a-zčšžA-ZČŠŽ ]*)$"
#q = str_replace_all(...,vzorec_preb,"\\2")
#gostota_prebivalci

#######

 nadmorske = read_excel("podatki/nadmorske_visine.xlsx", sheet=1,
                       col_names = FALSE)

# colnames(nadmorske) = c("naselje","nmv")
