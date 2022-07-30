
library(shiny)
library(readr)
library(dplyr)
library(summarytools)
library(DT)
library(caret)
library(corrplot)

stroke_data <- read_csv("data/healthcare-dataset-stroke-data.csv")
stroke_data$heart_disease <- as.factor(stroke_data$heart_disease)
stroke_data$hypertension <- as.factor(stroke_data$hypertension)
stroke_data$stroke <- as.factor(stroke_data$stroke)
stroke_data$gender <- as.factor(stroke_data$gender)
stroke_data$ever_married <- as.factor(stroke_data$ever_married)
stroke_data$work_type <- as.factor(stroke_data$work_type)
stroke_data$Residence_type <- as.factor(stroke_data$Residence_type)
stroke_data$smoking_status <- as.factor(stroke_data$smoking_status)
stroke_data$bmi <- as.numeric(stroke_data$bmi)

shinyServer(function(input, output) {

    #EDA descriptive
    #descriptive
    
    data <- eventReactive(input$go1, {
        if(input$filter1=="Yes"){
            data = stroke_data %>% filter_(input$num_var_rows)
        } else {
            data = stroke_data
        }
    })
    
    output$descr <- renderPrint(
        descr(data()[ ,input$num_var])
    )
    
    output$cor <- renderPlot({
        if(input$cor==TRUE){
            corrplot(cor(na.omit(stroke_data)[, input$num_var]), type="upper", tl.pos="lt", cl.cex=0.8)
            corrplot(cor(na.omit(stroke_data)[, input$num_var]), type="lower", method="number", add=TRUE, 
                     diag=FALSE, tl.pos="n")
        }
        
    })
    
   #one-way
    data2 <- eventReactive(input$go2, {
        if(input$filter2=="Yes"){
            data = stroke_data %>% filter_(input$one_way_rows)
        } else {
            data = stroke_data
        }
    })
    output$one_way <- renderTable({
        freq(data2()[ ,input$fact_var])
    })
    
    #two-way
    data3 <- eventReactive(input$go3, {
        if(input$filter3=="Yes"){
            data = stroke_data %>% filter_(input$two_way_rows)
        } else {
            data = stroke_data
        }
    })
    output$frequency <- renderTable(
       table(data3()[,c(input$fact_var1,input$fact_var2)]) 
    )

    
    # graphic panel
    data4 <- eventReactive(input$hist, {
        if(input$fil1=="Yes"){
            data = stroke_data %>% filter_(input$plotNumVar3)
        } else {
            data = stroke_data
        }
    })
    
    histogram <- eventReactive(input$hist,{
        if(input$group=="No"){
            ggplot(data4(), aes(x=!!sym(input$plotNumVar))) + 
                geom_histogram()
        } else {
            ggplot(data4(), aes(x=!!sym(input$plotNumVar))) + 
                geom_histogram(aes(fill=!!sym(input$plotNumVar2)), position="dodge")
        }
    })
    
    data5 <- eventReactive(input$bar, {
        if(input$fil2=="Yes"){
            data = stroke_data %>% filter_(input$plotFactVar2)
        } else {
            data = stroke_data
        }
    })
    
    barplot <- eventReactive(input$bar,{
        ggplot(data5(), aes(x=!!sym(input$plotFactVar))) + 
            geom_bar()
    })
    
    data6 <- eventReactive(input$scatter, {
        if(input$fil3=="Yes"){
            data = stroke_data %>% filter_(input$plotVar4)
        } else {
            data = stroke_data
        }
    })
    
    scatterplot <- eventReactive(input$scatter,{
        if(input$group2=="Yes"){
            ggplot(data6(), aes(x=!!sym(input$plotVar1), y=!!sym(input$plotVar2))) + 
                geom_point(aes(color=!!sym(input$plotVar3)))
        } else {
            ggplot(data6(), aes(x=!!sym(input$plotVar1), y=!!sym(input$plotVar2))) + 
                geom_point()
        }
    })
    
    data7 <- eventReactive(input$box, {
        if(input$fil4=="Yes"){
            data = stroke_data %>% filter_(input$plotbox3)
        } else {
            data = stroke_data
        }
    })
    
    boxplot <- eventReactive(input$box,{
        if(input$group3=="Yes"){
            ggplot(data7(), aes(x=!!sym(input$plotbox2), y=!!sym(input$plotbox))) +
                geom_boxplot()
        } else {
            ggplot(stroke_data, aes(y=!!sym(input$plotbox))) +
                geom_boxplot()
        }
    })
    
    output$plot <- renderPlot({
        if(input$plotoption == "Histogram"){
            histogram()
             
        } else if(input$plotoption == "BarPlot"){
            barplot()
        } else if(input$plotoption == "Scatter"){
            scatterplot()
        } else if(input$plotoption == "BoxPlot"){
            boxplot()
        } 
    })
    # model info
    
    output$log <- renderUI({
        withMathJax(helpText(
            "$$log(\\frac{P(stoke)}{1-P(stroke)})=\\beta_0+\\beta*X$$"
        ))
    })
    
    output$gini <- renderUI({
        withMathJax(helpText(
            "$$Gini: sp*(1-p)$$"
        ))
    })
    
    output$entro <- renderUI({
        withMathJax(helpText(
            "$$Deviance: -2p*log(p)-2*(1-p)log(1-p)$$"
        ))
    })

    # machine learning
    #logistic regression
    
    split <- eventReactive(input$logrprop, {
        set.seed(10)
        Train_index = createDataPartition(stroke_data$stroke,
                                          p=input$logrprop, list=FALSE)
        train_data = stroke_data[Train_index, ]
        test_data = stroke_data[-Train_index, ]
        results=list(train=train_data, test=test_data)
    })

     lrmodel <- eventReactive(input$fitmodel, {
         # Create a Progress object
         progress <- shiny::Progress$new()
         # Make sure it closes when we exit this reactive, even if there's an error
         on.exit(progress$close())
         
         progress$set(message = "Making logistic model", value = 10)
        lr_fit = train(as.formula(paste("stroke ~", paste(input$logrvar, collapse= "+"))),  
                       data=split()$train, method="glm", family="binomial", 
                       trControl=trainControl(method="cv", input$k))
    })
     
     output$logroutput <- renderPrint({
         print(lrmodel())
     })
     #tree
     treemodel <- eventReactive(input$fitmodel,{
         # Create a Progress object
         progress <- shiny::Progress$new()
         # Make sure it closes when we exit this reactive, even if there's an error
         on.exit(progress$close())
         
         progress$set(message = "Making tree model", value = 10)
         tree_fit = train(as.formula(paste("stroke ~", paste(input$logrvar, collapse= "+"))),  
                        data=split()$train, method="rpart",
                        trControl=trainControl(method="cv", input$k))
     })   
     output$treeoutput <- renderPrint({
         print(treemodel())
     })
     #random forest
     randomForestmodel <- eventReactive(input$fitmodel,{
         # Create a Progress object
         progress <- shiny::Progress$new()
         # Make sure it closes when we exit this reactive, even if there's an error
         on.exit(progress$close())
         
         progress$set(message = "Making random forest model", value = 10)
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
     
     new_data <- eventReactive(input$go, {
         data.frame(gender=input$gender, age=input$age, hypertension=input$hyper, heart_disease=input$disease, ever_married=input$marry, work_type=input$work, Residence_type=input$residence, avg_glucose_level=input$avg, bmi=input$bmi, smoking_status=input$smoke)
     })
     

     output$prediction <- renderPrint({
         # Create a Progress object
         progress <- shiny::Progress$new()
         # Make sure it closes when we exit this reactive, even if there's an error
         on.exit(progress$close())
         
         progress$set(message = "Predicting", value = 20)
         if (input$preModel=="Logistic Regression"){
             pred <- predict(lrmodel(), new_data())
             return(pred)
         } else if(input$preModel=="Classification Tree"){
             pred <- predict(treemodel(), new_data())
             return(pred)
         } else {
             pred <- predict(randomForestmodel(), new_data())
             return(pred)
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
    
    output$downloadData <- downloadHandler(
        filename <- function(){
            paste0(input$showdata, ".csv")
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