library(shiny)
library(scatterD3)
library(ggplot2)
# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  
  headerPanel("DataScience"),
  
  sidebarPanel(
    radioButtons("positive", "Choose what is positive:",
                       choices = c("male", "female")),
    selectInput("dataset", "Choose a dataset:", 
                choices = c("set1", "set2", "set3", "set4", "set5"))
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("scatterD3", scatterD3Output("scatter", height = "400px")), 
      tabPanel("ggPlot2", plotOutput("ggPlot")), 
      tabPanel("Table", tableOutput("view"))
    )
  )
))