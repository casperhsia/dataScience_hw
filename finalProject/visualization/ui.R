library(shiny)
library(scatterD3)
library(ggplot2)
# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  
  headerPanel("DataScience Final"),
  
  sidebarPanel(
    sliderInput("folds", "Controller:",
                        min = 2, max = 10, value = 1),
    radioButtons("feature", "Compare feature selection:",
                       choices = c("All", "Selected", "Random"))
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("ggPlot2", plotOutput("ggPlot", width="500px")), 
      tabPanel("Table", tableOutput("view"))
    )
  )
))
