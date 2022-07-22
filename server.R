
library(shiny)
library(readr)
library(dplyr)
library(summarytools)
library(DT)
library(caret)

stroke_data <- read_csv("data/healthcare-dataset-stroke-data.csv")
stroke_data$heart_disease <- as.factor(stroke_data$heart_disease)
stroke_data$hypertension <- as.factor(stroke_data$hypertension)
stroke_data$stroke <- as.factor(stroke_data$stroke)

shinyServer(function(input, output) {

    #EDA descriptive
    #descriptive
    output$descr <- renderPrint(
        descr(stroke_data[ ,input$num_var])
    )
   #one-wau
    output$one_way <- renderDataTable(
        freq(stroke_data[ ,input$fact_var])  
    )
    #two-way
    output$frequency <- renderDataTable(
       table(stroke_data[ ,c(input$fact_var1, input$fact_var2)])  
    )

    
    # graphic panel
    
    # machine learning
    #logidtic regression

     lrmodel <- reactiveValues(
        Train_index = createDataPartition(stroke_data$stroke,
                                            p=input$logrprop, list=FALSE),
        train_data = stroke_data[Train_index, ],
        test_data = stroke_data[-Train_index, ],

        lr_fit = train(as.formula(paste("stroke ~", paste(input$logrvar, collapse= "+"))),  
                        data=train_data, method="glm", family="binomial")
          )
        
        

    
    
    output$logroutput <- renderPrint(

        if(input$logroption == "Coef."){
            exp(coef(lrmodel$lr_fit["finalModel"]))
        } else if (input$logroption == "Fit"){
            lrmodel$lr_fit
        } else if (input$logroption == "Pred. Accuracy"){
            predout <- predict(lrmodel$lr_fit, newdata=lrmodel$test_data, type="raw")
            confmat <- confusionMatrix(predout, lrmodel$test_data[,"stroke"])
            out <- sum(diag(confmat))/sum(confmat)
            return(list(confmat, out))
        }
        
    )
    
    
    # data panel
    output$full_table <- renderDataTable(
        stroke_data 
    )
    
    output$data_table <- renderDataTable(
        stroke_data[,input$cols]
    )
    

})
