##
## Script to download historical data from Yahoo
##
# Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_45')
# library(rJava)
# library(XLConnect)
# STOCKS <- readWorksheetFromFile(file = "YAHOO/Yahoo Ticker Symbols - Jan 2015.xlsx", sheet = "Stock", startRow = 4, endCol = 5)

library(readxl)

STOCKS <- read_excel(path = "YAHOO/Yahoo Ticker Symbols - Jan 2015.xlsx", sheet = "Stock", skip = 3)

STOCKS <- STOCKS[!is.na(STOCKS$Exchange) & STOCKS$Exchange == "ASX",1:5]

colnames(STOCKS) <- make.names(colnames(STOCKS))
# 
# # The category number refers to the Yahoo Finance category number (look at https://biz.yahoo.com/ic/ind_index.html)
# 
# library(rvest)
# library(plyr)
# 
# CAT_HTML <- html("YAHOO/Industry Index By Alphabetical Order_ Industry Center - Yahoo Finance.html")
# CAT_COL1 <- html_nodes(CAT_HTML, xpath = "//td//td//td//td")
# 
# CAT_NUM <- as.integer(sub(".*/([0-9]{3}).html", "\\1", unlist(html_nodes(CAT_COL1[[1]], xpath = "//td//td//td//td//a//@href"))))
# CAT_NAME <- sub("\\s", " ", html_text(CAT_COL1, trim = TRUE))
# 
# CAT_LKUP <- data.frame(CAT_NUM = as.numeric(CAT_NUM), CAT_NAME = CAT_NAME)

BASE <- "http://real-chart.finance.yahoo.com/table.csv"

getHistory <- function(STOCK) {
  TO_MONTH <- "d=9"
  TO_DAY <- "e=25"
  TO_YEAR <- "f=2015"
  
  # Daily
  INTERVAL <- "g=d"
  
  # Dividends
  # BASE <- "http://real-chart.finance.yahoo.com/x?"
  # INTERVAL <- "g=v"
  
  FROM_MONTH <- "a=9"
  FROM_DAY <- "b=30"
  FROM_YEAR <- "c=1998"
  
  IGNORE <- "ignore=.csv"
  
  URL <- paste(BASE, paste("s=", STOCK, TO_MONTH, TO_DAY, TO_YEAR, INTERVAL, FROM_MONTH, FROM_DAY, FROM_YEAR, IGNORE, sep = "&"), sep = "?")
  
  download.file(url = URL, destfile = paste0("YAHOO/History-", STOCK, ".csv"))
}

l_ply(STOCKS$Ticker, getHistory)
