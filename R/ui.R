ui_choices <- readRDS("ui_choices.rds")

selectInput01 <- function(id) {
  selectInput(id, label = id, choices = ui_choices[[id]])
}