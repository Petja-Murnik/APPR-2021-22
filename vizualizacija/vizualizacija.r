# 3. faza: Vizualizacija podatkov
#Plan imam narisat naprej kako za vsako naselje to grejo padavine in temperature(TIME; FASETING)

library(ggplot2)
library(dbplyr)
library(maps)
library(viridis)
library(plotly)
source("uvoz/uvoz.r", encoding="UTF-8")
##dež za vse
 
g1 = ggplot(tabela1%>%filter(leto == "2001")) + aes(x = mesec_c, y = padavine ) + geom_col(position = "dodge") + 
  facet_wrap(. ~ naselje, ncol = 3)
print(g1)
#poprav mesece da so povrst

##temperature za vse
g2 = ggplot(tabela1%>%filter(leto == "2001")) + aes(x = mesec_c, y = temperature,group = 1 ) + geom_line(position = "dodge") + 
  facet_wrap(. ~ naselje, ncol = 3)
print(g2)
#poprav mesece da so povrst

##iz tabele 3 bi rad narisu kako grejo čez čas avg 
g3 =ggplot(tabela3%>%group_by(naselje)) + aes(x = leto, y = avg_t) + geom_line() + 
  facet_wrap(. ~ naselje, ncol = 3)
print(g3)

##identično za čez čas avg p
g4 = ggplot(tabela3%>%group_by(naselje)) + aes(x = leto, y = avg_p) + geom_line() + 
  facet_wrap(. ~ naselje, ncol = 3)
print(g4)


#temperatur za vse po vseh mesecih iz tabele 1 
g5 = ggplot(tabela1) + aes(x = datum_c , y = temperature, group = 1) +
  geom_line() + facet_wrap(. ~ naselje, ncol = 3) 
print(g5)

#dež za vse po vseh mesecih iz tbele 1
g6 = ggplot(tabela1) + aes(x = datum_c , y = padavine) +
  geom_col() + facet_wrap(. ~ naselje, ncol = 3) 
print(g6)

##
g7 = ggplot(tabela3%>%filter(leto=="2010")) + aes(x=nmv , y = avg_t)+ 
  geom_point() + stat_smooth(method = lm) 
print(g7)


##

g8 = ggplot(tabela3%>%filter(leto=="2010")) + aes(x=nmv , y = avg_p)+ 
  geom_point() + stat_smooth(method = lm) 
print(g8)

##
g9 = ggplot(tabela3%>%filter(leto=="2010")) + aes(x=nmv , y = avg_preb)+ 
  geom_point() + stat_smooth(method = lm)
print(g9)

##
g10 = ggplot(tabela3[tabela3$naselje != "Kredarica",]%>%filter(leto=="2010")) + aes(x=avg_t , y = avg_preb)+ 
  geom_point() + stat_smooth(method = lm)
print(g10)

## 
g11 = ggplot(tabela3[tabela3$naselje != "Kredarica",]%>%filter(leto=="2010")) + aes(x=avg_p , y = avg_preb)+ 
  geom_point() + stat_smooth(method = lm)
print(g11)

##
#TODO risati na zemljavide

SLO <- map_data("world") %>% filter(region=="Slovenia")
data = tabela3%>%filter(leto=="2010")

g12 = ggplot() +
  geom_polygon(data = SLO, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point( data=data, aes(x=lon, y=lat, size=avg_preb,color=nmv)) +
  scale_size_continuous(range=c(1,12)) +
  scale_color_viridis(trans="log") +
  theme_void() + ylim(45,47) + coord_map() 
print(g12)
