# 3. faza: Vizualizacija podatkov

library(ggplot2)
library(dbplyr)
library(maps)
library(viridis)
#source("uvoz/uvoz.r", encoding="UTF-8")
##dež za vse
 
g1 = ggplot(tabela1%>%filter(leto == "2010")) + aes(x = mesec_c, y = padavine) +
  geom_col(position = "dodge",fill = "dark blue") + 
  facet_wrap(. ~ naselje, ncol = 3)   + theme_classic() +
  labs(
    x = "Mesec",
    y = "Mesečne padavine[mm/m^2]",
    title = "Merjenja 20-ih meteoroloških postaj v letu 2001"
  )+
  scale_x_continuous("Mesec",breaks = 1:12)
#print(g1)
#TODO meseci na k osi 

##temperature za vse
g2 = ggplot(tabela1%>%filter(leto == "2001")) + aes(x = mesec_c, y = temperature,group = 1 ) + geom_line(position = "dodge") + 
  facet_wrap(. ~ naselje, ncol = 3)+ theme_classic() +
  labs(
    x = "Mesec",
    y = "Povprečna dnevna temperatura[°C]",
    title = "Merjenja 20-ih meteoroloških postaj v letu 2001"
  )
#print(g2)

##iz tabele 3 bi rad narisu kako grejo čez čas avg 
g3 =ggplot(tabela3%>%group_by(naselje)) + aes(x = leto, y = avg_p) + geom_line() + 
  facet_wrap(. ~ naselje, ncol = 3) + theme_classic() 
#print(g3)

##identično za čez čas avg p
g4 = ggplot(tabela3%>%group_by(naselje)) + aes(x = leto, y = avg_t) + geom_line(color="red") + 
  facet_wrap(. ~ naselje, ncol = 3) + theme_classic() 
#print(g4)


##
g7 = ggplot(tabela3) + aes(x=nmv , y = avg_t)+ 
  geom_point() + stat_smooth(method = lm) 
#print(g7)


##

g8 = ggplot(tabela3) + aes(x=nmv , y = avg_p)+ 
  geom_point() + stat_smooth(method = lm) 
#print(g8)

##
g9 = ggplot(tabela3) + aes(x=nmv , y = avg_preb,color=naselje)+ 
  geom_point(size = 2.5) + 
  labs(
    x = "Nadmorska višina[m]",
    y = "Gostota poseljenosti [prebivalci/km^2]",
    title = "Gostota poseljenosti",
    color = "Naselje"
  ) 
#print(g9)

##
g10 = ggplot(tabela3[tabela3$naselje != "Kredarica",]) + aes(x=avg_t , y = avg_preb)+ 
  geom_point() + stat_smooth(method = lm)
#print(g10)

## 
g11 = ggplot(tabela3[tabela3$naselje != "Kredarica",]) + aes(x=avg_p , y = avg_preb)+ 
  geom_point() + stat_smooth(method = lm)
#print(g11)

##
#TODO risati na zemljavide

SLO <- map_data("world") %>% filter(region=="Slovenia")
data = tabela3 %>%filter(leto=="2010")
#data_12 = rbind(data , JSC)
#data_12 =data_12[data_12$naselje != "Slap pri Vipavi",]
#data_12 = data_12[data_12$naselje != "Brnik",]
#g12 = ggplot() +
#  geom_polygon(data = SLO, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
#  geom_point( data=(data_12), aes(x=lon, y=lat, size=avg_preb,color=nmv)) +
#  scale_size_continuous(range=c(1,12)) +
#  scale_colour_viridis(trans="log",option = "C") +
#  theme_void() + ylim(45,47) + coord_map()  +
#  geom_text(
#    data = data_12,
#    mapping = aes(x = lon , y = lat+0.07, label = naselje),
#    size = 2.5
#  ) + 
#  labs(
#    size = "Gostota poseljenosti",
#    color = "Nadmorska višina"
#  )
#print(g12)

