ui_choices <- readRDS("output/ui_choices.rds")

selectInput01 <- function(id) {
  selectInput(id, label = id, choices = ui_choices[[id]])
}