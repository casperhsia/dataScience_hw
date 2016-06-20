library(shiny)
library(scatterD3)
library(ggplot2)
# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  
  headerPanel("DataScience"),
  
  sidebarPanel(
    radioButtons("positive", "Choose what is positive:",
                       choices = c("Male", "Female")),
    selectInput("dataset", "Choose a dataset:", 
                choices = c("set1", "set2", "set3", "set4", "set5"))
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("scatterD3", scatterD3Output("scatter", height = "450px")), 
      tabPanel("ggPlot2", plotOutput("ggPlot", width="500px")), 
      tabPanel("Table", tableOutput("view"))
    )
  )
))