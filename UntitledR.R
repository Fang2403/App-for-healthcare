library(shiny)
library(tidyverse)
library(summarytools)
library(DT)
library(caret)

data <- read_csv("data/healthcare-dataset-stroke-data.csv")
data$heart_disease <- as.factor(data$heart_disease)
data$hypertension <- as.factor(data$hypertension)
data$stroke <- as.factor(data$stroke)

var=c("age", "heart_disease", "gender")

set.seed(100)
Train_index = createDataPartition(data$stroke,
                                  p=0.8, list=FALSE)
train_data = data[Train_index, ]
test_data = data[-Train_index, ]
randomForest_fit = train(as.formula(paste("stroke ~", paste(var, collapse= "+"))),  
                         data=train_data, method="rf", ntree=8,
                         trControl=trainControl(method="cv", 5))
pred <- predict(randomForest_fit, test_data)
confusionMatrix(pred, test_data$stroke)
str(confusionMatrix(pred, test_data$stroke))
