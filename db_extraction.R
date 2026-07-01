library(DBI)
library(RPostgres)
library(dotenv)

readRenviron(".env")
db_user <- Sys.getenv("DB_USER")
db_password <- Sys.getenv("DB_PASSWORD")
db_name <- Sys.getenv("DB_NAME")

con <- dbConnect(
  RPostgres::Postgres(),
  user = db_user,
  password = db_password,
  host = "localhost",
  port = 5432,
  dbname = db_name

)
cat("Successfully connected to the database!\n")

patient_df <- dbGetQuery(con, "SELECT * FROM patients")

dbDisconnect(con)



# IDEAS: Did Hospitals relate to days admitted?
# Insurance provider and billing amount or medical condition?
# could look at number of patients age (50?60?+) on certain med
# Admission type and billing amount
## Predict billing amount on age, admission type, and medical condition. MLR or RF
## Predict if patient has Abnormal test result based on age, gender, and medical condition. Logistic/XGBoost
# However, first, use anova(num) and chisq on a table(cat) to check importance
# Could also train a RF and use VIP to see.