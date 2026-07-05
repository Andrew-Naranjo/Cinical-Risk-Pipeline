library(shiny)
library(tidymodels)
library(dplyr)
library(ggplot2)

# 1. Load Models
cat("Loading classification model...\n")
rf_class_model <- readRDS("output/rf_model_classification_testresults.rds")

cat("Loading regression model...\n")
rf_reg_model <- readRDS("output/rf_model_regression_billingamount.rds")

################ UI
ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      .prediction-box { background-color: #f8f9fa; border-left: 5px solid #2c3e50; padding: 15px; margin-bottom: 20px; }
      .class-box { border-left-color: #e74c3c; } 
      .reg-box { border-left-color: #27ae60; }   
    "))
  ),
  
  titlePanel(" Patient Risk & Financial Dashboard"),
  
  sidebarLayout(
    
    # --- LEFT SIDEBAR: User Inputs ---
    sidebarPanel(
      h4("Patient Demographics & Vitals"),
      hr(),
      
      selectInput01("gender"),
      selectInput01("condition"),
      selectInput01("admission"),
      selectInput01("insurance"),
      
      br(),
      actionButton("predict_btn", "Calculate Patient Profile", class = "btn-primary btn-block")
    ),
    
    # --- RIGHT MAIN PANEL: Outputs ---
    mainPanel(
      h3("Model Outputs"),
      
      fluidRow(
        column(6,
          div(class = "prediction-box class-box",
              h4("Predicted Clinical Test Result"),
              h2(textOutput("class_text"), style = "color: #c0392b;")
          )
        ),
        column(6,
          div(class = "prediction-box reg-box",
              h4("Estimated Billing Amount"),
              h2(textOutput("reg_text"), style = "color: #27ae60;")
          )
        )
      ),
      
      hr(),
      h4("Risk Factor Contribution"),
      plotOutput("risk_plot", height = "300px")
    )
  )
)

#--------------------------------------------------------------------#
server <- function(input, output) {
  
  model_results <- eventReactive(input$predict_btn, {
    
    # The dataframe MUST contain every column needed by BOTH models
    new_patient <- data.frame(
      gender = input$gender,
      medical_condition = input$condition,
      admission_type = input$admission,
      insurance_provider = input$insurance
    ) %>%
      mutate(
        gender = as.factor(gender),
        medical_condition = as.factor(medical_condition),
        admission_type = as.factor(admission_type),
        insurance_provider = as.factor(insurance_provider)
      )
    
    # Run the Predictions
    # tidymodels is smart enough to just ignore the extra columns in the df that a specific model doesn't need
    pred_class <- predict(rf_class_model, new_patient)
    result_class <- as.character(pred_class$.pred_class)
    
    pred_reg <- predict(rf_reg_model, new_patient)
    result_reg <- as.numeric(pred_reg$.pred)
    
    # mock risk weights for visualization based on the new features
    condition_weight <- case_when(
      input$condition %in% c("Cancer", "Diabetes", "Hypertension") ~ 40,
      TRUE ~ 20
    )
    admission_weight <- ifelse(input$admission == "Emergency", 30, 10)
    insurance_weight <- ifelse(input$insurance == "Medicare", 25, 15)
    
    list(
      classification = result_class,
      regression = result_reg,
      plot_data = data.frame(
        Factor = c("Condition", "Admission", "Insurance"),
        Weight = c(condition_weight, admission_weight, insurance_weight)
      )
    )
  }, ignoreNULL = FALSE)
  
  output$class_text <- renderText({
    res <- model_results()
    res$classification
  })
  
  output$reg_text <- renderText({
    res <- model_results()
    paste0("$", formatC(res$regression, format = "f", digits = 2, big.mark = ","))
  })
  
  output$risk_plot <- renderPlot({
    res <- model_results()
    
    ggplot(res$plot_data, aes(x = reorder(Factor, Weight), y = Weight, fill = Factor)) +
      geom_col(show.legend = FALSE) +
      coord_flip() + 
      scale_fill_manual(values = c("Condition" = "#e67e22", "Admission" = "#9b59b6", "Insurance" = "#34495e")) +
      theme_minimal() +
      labs(x = "", y = "Relative Risk Weight") +
      theme(
        axis.text.y = element_text(size = 14, face = "bold"),
        axis.title.x = element_text(size = 12)
      )
  })
}

shinyApp(ui = ui, server = server)