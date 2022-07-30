
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
stroke_data %>% filter(gender=="Male")

a=c("")
b="gender=='Female'"
data_table1 <- if(a==""){
        data = stroke_data %>% filter(eval(parse(text = b)))
    } else {
        if(b==""){
            data = stroke_data[, a]
        } else {
            data = stroke_data %>% filter_(b) %>% `[`(a)  
        }
    }
stroke_data %>% filter(eval(rlang::parse_expr(b)))