##
data2 = data[-c(17,18),]
g13 = ggplot() +
  geom_polygon(data = SLO, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point( data=data2, aes(x=lon, y=lat, size=avg_p,color=nmv)) +
  scale_size_continuous(range=c(1,12)) +
  scale_color_viridis(trans="log",option = "C") +
  theme_void() + ylim(45,47) + coord_map()  +
  geom_text(
    data = data2,
    mapping = aes(x = lon , y = lat+0.07, label = naselje),
    size = 2.5
  ) + 
  labs(
    title = "Nadmorske višine ter povprečne \nmesečne padavine meteoroloških postaj",
    colour = "Nadmorska višina[m]",
    size = "Povprečne mesečne \npadavine[mm/m^2]"
  )
#print(g13)    

##
data3 = data[-17,]
g14 = ggplot() +
  geom_polygon(data = SLO, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point( data=data3, aes(x=lon, y=lat, size=avg_t,color=nmv)) +
  scale_size_continuous(range=c(1,12)) +
  scale_color_viridis(trans="log",option = "C") +
  theme_void() + ylim(45,47) + coord_map()  +
  geom_text(
    data = data3,
    mapping = aes(x = lon , y = lat+0.09, label = naselje),
    size = 2.5
  ) +  
  labs(
    title = "Nadmorske višine ter povprečne dnevne \ntemperature meteoroloških postaj",
    colour = "Nadmorska višina[m]",
    size = "Povprečne dnvene \ntemperature[°C]"
  )
#print
#print(g14)


##
g15 = ggplot(tabela2%>%group_by(naselje)) + aes(x=datum, y=gostota,group = 1)  +
  geom_line() + facet_wrap(.~ naselje, ncol = 3)
#print(g15)



gg =  ggplot()+ layer(
    data = tabela3%>%group_by(naselje),
    mapping = aes(x = leto, y = avg_t),
    geom = "line",
    stat = "identity",
    position = "identity"
  ) + layer(
    data = tabela3%>%group_by(naselje),
    mapping = aes(x = leto, y = avg_p),
    geom = "line",
    stat = "identity",
    position = "identity",
  ) +   facet_wrap(.~ naselje ,ncol = 3)


#========================== 
ylim.prim <- c(0, 100)  
ylim.sec <- c(0, 8)
b <- diff(ylim.prim)/diff(ylim.sec)
a <- ylim.prim[1] - b*ylim.sec[1]
#=======================
#To moram sedaj skupaj spopat kot vzgoraj 
#temperatur za vse po vseh mesecih iz tabele 1 
g5 = ggplot(tabela1) + aes(x = datum_c , y = temperature, group = 1) +
  geom_line() +facet_wrap(. ~ naselje, ncol = 3) 
#print(g5)

#dež za vse po vseh mesecih iz tbele 1
g6 = ggplot(tabela1) + aes(x = datum_c , y = padavine) +
  geom_line() + facet_wrap(. ~ naselje, ncol = 3) 
#print(g6)
#=================
G7 =  ggplot(tabela1%>%group_by(naselje), aes(datum_c, padavine)) +
  geom_col() +
  geom_line(aes(y = a + temperature*b), color = "red") +
  scale_y_continuous("Precipitation", sec.axis = sec_axis(~ (. - a)/b, name = "Temperature"))+
  scale_x_continuous("Month", breaks = 2001:2014) +
  ggtitle("Climatogram for Oslo (1961-1990)") + facet_wrap(.~naselje , ncol = 3)+
  facet_wrap(. ~ naselje, ncol = 3) 
#==================
#Poanta je bla da bi g5 in g6 narisal v enega vendar zgleda neuporabno
#Zato bom uporabil kar g5 in g6

#To idejo pa lahkko uporabim na grafih g2 in g1
G1 = ggplot(tabela1%>%filter(leto == "2010")%>%
              filter(naselje!= "Rogaška Slatina")%>%filter(naselje != "Slap pri Vipavi" ),
            aes(mesec_c, padavine)) + 
  geom_col(fill = "dark blue") +
  geom_line(aes(y = a + temperature*b), color = "red") +
  scale_y_continuous("Padavine v mesecu[mm/m^2]", sec.axis = sec_axis(~ (. - a)/b, name = "Temperature[°C]"))+
  scale_x_continuous("Mesec",breaks = 1:12) +
  ggtitle("Padavine in temperature za leto 2010") + facet_wrap(.~naselje , ncol = 3)+
  facet_wrap(. ~ naselje, ncol = 3) 
#print(G1)
#Ta zgleda bolj uporabn
#print(g5)
#Zaenkrat naj uporabim G1, g5,g6,g13,g14,g15, od g7 do g11 imam v analizi
#PLAN zaenkrat:
#G1,g5,g6
#dodam JESENICE na g13,g14,g15




