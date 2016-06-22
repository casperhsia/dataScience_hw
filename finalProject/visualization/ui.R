library(shiny)
library(scatterD3)
library(ggplot2)
# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  
  headerPanel("DataScience Final"),
  
  sidebarPanel(
    sliderInput("folds", "n-fold Cross Validation:",
                        min = 2, max = 10, value = 1),
    radioButtons("feature", "Compare feature selection:",
                       choices = c("All", "Selected", "Random"))
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("ggPlot2", plotOutput("ggPlot", width="600px")), 
      tabPanel("Table", tableOutput("view"))
    )
  )
))
