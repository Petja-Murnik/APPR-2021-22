library(shiny)


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
    aes(x = mesec_c, y = temperature,group = 1) + geom_line()+
    scale_x_continuous("Mesec",breaks = 1:12)+
    labs(
      x = "Mesec",
      y = "Povprečna dnevna temperatura[°C]",
      title = naselje1
    )
  print(grafek)
  }
  else{
    print("OJIO")
  }
}


inputPanel(
  sliderInput(
    "leto1",
    label = "Leto:",
    min = 2001, max = 2014, step = 1,
    value = 2010
  ),
  selectInput(
    "vrsta",
    label = "Opazovani pojav:",
    choices = c("padavine", "temperatura"),
    selected = "padavine"
  ),
  selectInput(
    "naselje1",
    label = "Opazovano naselje:",
    choices = data$naselje,
    selected = "Bilje"
)

renderPrint({
  list(input$naselje1, input$vrsta, input$leto1 )
})
