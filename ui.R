library(shiny)
library(readr)

num_name <- list("age", "avg_glucose_level")
fact_name <- list("gender", "hypertension", "heart_disease", "ever_married", "work_type", "Residence_type", "bmi", "smoking_status", "stroke")
stroke_data <- read_csv("data/healthcare-dataset-stroke-data.csv")
col_names <- names(stroke_data)

shinyUI( navbarPage( title="Stroke",
    
    tabPanel(title="About",
        fluidRow(img(src="dataset-cover.jpg")),
        fluidRow(
            h4("About this app"),
            p("I am going to create a web-based applet that cna be used to explore data and model it. In this app, user can explore the charecter of the train data, build different type models on the train data, and make predictions on the test data. Users cna customize the type of summaries and predictors used in the summary and models."),
            h4("Data"),
            p("The data used in the app is from", a(href="https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset", "Kaggle"), "."),
            h4('components'),
            p(strong("Data Exploration")," -- basic statistics and plots"),
            br(),
            strong("Modeling"),
            br(),
            
            p(strong("Data")," -- To view the data "),
            p()
        )
        
    ),
    
    navbarMenu(title="Data Exploration",
               tabPanel(title="Descriptive Statistics",
                   sidebarLayout(
                       sidebarPanel(
                           selectInput("num_var", h3("Choose Numerical Variable"), 
                                       choices=num_name, selected="age", multiple=TRUE)
                       ),
                       
                       mainPanel(
                           h3("Descriptive Statistics for numeric predictors"),
                           verbatimTextOutput("descr")
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
                title="Modeling Info"
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
                     downloadButton("downloadData", "Download .csv")
                 ), 
                 
                 mainPanel(
                     dataTableOutput("table1")
                     )
             )
    )      
  )
)  
 

