source("SHARES.R")
source("AXJO.R")
source("OPTIONS.R")

library(plyr)
library(tidyr)
library(cowplot)

TOTAL <- ddply(DATA, .(Date), summarise, Open = sum(Open), Close = sum(Close), High = sum(High), Low = sum(Low), Volume = sum(as.numeric(Volume)), Count = length(Code))

TOTAL$Rate <- TOTAL$Volume / TOTAL$Count

PLOT <- gather(TOTAL, Measure, Value, -Date)

ggplot(PLOT, aes(x = as.Date(Date), y = Value / 1e6)) +
  geom_point() +
  scale_x_date(breaks = as.Date(paste((1997:2015), "01", "01", sep = "-")), labels = year) +
  scale_y_continuous(name = "Value (Millions)") +
  facet_wrap(~ Measure, ncol = 2, scales = "free_y") +
  background_grid(major = "xy", minor = "none")

OHLC <- TOTAL[year(TOTAL$Date) %in% 2013:2014, c("Date","Open","High","Low","Close")]

OHLC$Year <- year(OHLC$Date)
OHLC$Qtr <- quarter(OHLC$Date)
OHLC$YDay <- factor(yday(OHLC$Date))

ggplot(OHLC) +
  geom_linerange(aes(x = YDay, ymin = Low, ymax = High), size = 1) +
  geom_linerange(aes(x = YDay, ymin = Open, ymax = Close, colour = Open > Close), size = 3) +
  scale_y_continuous(name = "Amount") +
  scale_colour_manual(values = c("darkgreen", "darkred"), guide = "none") +
  facet_grid(facets =  Year ~ Qtr, scales = "free_x") +
  background_grid(major = "y", minor = "none") +
  theme(axis.text.x = element_text(angle = 90, size = 11, hjust = 1, vjust = 0.5))

ggsave(filename = "Candle.pdf", width = 60, height = 30, units = "cm", scale = 2)
