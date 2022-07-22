library(shiny)
library(tidyverse)
library(summarytools)
library(DT)

data <- read_csv("data/healthcare-dataset-stroke-data.csv")
data$heart_disease <- as.factor(data$heart_disease)
data$hypertension <- as.factor(data$hypertension)
data$stroke <- as.factor(data$stroke)

var=c("age", "heart_disease")
lr_fit <- train(as.formula(paste("stroke ~", paste(var, collapse= "+"))),  
                data=data, method="glm", family="binomial")

paste("stroke ~", paste(var, collapse= "+"))
