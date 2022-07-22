library(shiny)
library(readr)

num_name <- list("age", "avg_glucose_level")
fact_name <- list("gender", "hypertension", "heart_disease", "ever_married", "work_type", "Residence_type", "bmi", "smoking_status", "stroke")
stroke_data <- read_csv("data/healthcare-dataset-stroke-data.csv")
col_names <- names(stroke_data)

shinyUI( navbarPage( title="Stroke",
    
    tabPanel(title="About",
        fluidRow(img(src="dataset-cover.jpg"))
        
    ),
    
    navbarMenu(title="Data Exploration",
               tabPanel(title="Descriptive Statistics",
                   sidebarLayout(
                       sidebarPanel(
                           selectInput("num_var", h3("Choose Numerical Variable"), 
                                       choices=num_name, selected="age", multiple=TRUE)
                       ),
                       
                       mainPanel(
                           h3("Descriptive Statistics"),
                           verbatimTextOutput("descr")
                       )
                   )
               ),
               tabPanel( title="Frequency Tables",
                   sidebarLayout(
                       sidebarPanel(
                           h3("One-way Table"),
                           selectInput("fact_var", "Choose factor variable 1", 
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
                           h3("Descriptive Summary")
                           
                       ),
                       
                       mainPanel(
                           h3("Descriptive Statistics")
                           
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
                sidebarLayout(
                    sidebarPanel(
                        selectInput("logrvar", "Select Variable", 
                                    choices = col_names, selected = "heart_disease", 
                                    multiple=TRUE),
                        numericInput("logrprop", "Select Proportion", 
                                     value = 0.8, step=0.1, min=0, max=1),
                        radioButtons("logroption", "Select Method", 
                                     choices = c( "Fit", "Coef.", "Pred. Accuracy"))
                    ),
                    mainPanel(
                        div(verbatimTextOutput("logroutput"))
                    )
                )
            ),
            
            tabPanel(
                title="Prediction"
            )
        )
    ),
    
    tabPanel(title="Data",
             sidebarLayout(
                 sidebarPanel(
                     radioButtons("showdata", "Choice:", 
                                  choices = c("Full", "Columns"), selected="Full"),
                     conditionalPanel(condition="input.showdata=='Columns'",
                                          selectInput("cols", "Choose the variable ", 
                                                      choices = col_names, selected = " ",
                                                      multiple = TRUE))
                 ), 
                 
                 mainPanel(
                     dataTableOutput("full_table"),
                     dataTableOutput("data_table")
                     )
             )
             
    )
  )  
)  

