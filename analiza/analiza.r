# 4. faza: Napredna analiza podatkov

JSC = data.frame(naselje = c("Jesenice"),
                 nmv = c(585),
                 lat = c(46.4327),
                 lon = c(14.0534)
                 )

podatki = tabela3 

#===========TEMPERATURE NAPOVEDUJE ZA JSC
g_A_1 <- ggplot(podatki, aes(x=lat, y=avg_t)) + geom_point() + stat_smooth(method = lm)
#print(g_A_1)

g_A_2 = ggplot(tabela3) + aes(x=nmv , y = avg_t)+ 
  geom_point() + stat_smooth(method = lm)  + 
  labs(
    x = "Nadmorska višina[m]",
    y = "Povprečje povprečnih mesečnih temperatur[°C]",
    title = "Analiza povezave nadmorske višine in temperature"
  ) 
#print(g_A_2)
#Iz grafa 7 opazimo zelo lepo povezavo med avg_t in nmv
m_za_temp = avg_t ~ nmv + lat 

lin.model1 = lm(m_za_temp, data = podatki)
#print(lin.model1)

tem_JSC = lm.napovedi1 = predict(lin.model1 , newdata = JSC)
JSC$avg_t = tem_JSC


#============= PADAVINE 
g_A_3 = ggplot(podatki, aes(x = lat,y=avg_p))+geom_point() + stat_smooth(method = lm)
#print(g_A_3)
#iz grafa opazimo nikakršne povezave 
g_A_4 = ggplot(podatki, aes(x = nmv,y=avg_p))+geom_point() + stat_smooth(method = lm)+ 
  labs(
    x = "Nadmorska višina[m]",
    y = "Povprečje povprečnih mesečnih padavin za leto[mm/m^2]",
    title = "Analiza povezave nadmorske višine in padavin"
  ) 
#print(g_A_4)

#Opazim da bi bilo tu mogoče bolje uporabiti kaj drugega in zanemariti Kredarico

podatki1 = podatki%>% filter(naselje != "Kredarica")


g_A_5 = ggplot(podatki1, aes(x = nmv,y=avg_p))+geom_point() +
  geom_smooth(method="lm", formula = y ~ x + I(x^2) + I(x^3))
#print(g_A_5)
g_A_6 = ggplot(podatki1, aes(x = nmv,y=avg_p))+geom_point() +
  geom_smooth(method="lm", formula = y ~ x + I(x^2)) + 
  labs(
    x = "Nadmorska višina[m]",
    y = "Povprečje povprečnih mesečnih padavin za leto[mm/m^2]",
    title = "Analiza povezave nadmorske višine in padavin"
  ) 
#print(g_A_6)
#Stvar iz g_A_6 se mi zdi lepša saj z nmv naj bi se dvigovale padavine 

m_za_padavine = avg_p ~nmv + I(nmv^2) + lat
lin.model2 = lm(m_za_padavine,data = podatki1)
lm.napovedi2 = predict(lin.model2,newdata = JSC)
#print(lm.napovedi2)
pad_JSC = lm.napovedi2
JSC$avg_p = pad_JSC


#===========PREBIVALSTVO
g_A_7= ggplot(podatki, aes(x=nmv,y=avg_preb))+geom_point() +
  geom_smooth(method="lm", formula = y ~ x )
#print(g_A_7)
#Opazim,da Kredarica ni najbl fajn
g_A_8 = ggplot(podatki1, aes(x=nmv,y=avg_preb))+geom_point() +
  geom_smooth(method="lm", formula = y ~ x )
#print(g_A_8)
g_A_9 = ggplot(podatki1, aes(x=nmv,y=avg_preb))+geom_point() +
  geom_smooth(method="lm", formula = y ~ x + I(x^2))
#print(g_A_9)
g_A_10 = ggplot(podatki1, aes(x=nmv,y=avg_preb))+geom_point() +
  geom_smooth(method="lm", formula = y ~ x + I(x^2)+I(x^3))
#print(g_A_10)
#nekak se zdi najbolj logično 8


g_A_11= ggplot(podatki1, aes(x=avg_p,y=avg_preb))+geom_point() +
  geom_smooth(method="lm", formula = y ~ x )
#print(g_A_11)

g_A_12 = ggplot(podatki1, aes(x=avg_p,y=avg_preb))+geom_point() +
  geom_smooth(method="lm", formula = y ~ x + I(x^2) )
#print(g_A_12)
#12 se zdi bols


g_A_13 = ggplot(podatki1, aes(x=avg_t,y=avg_preb))+geom_point() +
  geom_smooth(method="lm", formula = y ~ x )
#print(g_A_13)
g_A_14 = ggplot(podatki1, aes(x=avg_t,y=avg_preb))+geom_point() +
  geom_smooth(method="lm", formula = y ~ x + I(x^2))
#print(g_A_14)
#oboje vredu

m_za_preb = avg_preb ~ nmv + avg_t + avg_p
lin.model3 = lm(m_za_preb,data = podatki1)
lm.napovedi3 = predict(lin.model3,newdata = JSC)
#print(lm.napovedi3)
preb_JSC = lm.napovedi3
JSC$avg_preb = preb_JSC

#print(JSC) #napoved za Jesenice


JSC_zares = gostota_prebivalci%>%filter(naselje == "Jesenice") %>%.[20,]
#Opazim, da se napoved od resnice za gostot prebivalcev razlikuje kar močno 
#Mogoče se pa za temperature in padavine ne





SLO <- map_data("world") %>% filter(region=="Slovenia")
data = tabela3 %>%filter(leto=="2010")
data_12 = rbind(data , JSC)
data_12 =data_12[data_12$naselje != "Slap pri Vipavi",]
data_12 = data_12[data_12$naselje != "Brnik",]
data_12 = data_12 %>% filter(naselje != "Kredarica")
g12 = ggplot() +
  geom_polygon(data = SLO, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point( data=(data_12), aes(x=lon, y=lat, size=avg_preb,color=nmv)) +
  scale_size_continuous(range=c(1,12)) +
  scale_colour_viridis(trans="identity",option = "C") +
  theme_void() + ylim(45,47) + coord_map()  +
  geom_text(
    data = data_12 %>% filter(naselje != "Jesenice"),
    mapping = aes(x = lon , y = lat+0.07, label = naselje),
    size = 2.5
  ) + 
  geom_text(
    data = data_12 %>% filter(naselje == "Jesenice"),
    mapping = aes(x = lon , y = lat+0.07, label = naselje),
    size = 2.5 ,colour = "red"
  ) + 
  labs(
    size = "Gostota poseljenosti [prebivalci/km^2]",
    color = "Nadmorska višina[m]"
  )

