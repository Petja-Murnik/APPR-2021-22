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


##



