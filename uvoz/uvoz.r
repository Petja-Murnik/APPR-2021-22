# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(rvest)
library(tidyverse)
library(readxl)

sl <- locale("sl", decimal_mark=".", grouping_mark=",")


#Prevajalna tabela za mesece
prevod_meseci = tibble(mesec = c("Januar","Februar","Marec","April","Maj","Junij",
                                 "Julij","Avgust","September","Oktober","November","December"),
                       mesec_c = c(1,2,3,4,5,6,7,8,9,10,11,12))

####PODATKI O GEO. SIRINI IN GEO VISINI MOJIH NASELIJ ZA RISANJE NA ZEMLJEVID
#geo sirina in visina

prevod_lokacije = read_excel("podatki/lokacije.xlsx", sheet=1,
                                         col_names = TRUE)

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

vzorec_preb = "(\\d{0,8}\\s*)([a-zčšžA-ZČŠŽ.-/ ]*)$"
gostota_prebivalci$naselje = str_replace_all(gostota_prebivalci$naselje,vzorec_preb,"\\2")
vzorec_preb_2 = "([a-zA-ZčšžČŠŽ ]+)(\\/*)([a-zA-ZčšžČŠŽ ]*)"
gostota_prebivalci$naselje = str_replace_all(gostota_prebivalci$naselje,vzorec_preb_2,"\\1")


######NADMORSKE

nadmorske = read_excel("podatki/nadmorske_visine.xlsx", sheet=1,
                       col_names = FALSE)
colnames(nadmorske) = c("naselje", "nmv")

nadmorske$naselje = nadmorske$naselje %>%
  str_replace_all(.,"([a-zA-ZčšžČŠŽ0-9 ]+)(\\,)([a-zA-ZčšžČŠŽ ]*)","\\1") %>%
  str_replace_all(., "(\\s{0,1}\\d{1,2}\\s{1})([a-zA-ZčšžČŠŽ ]*)","\\2") %>%
  str_replace_all(., "([a-zA-ZčšžČŠŽ ]+[a-zčšž]{1})(\\s*)","\\1")
  
####TABELA 1 
tabela1 = left_join(temperature, padavine,by = c("naselje","leto","mesec")) %>%
  left_join(nadmorske,by="naselje")
tabela1$datum = paste(tabela1$leto ,tabela1$mesec,sep="-")
tabela1 = left_join(tabela1,prevod_meseci,by="mesec")
tabela1$datum_c = paste(tabela1$leto,tabela1$mesec_c,sep="-")
tabela1$datum_c = paste(tabela1$datum_c,"01",sep = "-")
tabela1$datum_c = format(as.Date(tabela1$datum_c),"%Y-%m-%d")
tabela1 = tabela1%>%
  group_by(naselje) %>%
  mutate(datum_c=as.Date(datum_c, format = "%Y-%m-%d"))
tabela1 = tabela1[,c(1,2,4,5,6,8,9)]
####TABELA2
tabela2 = left_join(nadmorske, gostota_prebivalci, by="naselje")

####TABELA3
#Zdi se mi, da bo tu treba malo več dela če želim, da je tabela taka kot si jo zelim,
#zato bom naredil vec podpornih tabelc 

t3_temp = temperature %>% group_by(naselje,leto) %>% summarise(avg_t = sum(temperature)/12)
t3_pad = padavine %>% group_by(naselje,leto) %>% summarise(avg_p = sum(padavine)/12)
t3_preb = gostota_prebivalci %>% group_by(naselje) %>% summarise(avg_preb = sum(gostota))

tabela3 = left_join(t3_temp,t3_pad ,by=c("naselje","leto")) %>% left_join(t3_preb, by= "naselje")
tabela3$avg_preb[tabela3$naselje=="Kredarica"] = 0

tabela3 = left_join(tabela3,nadmorske,by ="naselje")  
tabela3 = left_join(tabela3,prevod_lokacije,by="naselje")


