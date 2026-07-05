library(tidymodels)
library(ranger)
library(tidyverse)
library(vip) # Seeing most important variables

patient_df <- patient_df |>
  mutate(test_results = as.factor(test_results))

set.seed(777)
data_split <- initial_split(patient_df, prop = .8)
train_data <- training(data_split)
test_data <- testing(data_split)

# Spec
rf_spec <- rand_forest(trees = 200) |> 
  set_engine("ranger", importance = "impurity") |> 
  set_mode("classification")
# Workflow
rf_wf <- workflow() |> 
  add_model(rf_spec) |> 
  add_formula(test_results ~ age + gender + medical_condition + admission_type)

rf_fit <- rf_wf |> 
  fit(data = train_data) # Fit on training data.

vip(rf_fit)
# Let's use just medical, admission, and gender then for our final model.
rf_wf <- rf_wf |> 
  update_formula(test_results ~ gender + medical_condition + admission_type)

rf_fit <- rf_wf |> 
  fit(data = train_data) # Could use last_fit here but I want to see the accuracy like so
# Testing accuracy
predictions <- predict(rf_fit, test_data) %>%
  bind_cols(test_data %>% select(test_results))
accuracy <- metrics(predictions, truth = test_results, estimate = .pred_class)
print(accuracy)

saveRDS(rf_fit, "output/rf_model_classification_testresults.rds")
  