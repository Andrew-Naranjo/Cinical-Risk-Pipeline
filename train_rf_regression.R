library(tidymodels)
library(ranger)
library(tidyverse)
library(vip) # Seeing most important variables

set.seed(777)
data_split <- initial_split(patient_df, prop = .8)
train_data <- training(data_split)
test_data <- testing(data_split)

# Spec
rf_spec <- rand_forest(trees = 200) |> 
  set_engine("ranger", importance = "impurity") |> 
  set_mode("regression")
# Workflow
rf_wf <- workflow() |> 
  add_model(rf_spec) |> 
  add_formula(billing_amount ~ .)

rf_fit <- rf_wf |> 
  fit(data = train_data) # Fit on training data.

vip(rf_fit)
# Doctor and Hospital would be interesting in a real dataset but too many types here.
rf_wf <- rf_wf |> 
  update_formula(billing_amount ~ insurance_provider + medical_condition + admission_type)

rf_fit <- rf_wf |> 
  fit(data = train_data) # Could use last_fit here but I want to see the accuracy
# Testing accuracy
predictions <- predict(rf_fit, test_data) %>%
  bind_cols(test_data %>% select(billing_amount))


saveRDS(rf_fit, "rf_model_regression_billingamount.rds")

#-----------------------------------------------------------#
ui_choices <- list(
  gender = unique(patient_df$gender),
  condition = unique(patient_df$medical_condition),
  admission = unique(patient_df$admission_type),
  insurance = unique(patient_df$insurance_provider)
)
saveRDS(ui_choices, "ui_choices.rds")
