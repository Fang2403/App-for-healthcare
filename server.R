
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
stroke_data$gender <- as.factor(stroke_data$gender)
stroke_data$ever_married <- as.factor(stroke_data$ever_married)
stroke_data$work_type <- as.factor(stroke_data$work_type)
stroke_data$Residence_type <- as.factor(stroke_data$Residence_type)
stroke_data$smoking_status <- as.factor(stroke_data$smoking_status)
stroke_data$bmi <- as.factor(stroke_data$bmi)

shinyServer(function(input, output) {

    #EDA descriptive
    #descriptive
    output$descr <- renderPrint(
        descr(stroke_data[ ,input$num_var])
    )
   #one-way
    output$one_way <- renderDataTable(
        freq(stroke_data[ ,input$fact_var])  
    )
    
    #two-way
    output$frequency <- renderDataTable(
       table(stroke_data[[input$fact_var1]],stroke_data[[input$fact_var2]]) 
    )

    
    # graphic panel
    
    output$plot <- renderPlot({
        if(input$plotoption == "Histogram"){
            if(!is.na(input$plotNumVar2)){
                ggplot(stroke_data, aes(x=!!sym(input$plotNumVar))) + 
                    geom_histogram(aes(fill=!!sym(input$plotNumVar2)), position="dodge")
            } else {
                ggplot(stroke_data, aes(x=!!sym(input$plotNumVar))) + 
                    geom_histogram()
            }
             
        } else if(input$plotoption == "BarPlot"){
            ggplot(stroke_data, aes(x=!!sym(input$plotFactVar))) + 
            geom_bar()
        } else if(input$plotoption == "Scatter"){
            if(!is.na(input$plotVar3)){
                ggplot(stroke_data, aes(x=!!sym(input$plotVar1), y=!!sym(input$plotVar2))) + 
                    geom_point(aes(color=!!sym(input$plotVar3)))
            } else {
                ggplot(stroke_data, aes(x=!!sym(input$plotVar1), y=!!sym(input$plotVar2))) + 
                    geom_point()
            }
        } else if(input$plotoption == "BoxPlot"){
              if(!is.na(input$plotNumVar3)){
                  ggplot(stroke_data, aes(x=!!sym(input$plotNumVar3), y=!!sym(input$plotNumVar4))) +
                             geom_boxplot()
              } else {
                  ggplot(stroke_data, aes(x=!!sym(input$plotNumVar3))) +
                      geom_boxplot()
              }
        } 
    })
    
    # machine learning
    #logidtic regression
    
    split <- eventReactive(input$logrprop, {
        set.seed(10)
        Train_index = createDataPartition(stroke_data$stroke,
                                          p=input$logrprop, list=FALSE)
        train_data = stroke_data[Train_index, ]
        test_data = stroke_data[-Train_index, ]
        results=list(train=train_data, test=test_data)
    })

     lrmodel <- eventReactive(input$fitmodel, {
        lr_fit = train(as.formula(paste("stroke ~", paste(input$logrvar, collapse= "+"))),  
                       data=split()$train, method="glm", family="binomial", 
                       trControl=trainControl(method="cv", input$k))
    })
     
     output$logroutput <- renderPrint({
         print(lrmodel())
     })
     #tree
     treemodel <- eventReactive(input$fitmodel,{
         tree_fit = train(as.formula(paste("stroke ~", paste(input$logrvar, collapse= "+"))),  
                        data=split()$train, method="rpart",
                        trControl=trainControl(method="cv", input$k))
     })   
     output$treeoutput <- renderPrint({
         print(treemodel())
     })
     #random forest
     randomForestmodel <- eventReactive(input$fitmodel,{
         randomForest_fit = train(as.formula(paste("stroke ~", paste(input$logrvar, collapse= "+"))),  
                          data=split()$train, method="rf", ntree=10,
                          trControl=trainControl(method="cv", input$k),
                          tuneGrid=data.frame(mtry=2:length(input$logrvar)))
     })   
     output$randomForestOutput <- renderPrint({
         print(randomForestmodel()$results)
     }) 
     output$varImportanceOutput <- renderPrint({
         print(varImp(randomForestmodel()))
     })
     output$importance <- renderPlot({
         plot(varImp(randomForestmodel()), top=5, title="Random Forest Variable Importance")
     }) 
     
     #comparing
     output$confus1 <- renderPrint({confusionMatrix(predict(lrmodel(), split()$test), 
                                                    split()$test$stroke)$table})
     output$accuracy1 <- renderPrint({confusionMatrix(predict(lrmodel(), split()$test), 
                                                    split()$test$stroke)$overall})
     output$confus2 <- renderPrint({confusionMatrix(predict(treemodel(), split()$test), 
                                                    split()$test$stroke)$table})
     output$accuracy2 <- renderPrint({confusionMatrix(predict(treemodel(), split()$test), 
                                                    split()$test$stroke)$overall})
     output$confus3 <- renderPrint({confusionMatrix(predict(randomForestmodel(), split()$test), 
                                                    split()$test$stroke)$table})
     output$accuracy3 <- renderPrint({confusionMatrix(predict(randomForestmodel(), split()$test), 
                                                    split()$test$stroke)$overall})
    # prediction
     
     output$prediction <- renderPrint({
         if (input$preModel=="Logistic Regression"){
             pred <- predict(lrmodel(), stroke_data)
             return(confusionMatrix(pred, stroke_data$stroke)$table)
         } else if(input$preModel=="Classification Tree"){
             pred <- predict(treemodel(), stroke_data)
             confusionMatrix(pred, stroke_data$stroke)$table
         } else {
             pred <- predict(randomForestmodel(), stroke_data)
             confusionMatrix(pred, stroke_data$stroke)$table
         }
     })
     
     output$accur <- renderPrint({
         if (input$preModel=="Logistic Regression"){
             pred <- predict(lrmodel(), stroke_data)
             return(confusionMatrix(pred, stroke_data$stroke)$overall)
         } else if(input$preModel=="Classification Tree"){
             pred <- predict(treemodel(), stroke_data)
             confusionMatrix(pred, stroke_data$stroke)$overall
         } else {
             pred <- predict(randomForestmodel(), stroke_data)
             confusionMatrix(pred, stroke_data$stroke)$overall
         }
     })
    # data panel
     
     selected <- reactive({
         selected <- stroke_data[, input$cols]
     })
     filted <- eventReactive(input$submit1,{
         filted <- stroke_data %>% filter_(input$rows)
     })
     both <- eventReactive(input$submit2,{
             filted <- selected() %>% filter_(input$both)
     })

    output$table1 <- renderDataTable({
        if (input$showdata=="Full"){
            stroke_data
        } else if (input$showdata=="Columns"){
            selected()
        } else if (input$showdata=="Rows"){
              filted()
        } else {
            both
        }
    })
    
    output$downloaddata <- downloadHandler(
        filename <- function(){
            paste("data-", Sys.Date(), ".csv", sep = "")
        },
        content <- function(file){
            if(input$showdata=="Full"){
                write.csv(stroke_data, file, row.names = TRUE)
            } else if (input$showdata=="Columns") {
                write.csv(selected(), file, row.names = TRUE)
            } else {
                write.csv(filted(), file, row.names = TRUE)
            }
        }
    )
    
})
