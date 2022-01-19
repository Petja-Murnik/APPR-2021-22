# Analiza povezave nadmorske višine, vremenskih razmer in gostote poseljenosti v Sloveniji

Repozitorij za projekt pri predmetu APPR v študijskem letu 2021/22. 

## Tematika

Analiziral bom vpliv nadmorske višine na temperaturo in padavine v Sloveniji. Podatke sem vzel iz 20 meteoroloških postaj, katerih podatki so bili dostopni na http://meteo.arso.gov.si/met/sl/archive/ . Iz dobljenih vremenskih razmer in podatkih o prebivalstvu, ki sem jih dobil na https://www.stat.si/ , bom iskal korelacijo med vremenskimi razmerami, nadmorsko višino in gostoto poseljenosti.

## Zasnova
### Tabela 1
Stolpci bodo:
* `naselje`
* `nadmorska_visina`
* `leto`
* `mesec` 
* `temperatura` 
* `padavine`

### Tabela 2 
Stolpci bodo:
* `naselje`
* `nadmorska_visina`
* `gostota_prebivalstvo`

### Tabela 3
Stolpci bodo:
* `naselje`
* `nadmorska_visina`
* `avg_temperatura`
* `avg_padavine`
* `gostota_prebivalstvo`

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Potrebne knjižnice so v datoteki `lib/libraries.r`
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `tidyr` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `tmap` - za risanje na zemljevide
* `tidyverse` - za delo s podatki oblike *tidy data*
* `dbplyr` - za delo s podatki
* `maps` - za uvoz zamljevidov
* `viridis` - za barvne lestvice pri risanju grafov
* `stringr` - za delo z regularnimi izrazi
* `readxl` - za uvoz iz Excel-ove datoteke



