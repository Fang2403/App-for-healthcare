library(shiny)
library(tidyverse)
library(summarytools)
library(DT)
library(caret)

data <- read_csv("data/healthcare-dataset-stroke-data.csv")
data$heart_disease <- as.factor(data$heart_disease)
data$hypertension <- as.factor(data$hypertension)
data$stroke <- as.factor(data$stroke)
data$bmi <- as.numeric(data$bmi)
mean(data$bmi, na.rm=TRUE)
cor(na.omit(data)[, c("age", "bmi")])

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

a <- data.frame(gender="Female", age=80, hypertension="1", heart_disease="1", ever_married="No", work_type="Private", Residence_type="Urban", avg_glucose_level=220, bmi=36, smoking_status="smokes")
predict(randomForest_fit, a)

append(c("1"),"2")
