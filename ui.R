library(shiny)
library(shinythemes)
library(readr)
library(dplyr)
library(DT)
library(bslib)

# list source
num_name <- list("age", "avg_glucose_level", "bmi")
fact_name <- list("gender", "hypertension", "heart_disease", "ever_married", "work_type", "Residence_type",  "smoking_status", "stroke")
stroke_data <- read_csv("data/healthcare-dataset-stroke-data.csv")
col_names <- names(stroke_data)

# User Interface
shinyUI(
              
    navbarPage( title="Stroke Prediciton",
                theme = shinytheme("cerulean"),
    
        tabPanel(
            title="Home",
            fluidPage(
                fluidRow(
                    tags$br(),
                    tags$img(src="dataset-cover.jpg", height = 200, width = 600, alt = "Image is from Kaggle", style = "margin-bottom: 20px;"),
                    tags$br(),
                    tags$br(),
                    column(width = 8,
                           tags$p("Welcome to our interactive Machine Learning platform, powered by Shiny!"),
                           tags$p("This sophisticated web-based application provides a comprehensive suite of analytical tools that enable you to dive deep into datasets through both numerical and graphical summaries. 
                          Customize your analysis by selecting different variables, types of plots, and summary methods to explore data precisely as you need."),
                           tags$p("Our platform not only gives you full access to the dataset but also allows you to create and export subsets tailored by specific variables and conditions. 
                          Additionally, you can build, compare, and evaluate the performance of various machine learning models, including Logistic Regression, Classification Tree, and Random Forest, using your chosen predictors. 
                          Whether you're testing models on our provided dataset or predicting outcomes with new data inputs, our application is designed to enhance your data analysis experience and provide actionable insights."
                           )
                           )
                    
                    )# fluidRow
                 )
            ), # Home, tabPanel
    
        tabPanel(title="About",
            fluidRow(column(12,
                  p("Our platform utilizes a dataset crucial for understanding and predicting stroke, which is the second leading cause of death worldwide according to the World Health Organization (WHO), accounting for about 11% of all deaths globally. 
                    The dataset, sourced from Kaggle", a("Kaggle", href="https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset"),", comprises 5,110 observations across 12 key attributes, including demographic details, health conditions, and lifestyle choices of patients. 
                    Each record in the dataset is rich with individual patient information, designed to help predict the likelihood of a stroke occurring based on various input parameters."),
                  
                   p("Here is a brief overview of the variables included in our dataset:"),
                   tags$ul(
                       tags$li("id: A unique identifier for each patient."),
                       tags$li("gender: The patient's gender, categorized as 'Male', 'Female', or 'Other'."),
                       tags$li("age: The age of the patient."),
                       tags$li("hypertension: Indicates whether the patient suffers from hypertension (1) or not (0)."),
                       tags$li("heart_disease: Indicates the presence (1) or absence (0) of heart disease in the patient."),
                       tags$li("ever_married: Whether the patient has ever been married ('Yes' or 'No')."),
                       tags$li("work_type: The patient's type of employment, which includes categories like 'children', 'Govt_job', 'Never_worked', 'Private', and 'Self-employed'."),
                       tags$li("Residence_type: The patient's living environment, classified as 'Rural' or 'Urban'."),
                       tags$li("avg_glucose_level: The average level of glucose in the patient’s blood."),
                       tags$li("bmi: Body Mass Index, a key indicator of body fat based on height and weight."),
                       tags$li("smoking_status: Smoking habits of the patient, categorized as 'formerly smoked', 'never smoked', 'smokes', or 'Unknown'."),
                       tags$li("stroke: Indicates if the patient has had a stroke (1) or not (0)."))
                   ),
                p("Our application aims to leverage this detailed data to aid in predicting stroke risks, thereby contributing to preventive health strategies.")
            ),
        
        
            fluidRow( 
                column(12,
                       h4('Purpose of each page'),
                       column(3,
                              h5("About"),
                              tags$ul(
                                  tags$li("Describe the purpose of this app"),
                                  tags$li("Describe the data and its source"),
                                  tags$li("Describe the components of the app"))
                       ),
                       column(3,
                              tags$h5("Data Exploration"),
                              tags$ul(
                                  tags$li("Option to select variables to explore the data"),
                                  tags$li("Option to select type of plot or summary reported"),
                                  tags$li("Numerical and graphical reports"))
                       ),
                       column(3,
                              tags$h5("Modeling"),
                              tags$ul(
                                  tags$li("Option to select proportion for spliting data"),
                                  tags$li("Option to select predictors used to build model"),
                                  tags$li("Build logistic, classification tree, and random forest model"),
                                  tags$li("Summary on three models"),
                                  tags$li("Comparison of three models preformance on test data"),
                                  tags$li("Prediciton on new values"))
                      ),
                       column(3,
                              tags$h5("Data"),
                              tags$ul(
                                  tags$li("Access to the full data"),
                                  tags$li("Access to subset data with specific variables or condition"),
                                  tags$li("Option to save selected data as a file"))
                      )
                )
            )
        ), # About, tabPanel
    
        navbarMenu(title="Data Exploration",
               tabPanel(title="Descriptive Statistics",
                   sidebarLayout(
                       sidebarPanel(
                           selectInput("num_var", h3("Choose Numerical Variable"), 
                                       choices=num_name, selected="", multiple=TRUE),
                           selectInput("filter1", "Do you want to filter the data?", choices=c("Yes", "No"),
                                       selected="No"),
                           conditionalPanel(condition="input.filter1=='Yes'",
                                            textInput("num_var_rows", "filter rows", 
                                                      value="", placeholder = 
                                                          "Provide a filter (e.g., age>50 or gender=='Male') ")),
                           actionButton("go1", "Create descriptive statistics. "),
                           actionButton("cor", "Do you want correlation between numeric variables?")
                       ),
                       
                       mainPanel(
                           h3("Descriptive Statistics for numeric predictors"),
                           verbatimTextOutput("descr"),
                           plotOutput("cor")
                           
                       )
                   )
               ), # Descriptive Statistics, subtab
               
               tabPanel( title="Frequency Tables",
                   sidebarLayout(
                       sidebarPanel(
                           tags$h3("One-way Table"),
                           selectInput("fact_var", "Choose one factor variable", 
                                       choices=fact_name, selected="stroke"),
                           selectInput("filter2", "Do you want to filter the data?", choices=c("Yes", "No"),
                                       selected="No"),
                           conditionalPanel(condition="input.filter2=='Yes'",
                                            textInput("one_way_rows", "filter rows", 
                                                      value="", placeholder = 
                                                          "Provide a filter (e.g., age>50 or gender=='Male') ")),
                           actionButton("go2", "Create one way table. "),
                           tags$h3("Two way Table"),
                           selectInput("fact_var1", "Choose factor variable 1", 
                                           choices=fact_name, selected="stroke"),
                           selectInput("fact_var2", "Choose factor variable 2", 
                                           choices=fact_name, selected="gender"),
                           selectInput("filter3", "Do you want to filter the data?", choices=c("Yes", "No"),
                                       selected="No"),
                           conditionalPanel(condition="input.filter3=='Yes'",
                                            textInput("two_way_rows", "filter rows", 
                                                      value="", placeholder = 
                                                          "Provide a filter (e.g., age>50 or gender=='Male') ")),
                           actionButton("go3", "Create two way table. ")
                       ),
                       
                       mainPanel(
                           tags$h3("One-way Table"),
                           tableOutput("one_way"),
                           tags$h3("Two-way Table"),
                           tableOutput("frequency")
                       )
                   )
              
               ), # Frequency Tables, subtab
               
               tabPanel( title="Plot",
                         sidebarLayout(
                             sidebarPanel(
                                 radioButtons("plotoption", "Choose the Option:", 
                                              choices = c("Histogram", "BarPlot", "Scatter", "BoxPlot" )),
                                 conditionalPanel(condition="input.plotoption=='Histogram'",
                                                  selectInput("plotNumVar", "Choose Numeric Varibale ", 
                                                              choices = num_name, selected = "age"),
                                                  selectInput("group", 
                                                               "Do you want to plot across diffenrent groups?",
                                                              choices=c("Yes", "No"), selected="No"),
                                                  conditionalPanel(condition="input.group=='Yes'",
                                                                   selectInput("plotNumVar2", "Choose Group Varibale",
                                                                               choices = append(fact_name, ""), 
                                                                               selected = "")),
                                                  selectInput("fil1", 
                                                              "Do you want to filter the data?",
                                                              choices=c("Yes", "No"), selected="No"),
                                                  conditionalPanel(condition="input.fil1=='Yes'",
                                                                   textInput("plotNumVar3", "filter rows", 
                                                                             value="", 
                                                                             placeholder = "Provide a filter (e.g., age>50 or gender=='Male') ")),
                                                  actionButton("hist", "Plot Histogram")
                                                  ),
                                 conditionalPanel(condition="input.plotoption=='BarPlot'",
                                                  selectInput("plotFactVar", "Choose Categorical Varibale",
                                                              choices = fact_name, selected = "stroke"),
                                                  selectInput("fil2", 
                                                              "Do you want to filter the data?",
                                                              choices=c("Yes", "No"), selected="No"),
                                                  conditionalPanel(condition="input.fil2=='Yes'",
                                                                   textInput("plotFactVar2", "filter rows", 
                                                                             value="", 
                                                                             placeholder = "Provide a filter (e.g., age>50 or gender=='Male') ")),
                                                  actionButton("bar", "Plot Bar Plot")
                                                  ),
                                 conditionalPanel(condition="input.plotoption=='Scatter'",
                                                  selectInput("plotVar1", "Choose Numeric Varibale 1", 
                                                              choices = num_name, selected = "age"),
                                                  selectInput("plotVar2", "Choose Numeric Varibale 2", 
                                                              choices = num_name, 
                                                              selected = "avg_glucose_level"),
                                                  selectInput("group2", 
                                                              "Do you want to plot across diffenrent groups?",
                                                              choices=c("Yes", "No"), selected="No"),
                                                  conditionalPanel(condition="input.group2=='Yes'",
                                                                   selectInput("plotVar3", "Choose Group Varibale",
                                                                               choices = append(fact_name, ""), 
                                                                               selected = "")),
                                                  selectInput("fil3", 
                                                              "Do you want to filter the data?",
                                                              choices=c("Yes", "No"), selected="No"),
                                                  conditionalPanel(condition="input.fil3=='Yes'",
                                                                   textInput("plotVar4", "filter rows", 
                                                                             value="", placeholder = 
                                                                                 "Provide a filter (e.g., age>50 or gender=='Male') ")),
                                                  actionButton("scatter", "Plot Scatter Plot")
                                                  ),
                                 conditionalPanel(condition="input.plotoption=='BoxPlot'",
                                                  selectInput("plotbox", "Choose Numeric Varibale ", 
                                                              choices = num_name, selected = "age"),
                                                  selectInput("group3", 
                                                              "Do you want to plot across diffenrent groups?",
                                                              choices=c("Yes", "No"), selected="No"),
                                                  conditionalPanel(condition="input.group3=='Yes'",
                                                                   selectInput("plotbox2", "Choose Group Varibale",
                                                                               choices = append(fact_name, ""), 
                                                                               selected = "")),
                                                  selectInput("fil4", 
                                                              "Do you want to filter the data?",
                                                              choices=c("Yes", "No"), selected="No"),
                                                  conditionalPanel(condition="input.fil4=='Yes'",
                                                                   textInput("plotbox3", "filter rows", 
                                                                             value="", placeholder = 
                                                                                 "Provide a filter (e.g., age>50 or gender=='Male') ")),
                                                  actionButton("box", "Plot Box Plot"))
                            ),
                             mainPanel(
                                 h3("Plots"),
                                 fluidRow(
                                     plotOutput("plot")
                                 )
                             )
                         )
               )
        ), # Plot, subtab
    
        tabPanel(title="Modeling",
            tabsetPanel(
                tabPanel(title="Modeling Info",
                    wellPanel(
                        h3("Logistic Regression"),
                        withMathJax(),
                        p("When the response falls into one of two categories, we will use logistic model to predict the probability that response belongs to a particular category. Since the outcome is a probability, the dependent variable is bounded between 0 and 1. In logistic regression, a logit transformation is applied on the odds—that is, the probability of success divided by the probability of failure. This is also commonly known as the log odds, or the natural logarithm of odds, and this logistic function is represented by the following formulas:" ),
                        uiOutput("log"),
                        p("In this logistic regression equation, logit(pi) is the dependent or response variable and x is the independent variable. The beta parameter, or coefficient, in this model is commonly estimated via maximum likelihood estimation (MLE). For this data, logistic regression model links the log-odds of stroke with linear combination of the predictors."),
                        h4("Pros:"),
                        tags$ul(
                            tags$li("Simily alforithm that is easy to implement"),
                            tags$li("Not require high computation power")),
                        h4("Cons:"),
                        tags$ul(
                            tags$li("Doesn't have a closed form solution."),
                            tags$li("Construct linear boundaries"))
                    ),
                    wellPanel(
                        h3("Classification Tree"),
                        p("Decision Tree splits up predictor space into regions, and predicts different value for each region. Classification tree uses prevalent class as the final prediction. Classification tree is built through a process known as binary recursive partitioning. This is an iterative process of splitting the data into partitions, and then splitting it up further on each of the branches. Initially, all objects are considered as a single group. the group is split into two subgroups using a creteria, say high values of a variable for one group and low values for the other. The two subgroups are then split using the values of a second variable. The splitting process continues until a suitable stopping point is reached. The values of the splitting variables can be ordered or unordered categories. For every possible value of each predictor, this method tries to minimize Gini index or entropy/deviance to decide how to split the predictor space. "),
                        uiOutput("gini"),
                        uiOutput("entro"),
                        h4("Pros:"),
                        tags$ul(
                            tags$li("Easy to interpret output"),
                            tags$li("No statistically assumption necessary"),
                            tags$li("Predictors don't need to be scaled"),
                            tags$li("Automatically account for predictors interaction")),
                        h4("Cons:"),
                        tags$ul(
                            tags$li("Need to prune"),
                            tags$li("Small change in data may vastly change predictions"),
                            tags$li("Greedy algorithm necessary (no optimal algorithm)"))

                    ),
                    wellPanel(
                        h3("Random Forest"),
                        withMathJax(),
                        p("Random forest consists of a large number of individual decision trees that operate as an ensemble. Random forest models use bootstrap resampling to fit trees, each one is built on a random subset of predictors. Final prediction is the mean or majority vote. The random subset procedure makes the predictions are not dominated by some specific predictors. A large number of relatively uncorrelated trees ensure random forest outperform any of the individual constituent models. "),
                        helpText("The standard practice is to use \\(\\frac{p}{3}\\) for numeric response and \\(\\sqrt{n}\\) for categorical response, where p represents the total number of predictors."),
                        h4("Pros:"),
                        tags$ul(
                            tags$li("Impove prediction"),
                            tags$li("Generate uncorrelated decision trees"),
                            tags$li("Not influenced by outliers to a fair degree")),
                        h4("Cons:"),
                        tags$ul(
                            tags$li("Lose interpretability"),
                            tags$li("computationally expensive"))
                    )
                ),
            
                tabPanel(
                    title="Model Fitting",
                    fluidRow(
                        column(4,
                           sliderInput("logrprop", "Select Proportion to Split the Data", 
                                       value = 0.8, step=0.1, min=0, max=1)),
                        column(4,
                           selectInput("logrvar", "Select Variables to build the Model", 
                                       choices = c("age", "avg_glucose_level","gender", "hypertension",
                                                   "heart_disease", "ever_married", "work_type",
                                                   "Residence_type", "smoking_status"), 
                                       selected = "", 
                                       multiple=TRUE)),
                        column(4,
                           numericInput("k", "Number of CV Folders", 
                                        value = 5, step=1, min=3, max=10))
                        ),
                    fluidRow(actionButton("fitmodel", "Are you ready to fit the model?"),
                                align="center"),
                    fluidRow(
                        h4("Logistic Model Summary"),
                        verbatimTextOutput("logroutput")
                           ),
                    fluidRow(
                        h4("Classification Tree Summary"),
                        verbatimTextOutput("treeoutput")
                           ),
                    fluidRow(
                        h4("Random Forest Summary"),
                        verbatimTextOutput("randomForestOutput"),
                        column(6,
                           verbatimTextOutput("varImportanceOutput")),
                        column(6, 
                           plotOutput("importance"))
                          ),
                    fluidRow(
                        h4("Performance on Test Data"),
                        h5("Logistic Model"),
                        verbatimTextOutput("confus1"),
                        verbatimTextOutput("accuracy1"),
                        h5("Classification Tree"),
                        verbatimTextOutput("confus2"),
                        verbatimTextOutput("accuracy2"),
                        h5("Ranodm Forest"),
                        verbatimTextOutput("confus3"),
                        verbatimTextOutput("accuracy3")
                           )
                ),
            
                tabPanel(
                    title="Prediction",
                    sidebarLayout(
                        sidebarPanel(
                            h4("Please fit the model from Model Fitting tab. "),
                            selectInput("preModel", "Select Model to Predict", 
                                    choices = c("Logistic Regression", "Classification Tree", 
                                                "Random Forest"), selected = "Logistic Regression"),
                            selectInput("gender", "Select gender value", choices=c("Male", "Female"), selected=""),
                            numericInput("age", "Select age value", value=50),
                            selectInput("hyper", "Select hypertension value", choices=c("0", "1"), selected=""),
                            selectInput("disease", "Select heart disease value", choices=c("0", "1"), selected=""),
                            selectInput("marry", "Select marry status", choices=c("Yes", "No"), selected=""),
                            selectInput("work", "Select work type", choices=c("Private", "Self-employed"), selected=""),
                            selectInput("residence", "Select residence type", choices=c("Urban", "Rural"), selected=""),
                            numericInput("avg", "Select average glucose level", value=100),
                            numericInput("bmi", "Select bmi value", value=30),
                            selectInput("smoke", "Select smoking status", 
                                    choices=c("formerly smoked", "never smoked", "smokes", "Unknown"), selected=""),
                            actionButton("go", "Gain the prediction")
                        ),
                        mainPanel(
                            h3("Prediction on the user given parameters:"),
                            verbatimTextOutput("prediction")
                     )
                    )
                )
            )
        ),
    
        tabPanel(title="Data",
             sidebarLayout(
                 sidebarPanel(
                     radioButtons("showdata", "Choice data type:", 
                                  choices = c("Full Data", "Subset Data"), selected="Full Data"),
                     conditionalPanel(condition="input.showdata=='Subset Data'",
                                      selectInput("data_cols", "select columns ", 
                                                      choices = append(col_names,""), selected ="",
                                                      multiple = TRUE),
                                      textInput("data_rows", "filter rows", 
                                                  value="",
                                                placeholder = "Provide a filter (e.g., age>50 or gender=='Male') ")),
                     h4("Save the data shown on the right as a file"),
                     downloadButton("downloadData", "Download as .csv file")
                 ), 
                 
                 mainPanel(
                     DT::dataTableOutput("view")
                     )
             )
        )
    )      
  )

 

