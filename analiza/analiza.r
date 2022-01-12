# 4. faza: Napredna analiza podatkov
library(tidyverse)
JSC = data.frame(naselje = c("Jesenice"),
                 nmv = c(500),
                 lat = c(46.43)
                 )

podatki = tabela3 
m_za_temp = avg_t ~ nmv + lat #1
m_za_padavine = avg_p ~ nmv + lat
m_za_preb = avg_preb ~ nmv + avg_t + avg_p

#1
g_A_1 <- ggplot(podatki, aes(x=lat, y=avg_t)) + geom_point()
print(g_A_1)
#iz grafa opazimo, da lat ne vpliva na temperature zato bomo model popravili 
m_za_temp = avg_t ~ nmv
ggplot(tabela3) + aes(x=nmv , y = avg_t)+ 
  geom_point() + stat_smooth(method = lm) 
#Iz grafa 7 opazimo zelo lepo povezavo med avg_t in nmv


lin.model1 = lm(avg_t ~ nmv, data = podatki)
print(lin.model1)

tem_JSC = lm.napovedi1 = predict(lin.model1 , newdata = JSC)
JSC$avg_t = tem_JSC



