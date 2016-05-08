library(shiny)
library(ggplot2)
library(scatterD3)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
    datasetInput <- reactive({
      setChoose <- input$dataset
      setPostive <- input$positive
      read.csv(paste("https://raw.githubusercontent.com/casperhsia/dataScience_hw/master/hw03/inputData/", setPostive, "/", setChoose, ".csv", sep=""), header=TRUE)
    })
    
    output$view <- renderTable({
      datasetInput()
    })
    
    output$scatter <- renderScatterD3({
      csvData <- datasetInput()
      csvData <- csvData[-nrow(csvData),] #remove last row
      # create column of 1-specificity 
      csvData$oneMinusSpecificity <- as.numeric(as.character(csvData$specificity))
      
      tooltips <- paste(csvData$method, "<br/> F1:", csvData$F1, "<br/> AUC:", csvData$AUC, "<br/> sensitivity:", csvData$sensitivity, "<br/> specificity:", csvData$specificity, "<br/> siganificant:", csvData$siganificant)
      scatterD3(x=as.numeric(as.character(csvData$specificity)), y=csvData$sensitivity, fixed=TRUE, point_size = 100, lab=csvData$method, tooltip_text=tooltips)
      
      })
    
    output$ggPlot <- renderPlot({
      csvData <- datasetInput()
      csvData <- csvData[-nrow(csvData),] #remove last row
      # create column of 1-specificity 
      csvData$oneMinusSpecificity <- as.numeric(as.character(csvData$specificity))
      
      ggplot(csvData, aes(x=oneMinusSpecificity, y=sensitivity)) + geom_point(color="blue", size=8, alpha=0.3) + theme(text = element_text(size=20))
    })
    
    

})
