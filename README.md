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

## Key R Packages Used

This project leverages several powerful R packages to build an interactive web application and handle data efficiently:

Shiny: A framework for creating interactive web applications directly in R. Shiny makes it straightforward to build interactive user interfaces that can connect seamlessly with R analytics.

Readr: Provides a fast and user-friendly way to read and parse various types of data files in R. It is designed to simplify the process of importing data and to increase performance.

Dplyr: Known as a grammar of data manipulation, this package offers a consistent set of verbs that address the most common data manipulation challenges, making data operations more intuitive.

Corrplot: Offers a visual exploratory tool on correlation matrices. It includes automatic variable reordering which assists in unveiling hidden patterns among variables, crucial for comprehensive data analysis.

SummaryTools: Delivers a unified set of tools focused on data exploration and basic reporting. This package simplifies the initial data analysis process, providing quick and informative summaries.

Ggplot2: A system for 'declaratively' creating graphics, based on the Grammar of Graphics. This package allows you to create complex plots from data in a dataframe with a high degree of customization.

DT: Provides an R interface to the JavaScript library 'DataTables'. This integration allows R data objects like matrices or data frames to be displayed as interactive tables on HTML pages, equipped with features such as filtering, pagination, and sorting.

Caret: Streamlines the process of creating predictive models by providing a suite of functions that are both flexible and powerful for modeling.

Bslib: Offers tools to customize Bootstrap themes directly from R. It significantly eases the customization of both Shiny applications and R Markdown documents, enhancing their aesthetic and functional qualities.

Each of these packages plays a vital role in the development of our application, from the backend data handling to the frontend user interaction.

Please use following code to install required packages:

`install.packages(c("shiny", "readr", "dplyr", "ggplot2", "summarytools", "DT", "caret", "corrplot", "bslib"))`

## Launch the app

Please run following code in the R console to launch the app:

`shiny::runGitHub("Development-of-an-Interactive-Stroke-Prediction-Tool", "Fang2403")`
