Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_45')
library(rJava)
library(plyr)
library(lubridate)
library(XLConnect)

INPUT <- list.files(path = "OPTIONS", full.names = TRUE)

readOptions <- function(FILENAME) {
  YEAR <- sub("[^0-9]+([0-9]{4})\\.xls", "\\1", FILENAME)
  WKBK <- loadWorkbook(filename = FILENAME, create = FALSE)
  SHEETS <- getSheets(WKBK)
  
  readOptionSheet <- function(SHT) {
    print(paste("Year:", YEAR, "Month:", SHT))
    TEMP <- readWorksheet(object = WKBK, sheet = SHT, header = FALSE)
    
    if (nrow(TEMP) == 0) {
      print(paste("WARNING: No data for year: ", YEAR, "Month:", SHT))
    } else {
      RANGE <- setdiff(which(grepl("^[A-Z]{3,}", TEMP$Col1)), which(grepl("^TOTAL", TEMP$Col1)))

      TEMP <- TEMP[RANGE, ]
      TEMP$Year <- YEAR
      TEMP$Sheet <- SHT
    }
    
    return(TEMP)
  }
  
  SHEET <- adply(SHEETS, 1, readOptionSheet, .id = NULL)
  
  return(SHEET)
}

OPTIONS <- adply(INPUT, 1, readOptions, .id = NULL)

rm(INPUT)