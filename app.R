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
ui <- navbarPage(
        title="Stroke",
        
        tabPanel(
            title="About",
            
            img(src="dataset-cover.jpg")
        ),
        
        tabPanel(
            title="Data Exploration",
            titlePanel("EDA"),
            sidebarLayout(
                sidebarPanel(
                    selectInput("num_var", "Numerical Variable", choices=num_var),
                    selectInput("fact_var", "Factor Variable", choices=fact_var)
                    
                ),
                
                mainPanel(
                    tabsetPanel(
                        tabPanel(title="numeric summary",
                                 wellPanel(
                                     h3(textOutput("num_sum")),
                                     tableOutput("num_stat")
                                 ),
                                 wellPanel(
                                     h3(textOutput("fact_sum")),
                                     tableOutput("frequency")
                                 ),
                                 wellPanel(
                                     h3(textOutput("across_sum")),
                                     tableOutput("statistics"))
                                 ),
                        tabPanel(title="graphic summary",
                                 plotOutput("bar"))
                        
                        
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
                    title="Model Fitting"
                ),
            
                tabPanel(
                    title="Prediction"
                )
            ),
            

        ),
        
        tabPanel(
            title="Data"
        )
  )  


# Define server logic required 

server <- function(input, output) {
    
    #numeric panel
    output$num_sum <- renderText(paste("descriptive statistics on ", input$num_var))
    output$fact_sum <- renderText(paste("frequency table on ", input$fact_var))
    output$across_sum <- renderText(paste(input$num_var, " summary across ", input$fact_var))
    
    output$num_stat <- renderTable(
        descr(data[,input$num_var]) %>% tb()
    )
    
    output$frequency <- renderTable(
        freq(data[,input$fact_var], order="freq") %>% tb()
    )

    output$statistics <- renderTable(
        data %>% group_by(!!sym(input$fact_var)) %>% summarize(minimum=min(!!sym(input$num_var)), Q1=quantile(!!sym(input$num_var), probs=0.25), median=median(!!sym(input$num_var)), Q3=quantile(!!sym(input$num_var), probs=0.75), max=max(!!sym(input$num_var))))

    
    # graphic panel
    
    output$bar <- renderPlot(
        ggplot(data, aes(x=!!sym(input$fact_var))) + geom_bar(aes(fill=stroke, position="dodge"))
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
