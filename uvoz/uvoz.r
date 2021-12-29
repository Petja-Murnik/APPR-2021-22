# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(rvest)
library(tidyverse)
library(readxl)

sl <- locale("sl", decimal_mark=".", grouping_mark=",")


#######PADAVINE

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
padavine$leto = as.double(padavine$leto)
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
  

######GOSTOTA PREBIVALCEV

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

vzorec_preb = "(\\d{0,8}\\s*)([a-zčšžA-ZČŠŽ ]*)$"
gostota_prebivalci$naselje = str_replace_all(gostota_prebivalci$naselje,vzorec_preb,"\\2")
##! kako naj naredim da bo regularni izraz mi spremenil 090007 Portorož/Portorose v Portorož 
#
#Oziroma zakaj zgornja vrstica če dam za vzorec_preb = "(\\d{0,8}\\s*)([a-zčšžA-ZČŠŽ ]+)(/*[a-zčšžA-ZČŠŽ ]*)$"
#

######NADMORSKE

nadmorske = read_excel("podatki/nadmorske_visine.xlsx", sheet=1,
                       col_names = FALSE)
colnames(nadmorske) = c("naselje", "nmv")

nadmorske$naselje = nadmorske$naselje %>%
  str_replace_all(.,"([a-zA-ZčšžČŠŽ0-9 ]+)(\\,)([a-zA-ZčšžČŠŽ ]*)","\\1") %>%
  str_replace_all(., "(\\s{0,1}\\d{1,2}\\s{1})([a-zA-ZčšžČŠŽ ]*)","\\2") %>%
  str_replace_all(., "([a-zA-ZčšžČŠŽ ]+[a-zčšž]{1})(\\s*)","\\1")
  

######SNEG
#
#Bilje in Brnik/letališče jožeta pučnika 2001 do 2010
#sn_1 = read_csv("podatki/sneg_nevihte_bilje_brnik",na="...",locale=locale(encoding="UTF-8"),col_names =TRUE)
 
####TABELA 1 
tabela1 = left_join(temperature, padavine,by = c("naselje","leto","mesec")) %>%
  left_join(nadmorske,by="naselje")

####TABELA2
tabela2 = left_join(nadmorske, gostota_prebivalci, by="naselje")

####TABELA3
#Zdi se mi, da bo tu treba malo več dela če želim, da je tabela taka kot si jo zelim,
#zato bom naredil vec podpornih tabelc 

t3_temp = temperature %>% group_by(naselje,leto) %>% summarise(avg_t = sum(temperature)/12)
t3_pad = padavine %>% group_by(naselje,leto) %>% summarise(avg_p = sum(padavine)/12)
t3_preb = gostota_prebivalci %>% group_by(naselje) %>% summarise(avg_preb = sum(gostota))

tabela3 = left_join(t3_temp,t3_pad ,by=c("naselje","leto")) %>% left_join(t3_preb, by= "naselje")

 

