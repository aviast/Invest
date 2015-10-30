Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_45')
library(rJava)
library(plyr)
library(lubridate)
library(XLConnect)

INDEX <- list.files(path = "ASX 200", full.names = TRUE)

readASX200 <- function(FILENAME) {
  DATE <- ymd(sub("[^/]*/([0-9]{1,2})\\.([0-9]{1,2})\\.([0-9]{2})\\.xlsx", "20\\3-\\2-\\1", FILENAME))
  SHEET <- readWorksheetFromFile(file = FILENAME, sheet = 1)
  
  if (length(colnames(SHEET)) == 3) {
    colnames(SHEET) <- c("Code","MarketCap","Weight")
    SHEET$Company <- NA
  } else {
    colnames(SHEET) <- c("Code","Company","MarketCap","Weight")
  }
  
  SHEET$Date <- DATE
  
  # Some worksheets include a "x 100" multiplier that needs to be undone.
  if (max(SHEET$Weight) > 1) {
    SHEET$Weight <- SHEET$Weight / 100
  }
  
  return(SHEET)
}

AXJO <- adply(INDEX, 1, readASX200, .id = "Code")

rm(INDEX)