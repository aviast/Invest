library(plyr)
library(lubridate)

INPUT <- list.files(path = "SHARES", pattern = "txt$", ignore.case = TRUE, recursive = TRUE, full.names = TRUE)

readHistoricalData <- function(FILENAME) {
  read.csv(FILENAME, col.names = c("Code", "Date", "Open", "High", "Low", "Close", "Volume"), stringsAsFactors = FALSE)
}

DATA <- adply(INPUT, 1, readHistoricalData, .id = "Code", .progress = "text")

DATA$Code <- factor(DATA$Code)
DATA$Date <- ymd(DATA$Date)

rm(INPUT, readHistoricalData)
