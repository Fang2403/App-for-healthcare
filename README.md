# Development of an Interactive Stroke Prediction Tool 

## Project Overview

### Introduction to the ML Shiny App

Welcome to my interactive Machine Learning application built using R Shiny, a powerful package from RStudio that facilitates the creation of interactive web applications using R. This application is designed to dynamically update its outputs based on user inputs, offering a seamless and responsive user experience.

### Data Description

The dataset employed in this application features 5,110 observations across 12 attributes, including gender, age, various health conditions, and smoking status, sourced from [Kaggle](https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset). This rich dataset provides the foundation for predicting stroke likelihood based on various input parameters.

### Application Structure

The application is structured into four main pages:

- Introduction Page: Here, you'll find detailed information about the data source, the purpose of the app, and its various components.

- Data Exploration Page: This page allows users to dive into the dataset through various numerical and graphical summaries. You can select different variables, choose the type of plot you wish to see, and generate specific summaries tailored to your interests.

- Modeling Page: Divided into three tabs:

  * Modeling Info: Discusses the methodologies used, such as Logistic Regression, Classification Trees, and Random Forests, including their advantages and limitations.

  * Model Fitting: Provides tools to select the train-test data split ratio, choose predictors, and build models through cross-validation on the training dataset. Performance metrics on the test dataset are also displayed here.

  * Prediction: Offers a user-friendly interface to make predictions using updated parameters with the chosen model.

- Data Page: Grants access to the full dataset and allows users to create subsets based on specific variables and conditions. You can also download selected data segments as a CSV file for offline analysis.

This application aims to make Machine Learning more accessible and interactive, providing users with both the tools and knowledge to explore and predict health outcomes effectively. Stay tuned for updates and new features!

## Required packages

* shiny -- framework for building interactive web applications with R

* readr -- providing a fast and friendly way to parse many type of data

* dplyr -- dplyr is a grammar of data manipulation, providing a consistent set of verbs that solve the most common data manipulation challenges

* corrplot -- providing a visual exploratory tool on correlation matrix that supports automatic variable reordering to help detect hidden patterns among variables

* summarytools -- providing a coherent set of functions centered on data exploration and simple reporting

* ggplot2 -- declaratively creating graphics, based on the grammar of graphics.

* DT -- providing an R interface to the JavaScript library DataTables. R data objects (matrices or data frames) can be displayed as tables on HTML pages, and DataTables provides filtering, pagination, sorting, and many other features in the tables.

* caret -- a set of functions that attempt to streamline the process for creating predictive models.

* bslib -- providing tools for customizing Bootstrap themes directly from R, making it much easier to customize the appearance of Shiny apps & R Markdown documents.

Please use following code to install required packages:

`install.packages(c("shiny", "readr", "dplyr", "ggplot2", "summarytools", "DT", "caret", "corrplot", "bslib"))`

## Launch the app

Please run following code in the R console to launch the app:

`shiny::runGitHub("App-for-healthcare", "Fang2403")`
