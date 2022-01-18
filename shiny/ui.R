library(shiny)

shinyUI(fluidPage(
  titlePanel(""),

             sidebarPanel(
                sliderInput(
                 "leto1",
                label = "Leto:",
                 min = 2001, max = 2014, step = 1,
                round = FALSE, sep = "", ticks = FALSE,
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
  ))
,
    mainPanel(plotOutput("graf")),
    uiOutput("izborTabPanel")))









