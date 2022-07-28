# App-for-healthcare

## App Overview

This is an interactive Machine Learning dashboard using R Shiny. The data contains 5110 observations with 12 attributes like gender, age, various diseases, and smoking status from [Kaggle](https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset). 

The dashboard will have 4 pages. The first "About" page describes the data, its source and the purpose, components of the app. The second "Data Exploration" page shows numerical and graphical summaries on the data. Users are allowed to choose predictors, type of plot and summary reported. The third "Modeling" page contains three tabs. "Modeling Info' tab describes Logistic Regression, Classification Tree and Random Forest approaches, the benefits and drawbacks of them. "Model Fitting" tab allows users to choose proportion to split the data into train data and test data set, build three models based on chosen predictors and check up their performance on the test data set. "Prediction" tab helps users to use one of the models for prediction. The forth "Data" page helps users to look at the data with specific predictors and conditions. It also provides option to save selected data as a file. 

Through this app users can explore the data features and predict whether a patient is likely to get stroke based on the input parameters. 

## Required packages

* shiny -- creating interactive app

* readr -- reading in data

* dplyr -- manipulating data

* summarytools -- generating numerical summary

* DT -- create interactive table

* caret -- building models

* Please use following code to install required packages:

`install.packages(c("shiny", "readr", "dplyr", "summarytools", "DT", "caret"))`

## Run code

Please run following code in the R console to launch the app:

`shiny::runGitHub("App-for-healthcare", "Fang2403")`
