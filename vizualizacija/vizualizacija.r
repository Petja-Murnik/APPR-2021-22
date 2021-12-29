# 3. faza: Vizualizacija podatkov
#Plan imam narisat naprej kako za vsako naselje to grejo padavine in temperature(TIME; FASETING)
#potem iz nmv pogledat padavine
#iz nmv na temp
#iz nmv na gost 
#iz temp, pad na gost



library(ggplot2)
library(dbplyr)

##dež za vse
tabela1$datum = paste(tabela1$leto ,tabela1$mesec,sep="-") 
g1 = ggplot(tabela1%>%filter(leto == "2001")) + aes(x = mesec, y = padavine ) + geom_col(position = "dodge") + 
  facet_wrap(. ~ naselje, ncol = 3)
print(g1)


##temperature za vse
g2 = ggplot(tabela1%>%filter(leto == "2001")) + aes(x = mesec, y = temperature ) + geom_col(position = "dodge") + 
  facet_wrap(. ~ naselje, ncol = 3)
print(g2)


##iz tabele 3 bi rad narisu kako grejo čez čas avg 
g3 =ggplot(tabela3%>%group_by(naselje)) + aes(x = leto, y = avg_t) + geom_line() + 
  facet_wrap(. ~ naselje, ncol = 3)
print(g3)

##identično za čez čas avg p
g4 = ggplot(tabela3%>%group_by(naselje)) + aes(x = leto, y = avg_p) + geom_line() + 
  facet_wrap(. ~ naselje, ncol = 3)
print(g4)



