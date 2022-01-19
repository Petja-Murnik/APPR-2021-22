
shinyServer(function(input, output) {
  
  output$graf <- renderPlot({
    narisi_grafek(input$naselje1,input$vrsta, input$leto1)
  })
})



narisi_grafek = function(naselje1, vrsta, leto1){
  if (vrsta == "padavine"){
  grafek = ggplot(tabela1%>%filter(leto == leto1)%>% filter(naselje == naselje1))+
    aes(x = mesec_c, y = padavine) +
    geom_col(position = "dodge",fill = "dark blue") + 
    theme_classic() +
    labs(
      x = "Mesec",
      y = "Mesečne padavine[mm/m^2]",
      title = naselje1
    )+
    scale_x_continuous("Mesec",breaks = 1:12)
  print(grafek)
  }
  else if (vrsta == "temperatura"){
  grafek = ggplot(tabela1%>%filter(leto == leto1)%>% filter(naselje == naselje1))+
    aes(x = mesec_c, y = temperature,group = 1) + geom_line(color = "red",size = 1.2)+
    scale_x_continuous("Mesec",breaks = 1:12)+
    labs(
      x = "Mesec",
      y = "Povprečna dnevna temperatura[°C]",
      title = naselje1
    ) + theme_bw()
  print(grafek)
  }
  else{
    print("OJIO")
  }
}


