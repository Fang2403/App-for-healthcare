library(shiny)
library(readr)

num_name <- list("age", "avg_glucose_level", "bmi")
fact_name <- list("gender", "hypertension", "heart_disease", "ever_married", "work_type", "Residence_type",  "smoking_status", "stroke")
stroke_data <- read_csv("data/healthcare-dataset-stroke-data.csv")
col_names <- names(stroke_data)

shinyUI( navbarPage( title="Stroke",
    
    tabPanel(title="About",
        fluidRow(img(src="dataset-cover.jpg")),
        fluidRow(
            column(10,
                h4("App Overview"),
                   p("This is a web-based applet that can be used to explore data and predict response. In this app, users can explore the charecter of the data through multiple numerical and graphical summaries based on user chosen variables. Different type of plots and summaries are available. Users also have access to the data, subset with specific variables and conditions, and save selected data as a file. Logistic Regression, Classification Tree and Random Forest models are built on the train data with user chosen predictors. Their perfomance on test data set are also availabel in this app."))),
        fluidRow(
            column(12,
                   h4("Data"),
                   p("According to the World Health Organization (WHO) stroke is the 2nd leading cause of death globally, responsible for approximately 11% of total deaths. The data used here contains 5110 observations with 12 attributes like gender, age, various diseases, and smoking status from ", a("Kaggle", href="https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset"), ". We hope to predict whether a patient is likely to get stroke based on the input parameters. Each row in the data provides relavant information about the patient."))),
            fluidRow( h4('Purpose of each page'),
                column(3,
                       h5("About"),
                       tags$ul(
                           tags$li("Describe the data and its source"),
                           tags$li("Describe the purpose and components of the app"))
                ),
                column(3,
                       h5("Data Exploration"),
                       tags$ul(
                           tags$li("Option to select variables and type of summary"),
                           tags$li("Numerical and graphical reports"))
                ),
                column(3,
                       h5("Modeling"),
                       tags$ul(
                           tags$li("Option to select proportion for spliting data"),
                           tags$li("Option to select predictors used to build model"),
                           tags$li("Summary on three models"),
                           tags$li("Comparison of three models preformance on test data"),
                           tags$li("Prediciton using user chosen model"))
                ),
                column(3,
                       h5("Data"),
                       tags$ul(
                           tags$li("Access to the data or subset with specific variables and condition"),
                           tags$li("Option to save selected data as a file"))
                )
            )
    ),
    
    navbarMenu(title="Data Exploration",
               tabPanel(title="Descriptive Statistics",
                   sidebarLayout(
                       sidebarPanel(
                           selectInput("num_var", h3("Choose Numerical Variable"), 
                                       choices=num_name, selected="age", multiple=TRUE),
                           actionButton("cor", "Do you want correlation between numeric variables?")
                       ),
                       
                       mainPanel(
                           h3("Descriptive Statistics for numeric predictors"),
                           verbatimTextOutput("descr"),
                           plotOutput("cor")
                           
                       )
                   )
               ),
               tabPanel( title="Frequency Tables",
                   sidebarLayout(
                       sidebarPanel(
                           h3("One-way Table"),
                           selectInput("fact_var", "Choose one factor variable", 
                                       choices=fact_name, selected="stroke"),
                           h3("Two way Table"),
                           selectInput("fact_var1", "Choose factor variable 1", 
                                           choices=fact_name, selected="stroke"),
                           selectInput("fact_var2", "Choose factor variable 2", 
                                           choices=fact_name, selected="gender")
                       ),
                       
                       mainPanel(
                           h3("One-way Table"),
                           dataTableOutput("one_way"),
                           h3("Two-way Table"),
                           dataTableOutput("frequency")
                       )
                   )
               ),
               tabPanel( title="Plot",
                         sidebarLayout(
                             sidebarPanel(
                                 radioButtons("plotoption", "Choose the Option:", 
                                              choices = c("Histogram", "BarPlot", "Scatter", "BoxPlot" )),
                                 conditionalPanel(condition="input.plotoption=='Histogram'",
                                                  selectInput("plotNumVar", "Choose Numeric Varibale ", 
                                                              choices = num_name, selected = "age"),
                                                  selectInput("plotNumVar2", "Choose Group Varibale", 
                                                              choices = fact_name, 
                                                              selected = "")),
                                 conditionalPanel(condition="input.plotoption=='BarPlot'",
                                                  selectInput("plotFactVar", "Choose Categorical Varibale",
                                                              choices = fact_name, selected = "stroke")),
                                 conditionalPanel(condition="input.plotoption=='Scatter'",
                                                  selectInput("plotVar1", "Choose Numeric Varibale 1", 
                                                              choices = num_name, selected = "age"),
                                                  selectInput("plotVar2", "Choose Numeric Varibale 2", 
                                                              choices = num_name, 
                                                              selected = "avg_glucose_level"),
                                                  selectInput("plotVar3", "Choose Group Varibale", 
                                                              choices = fact_name, 
                                                              selected = "stoke")),
                                 conditionalPanel(condition="input.plotoption=='BoxPlot'",
                                                  selectInput("plotNumVar3", "Choose Numeric Varibale ", 
                                                              choices = num_name, selected = "age"),
                                                  selectInput("plotNumVar4", "Choose Group Varibale", 
                                                              choices = fact_name, 
                                                              selected = ""))
                                 
                            ),
                             mainPanel(
                                 h3("Plots"),
                                 fluidRow(
                                     plotOutput("plot")
                                 )
                             )
                         )
               )
    ),
    
    tabPanel(
        title="Modeling",
        tabsetPanel(
            tabPanel(
                title="Modeling Info",
                wellPanel(
                    h3("Logistic Regression"),
                    withMathJax(),
                    p("When the response falls into one of two categories, we will use logistic model to predict the probability that response belongs to a particular category. For this data, logistic regression model links the log-odds of stroke with linear combination of the predictors:" ),
                    uiOutput("log"),
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
                    p("This method splits up predictor space into regions, and predicts different value for each region. Classification tree uses prevalent class as the final prediction. Recursive binary splitting is used to split the predictor space: For every possible value of each predictor, try to minimize Gini index or entropy/deviance to decide how to split the predictor space. "),
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
                    p("Random forest models use bootstrap resampling to fit many trees, each one using a random subset of predictors. Final prediction is the mean or majority vote. The random subset procedure makes the predictions are not dominated by some specific predictors."),
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
                    column(3,
                           h4("Logistic Model"),
                           verbatimTextOutput("logroutput")
                           ),
                    column(3,
                           h4("Classification Tree"),
                           verbatimTextOutput("treeoutput")
                           ),
                    column(3,
                           h4("Random Forest"),
                           verbatimTextOutput("randomForestOutput"),
                           verbatimTextOutput("varImportanceOutput"),
                           plotOutput("importance")
                          ),
                    column(3,
                           h4("Comparing on test data set"),
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
                )
            ),
            
            tabPanel(
                title="Prediction",
                sidebarLayout(
                    sidebarPanel(
                        h3("Please fit the model from Model Fitting tab. "),
                        selectInput("preModel", "Select Model to Predict", 
                                    choices = c("Logistic Regression", "Classification Tree", 
                                                "Random Forest"), selected = "Logistic Regression", 
                                    multiple=TRUE)
                    ),
                    mainPanel(
                        h3("Confusion Matrix"),
                        verbatimTextOutput("prediction"),
                        h3("Accuracy"),
                        verbatimTextOutput("accur")
                    )
                )
            )
        )
    ),
    
    tabPanel(title="Data",
             sidebarLayout(
                 sidebarPanel(
                     radioButtons("showdata", "Choice:", 
                                  choices = c("Full", "Columns", "Rows"), selected="Full"),
                     conditionalPanel(condition="input.showdata=='Columns'",
                                          selectInput("cols", "Choose the variable ", 
                                                      choices = col_names, selected = " ",
                                                      multiple = TRUE)),
                     conditionalPanel(condition="input.showdata=='Rows'",
                                      textInput("rows", "row condition", value = ""),
                                      actionButton("submit1", "filter data")),
                     downloadButton("downloadData", "Download as .csv file")
                 ), 
                 
                 mainPanel(
                     dataTableOutput("table1")
                     )
             )
    )      
  )
)  
 

