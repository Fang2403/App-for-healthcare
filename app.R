library(shiny)
library(tidyverse)
library(summarytools)

data <- read_csv("data/healthcare-dataset-stroke-data.csv")
data$heart_disease <- as.factor(data$heart_disease)
data$hypertension <- as.factor(data$hypertension)
data$stroke <- as.factor(data$stroke)
num_var <- list("age", "avg_glucose_level", "bmi")
fact_var <- list("gender", "hypertension", "heart_disease", "ever_married", "work_type", "Residence_type", "smoking_status", "stroke")

# Define UI for application
ui <- 
  )  


# Define server logic required 

server <- function(input, output) {
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)


tabPanel(title="Data Exploration",
         sidebarLayout(
             sidebarPanel(
                 selectInput("num_var", "Numerical Variable", choices=num_var, selected="", multiple=TRUE),
                 selectInput("fact_var", "Factor Variable", choices=fact_var, selected="", multiple=TRUE)
                 
             ),
             
             mainPanel(
                 tabsetPanel(
                     tabPanel(title="Descriptive Statistics",
                              wellPanel(
                                  h3(textOutput("num_sum")),
                                  verbatimTextOutput("descr")
                                  
                              ),
                              wellPanel(
                                  h3(textOutput("fact_sum")),
                                  tableOutput("frequency")
                              ),
                              wellPanel(
                                  h3(textOutput("across_sum")),
                                  tableOutput("statistics"))
                     ),
                     
                     tabPanel(title="Correlation",
                              plotOutput("bar")),
                     
                     tabPanel(title="Frequency Tables",
                              plotOutput("bar")),
                     
                     tabPanel(title="Plots",
                              plotOutput("bar"))
                     
                     
                 )
             )
         )
),