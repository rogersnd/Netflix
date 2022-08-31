# Author: Noah Rogers
# Netflix Stock Prices (NFLX)

# Install additional libraries (for all three parts)
require(data.table)   # library(data.table)
require(RCurl)        # library(RCurl)
require(randomForest) # library(randomForest)
require(tidyverse)    # library(tidyverse)
require(shiny)        # library(shiny)
require(shinythemes)  # library(shinythemes)
require(png)          # library(png)

link1 <- "https://query1.finance.yahoo.com/v7/finance/download/NFLX?period1=1629296203&period2=1660832203&interval=1d&events=history&includeAdjustedClose=true"
data1 <- read.csv(link1, header = TRUE) # Read in data w/ header row
data1$Date <- as.Date(data1$Date) # Convert all data in col. 1 to class "Date"

n1 <- nrow(data1)       # Note: No values for weekends and holidays observed during the week
oldest1  <- data1[2,1]  #       Date of oldest stock price on file
current1 <- data1[n1,1] # Date of most current stock price on file

# Labels to be used for plots
str1 <- "Stock Prices since"
str2 <- "Rates of Return since"
string1 <- paste(str1, format(oldest1, "%b. %d, %Y"))
string2 <- paste(str2, format(oldest1, "%b. %d, %Y"))
string3 <- paste(str2, format(current1, "%b. %d, %Y"))

# Plot1
plot(data1$Date, data1$Open,                    # Open Price
     type = "l", lwd = 2,
     main = "Netflix Stock Prices Across 12 Months",
     xlab = paste(string1, "to", format(current1, "%b. %d, %Y")),
     ylab = "Stock Price")
lines(data1$Date, data1$High, col = "seagreen") # High Price
lines(data1$Date, data1$Low, col = "deeppink")  # Low Price
lines(data1$Date, data1$Close, col = "gold")    # Close Price
legend(data1$Date[1], data1$Close[1]-50,
       legend = c("Open", "High", "Low", "Close"),
       col = c("black", "seagreen", "deeppink", "gold"),
       lwd = c(2,1,1,1),
       title = "Stock Prices:")
# Netflix Stock Prices have overall significantly reduced Sept. 2021 but is
#    increasing steadily since May 2022.

# Append "data1" with another column: Rate of Return (in %)
# Note: for first observation, set to 0 (no return from day before)
data1$Rate_of_Return[1] <- 0
for(i in 2:n1){
  data1$Rate_of_Return[i] <- ((data1[i,5]-data1[i-1,5])/(data1[i-1,5]))*100}

# Plot2
plot(data1$Date, data1$Rate_of_Return,
     xlab = paste(string2, "to", format(current1, "%b. %d, %Y")),
     ylab = "Rates of Return (in %)",
     main = "Rates of Return Across Days",
     type = "l", lwd = 2)
lines(data1$Date,       # y = 0.00%
      y = rep(0,n1),
      col = "darkgray")
lines(data1$Date,       # Mean Avg. % Rates of Return for all "n1" RoR%'s
      y = rep(mean(data1$Rate_of_Return),n1),
      col = "deeppink")
legend(data1$Date[1], data1$Rate_of_Return[1]-10,
       legend = c("Rates of Return", "y = 0", "y = Mean Avg. RoR"),
       text.width = 70,
       col = c("black", "darkgray", "deeppink"),
       lwd = c(2,1,1), bty = "n",
       title = "Rates of Return:")
# Over time, the mean rates of return is close to zero with two observed spikes
#    in stronger, negative rates of return.

# Plot3: Histogram
hist(data1$Rate_of_Return,
     xlab = "Rates of Return",
     col = "seagreen",
     main = "Hist. for Rates of Return")
# Histogram for the rates of return has a center just below 0% with a skewed left distribution;
#    the spread ranges from a low of below -35% to a high of over 10%; potential outliers.

# Plot4: Boxplot
boxplot(data1$Rate_of_Return,
        xlab = "Daily Rates of Return",
        ylab = "Rates of Return (in %)",
        main = "Boxplot for Rates of Return",
        col = "seagreen",
        horizontal = T)
# Common observations are fat tails as outliers are common in stock analysis
# The boxplot has several outliers, as is expected with stock market
#   rates of return. The rates of return has an overall range of 46.2468 with the median at -0.2104;
#   the minimum value is -35.1166 and the maximum value is 11.1302.

summary1 <- as.data.table(summary(data1))
summary1 <- summary1[43:48,3]
colnames(summary1) <- ""
