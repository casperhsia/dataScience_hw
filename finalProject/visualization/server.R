library(shiny)
library(ggplot2)
library(scatterD3)
library(RCurl)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
    datasetInput <- reactive({
      foldsCount <- input$folds
      methodFeature <- input$feature
      read.csv(text=getURL(paste("https://raw.githubusercontent.com/casperhsia/dataScience_hw/master/finalProject/result/", methodFeature, "/",foldsCount, "folds", sep = "")), header=TRUE)
    })
    
    output$view <- renderTable({
      datasetInput()
    })
    
#    output$scatter <- renderScatterD3({
#      csvData <- datasetInput()
#      # csvData <- csvData[-nrow(csvData),] #remove last row
#      # create column of 1-specificity 
#      # csvData$oneMinusSpecificity <- as.numeric(as.character(csvData$specificity))
#      
#      tooltips <- paste(csvData$method, "<br/> ACC:", csvData$ACC, "<br/> F1:", csvData$F1, "<br/> Recall:", csvData$Recall, "<br/> precision:", csvData$precision)
#      scatterD3(x=csvData$Recall, y=csvData$Precision, fixed=TRUE, point_size = 100, lab=csvData$method, tooltip_text=tooltips)
#      
#      })
    
    output$ggPlot <- renderPlot({
      csvData <- datasetInput()
      # csvData <- csvData[-nrow(csvData),] #remove last row
      # create column of 1-specificity 
      # csvData$oneMinusSpecificity <- as.numeric(as.character(csvData$specificity))
      
      ggplot(csvData, aes(x=iterTimes, y=Value, fill=Type)) + geom_bar(stat="identity", position=position_dodge(), colour="black")
    })
    
    

})
