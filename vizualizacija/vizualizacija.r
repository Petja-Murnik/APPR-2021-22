# 3. faza: Vizualizacija podatkov

#OPOMBA: Kjer je #======== je graf tudi v poročilu

#dež za vse
g1 = ggplot(tabela1%>%filter(leto == "2010")) + aes(x = mesec_c, y = padavine) +
  geom_col(position = "dodge",fill = "dark blue") + 
  facet_wrap(. ~ naselje, ncol = 3)   + theme_classic() +
  labs(
    x = "Mesec",
    y = "Mesečne padavine[mm/m^2]",
    title = "Merjenja 20-ih meteoroloških postaj v letu 2001"
  )+
  scale_x_continuous("Mesec",breaks = 1:12)

##temperature za vse
g2 = ggplot(tabela1%>%filter(leto == "2001")) + aes(x = mesec_c, y = temperature,group = 1 ) + geom_line(position = "dodge") + 
  facet_wrap(. ~ naselje, ncol = 3)+ theme_classic() +
  labs(
    x = "Mesec",
    y = "Povprečna dnevna temperatura[°C]",
    title = "Merjenja 20-ih meteoroloških postaj v letu 2001"
  )

#Kako grejo čez leta padavine LETNO , Ali naj uporabim ????
g3 =ggplot(tabela3%>%group_by(naselje)) + aes(x = leto, y = avg_p) + geom_line() + 
  facet_wrap(. ~ naselje, ncol = 3) + theme_classic() 

#identično za čez čas temperature LETNO
g4 = ggplot(tabela3%>%group_by(naselje)) + aes(x = leto, y = avg_t) + geom_line(color="red") + 
  facet_wrap(. ~ naselje, ncol = 3) + theme_classic() 

#razsevni, kako so temperature letne glede na nmv
#OP.: Identičen je pri analizi narisan
g7 = ggplot(tabela3) + aes(x=nmv , y = avg_t)+ 
  geom_point() + stat_smooth(method = lm) 


#razsevni, kako so padavine letne glede na nmv
#OP.: Identičen je pri analizi narisan
g8 = ggplot(tabela3) + aes(x=nmv , y = avg_p)+ 
  geom_point() + stat_smooth(method = lm) 

#====gostota poseljenosti od nmv ====
g9 = ggplot(tabela3) + aes(x=nmv , y = avg_preb,color=naselje)+ 
  geom_point(size = 2.5) + 
  labs(
    x = "Nadmorska višina[m]",
    y = "Gostota poseljenosti [prebivalci/km^2]",
    title = "Gostota poseljenosti",
    color = ""
  ) + theme(legend.position = "none")
#==========================================

#Kako je gostota poseljenosti od temperatur, je tudi pri analizi
g10 = ggplot(tabela3[tabela3$naselje != "Kredarica",]) + aes(x=avg_t , y = avg_preb)+ 
  geom_point() + stat_smooth(method = lm)


#Kako je gostota poseljenosti od padavin, je tudi pri analizi
g11 = ggplot(tabela3[tabela3$naselje != "Kredarica",]) + aes(x=avg_p , y = avg_preb)+ 
  geom_point() + stat_smooth(method = lm)

#===================================
SLO <- map_data("world") %>% filter(region=="Slovenia")
data = tabela3 %>%filter(leto=="2010")
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
#===============================================
data3 = data[-17,]
g14 = ggplot() +
  geom_polygon(data = SLO, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point( data=data3, aes(x=lon, y=lat, size=avg_t,color=nmv)) +
  scale_size_continuous(range=c(1,12)) +
  scale_color_viridis(trans="log",option = "C") +
  theme_void() + ylim(45,47) + coord_map()  +
  geom_text(
    data = data3,
    mapping = aes(x = lon , y = lat+0.12, label = naselje),
    size = 2.5
  ) +  
  labs(
    title = "Nadmorske višine ter povprečne dnevne \ntemperature meteoroloških postaj",
    colour = "Nadmorska višina[m]",
    size = "Povprečne dnvene \ntemperature[°C]"
  )
#===============================================

#Kako gre gostota prebivalstva čez leta, brezveze
g15 = ggplot(tabela2%>%group_by(naselje)) + aes(x=datum, y=gostota,group = 1)  +
  geom_line() + facet_wrap(.~ naselje, ncol = 3)

#spremembe tamperatur tekom let
gg =  ggplot() + layer(
    data = tabela3%>%group_by(naselje),
    mapping = aes(x = leto, y = avg_p),
    geom = "line",
    stat = "identity",
    position = "identity",
  ) +   facet_wrap(.~ naselje ,ncol = 3)

#temperatur za vse po vseh mesecih iz tabele 1 
g5 = ggplot(tabela1) + aes(x = datum_c , y = temperature, group = 1) +
  geom_line() +facet_wrap(. ~ naselje, ncol = 3) 

#dež za vse po vseh mesecih iz tbele 1
g6 = ggplot(tabela1) + aes(x = datum_c , y = padavine) +
  geom_line() + facet_wrap(. ~ naselje, ncol = 3) 

#========================== 
ylim.prim <- c(0, 100)  
ylim.sec <- c(0, 5)
b <- diff(ylim.prim)/diff(ylim.sec)
a <- ylim.prim[1] - b*ylim.sec[1]
#======================
G1 = ggplot(tabela1%>%filter(leto == "2010")%>%
              filter(naselje!= "Rogaška Slatina")%>%filter(naselje != "Slap pri Vipavi" ),
            aes(mesec_c, padavine)) + 
  geom_col(fill = "dark blue") +
  geom_line(aes(y = a + temperature*b), color = "red") +
  scale_y_continuous("Padavine v mesecu[mm/m^2]", sec.axis = sec_axis(~ (. - a)/b, name = "Temperature[°C]"))+
  scale_x_continuous("Mesec",breaks = 1:12) +
  ggtitle("Padavine in temperature za leto 2010") + facet_wrap(.~naselje , ncol = 4)+
  facet_wrap(. ~ naselje, ncol = 4)  + theme_bw()
#=====================





