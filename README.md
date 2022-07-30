# App-for-healthcare

## App Overview

I am going to create an interactive Machine Learning multiple-page Shiny application. R Shiny is a package from RStudio that makes it incredibly easy to build an interactive web application with R. R Shiny is awesome in the sense that it automatically update outputs when inputs change.

The data used here contains 5110 observations with 12 attributes like gender, age, various diseases, and smoking status from [Kaggle](https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset). Through this app users can explore the data features and predict whether a patient is likely to get stroke based on the input parameters.

The application will consist of an introduction page, a data exploration page, a modeling page and a data page. In introduction page, the source of data, the purpose and components of the app will be describe. In data exploration page, users can explore data through different type of numerical and graphical summaries. Users are allowed to choose variables, type of plot and summary reported. In modeling page, there are three tabs modeling info, model fitting and prediction. In modeling info tab, I will discuss Logistic Regression, Classification Tree and Random Forest approaches, the benefits and drawbacks of them. In model fitting tab, users have access to choose proportion to split the data into train data and test data set, choose predictors to build three different model via corss validation on train data set, and to check up their performance on the test data set. In prediction tab, users can use one of the three models for prediction on user input parameters. In data page, users have access to the full data or subset with specific variables and conditions. Users are also able to save selected data as a file. 

## Required packages

* shiny -- framework for building interactive web applications with R

* readr -- providing a fast and friendly way to parse many type of data

* dplyr -- dplyr is a grammar of data manipulation, providing a consistent set of verbs that solve the most common data manipulation challenges

* corrplot -- providing a visual exploratory tool on correlation matrix that supports automatic variable reordering to help detect hidden patterns among variables

* summarytools -- providing a coherent set of functions centered on data exploration and simple reporting

* DT -- providing an R interface to the JavaScript library DataTables. R data objects (matrices or data frames) can be displayed as tables on HTML pages, and DataTables provides filtering, pagination, sorting, and many other features in the tables.

* caret --a set of functions that attempt to streamline the process for creating predictive models

Please use following code to install required packages:

`install.packages(c("shiny", "readr", "dplyr", "summarytools", "DT", "caret", "corrplot"))`

## Launch the app

Please run following code in the R console to launch the app:

`shiny::runGitHub("App-for-healthcare", "Fang2403")`
