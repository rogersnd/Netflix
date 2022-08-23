# Author: Noah Rogers
# Netflix Stock Prices (NFLX), part 2/3

n1 <- length(data1$Rate_of_Return)    # number of observations we have
x1 <- 1:n1                            # x1, our index variable

# Create our Design matrix, D1:
D1 <- rep(1, n1)
D1 <- cbind(D1, x1)

# Our Prediction matrix, P1:
n2 <- 25                # The number of predictions we will make; n2 = 25
P1 <- rep(1, n2)
x2 <- n1:(n1+n2-1)      # NOTE: length of x2 must match length of P1
P1 <- cbind(P1, x2)

# For-loop:
for(i in 1:n2){
  D1 <- cbind(D1, #     Design matrix here
              sin(2*pi*x1/52*i), cos(2*pi*x1/52*i))  # x1 seq here
  P1 <- cbind(P1, # Prediction matrix here
              sin(2*pi*x2/52*i), cos(2*pi*x2/52*i))  # x2 seq here
}
# As we add more, the predictions begin to truly fit the model really well
# Note: This is a harmonic regression due to using sin() and cos()


beta1 <- solve(t(D1)%*%D1)%*%t(D1)%*%data1$Rate_of_Return # Values needed for accurate modeling
pred1 <- D1%*%beta1 # Predictions made for n1 *observed values
pred2 <- P1%*%beta1 # Predictions made for n2 *future values

# This trend is rates of return are increasing steadily since May 2022.
# We see the spikes in returns recur every year, as do depressions
# Remember: our regression coefficients are the amplitudes for rates of return

# Residuals easily collected here:
resid1 <- data1$Rate_of_Return - pred1 # residuals: observed - predicted
MSE1 <- mean(resid1^2) # definition of Mean Squares Error
Pred1var <- MSE1*diag(P1%*%solve(t(D1)%*%D1)%*%t(P1))

# Prediction interval bounds: 95% lower and upper confidence level bounds:
LCL1 <- pred2 - 1.96*sqrt(Pred1var)
UCL1 <- pred2 + 1.96*sqrt(Pred1var)

# Dates for predicted values, with given "n2":
#
# We want to create a large enough sample to begin filtering out
#    weekends and holidays observed during the week.
#
# Adequate sample size for array of dates to manipulate "n2" dates
#    from is:    2*(n2) + 9 + 1
#       "2*(n2)" - if the day is a weekday (keep) or if day is a weekend (omit, about 2/7 of 2*n2)
#       " + 9"   - each year there are 9 holidays observed during the week (omit up to max. of 9)
#       " + 1"   - begin indexing after last recorded day in data1.

date2 <- seq(as.Date(data1$Date[n1]+1),
             as.Date(data1$Date[n1]+(n2*2+9)+1), by = 1)

# Filter out Weekends:
date2 <- date2[!weekdays(date2) %in% c("Saturday", "Sunday")]


# Dates gathered from: "https://www.nasdaq.com/market-activity/2022-stock-market-holiday-calendar#:~:text=US%20Stock%20Market%20Holidays%20Hours%20%20%20,May%2030%2C%202022%20%206%20more%20rows%20"
holidays2022 <- as.Date(c("2022-01-17",     # MLK Jr. Day
                          "2022-02-21",     # Pres.'s Day
                          "2022-04-15",     # Good Friday
                          "2022-05-30",     # Memorial Day
                          "2022-06-20",     # Juneteenth
                          "2022-07-04",     # Independence Day
                          "2022-09-05",     # Labor Day
                          "2022-11-24",     # Thx-giving
                          "2022-12-26" ) )  # X-Mas
date2 <- date2[!date2 %in% holidays2022]

# Keep only "n2" values that we wish to predict
date2 <- date2[1:n2]
# All weekends, and Labor Day, are excluded for next n2 = 25 days

pred_last1<- date2[n2] # last predicted day

# Plot5
plot(data1$Date, data1$Rate_of_Return, type = "l",
     xlab = paste(string2, "to", format(pred_last1, "%b. %d, %Y")),
     ylab = "Rates of Return (in %)",
     xlim = c(data1$Date[1], date2[n2]),
     ylim = c(min(data1$Rate_of_Return)-10, max(data1$Rate_of_Return)+10 ),
     main = "Rates of Return Across Days & Pred. Future Days")
lines(data1$Date, pred1, col = "red") # Modeled values for already observed values
lines(date2, pred2, col = "blue", lwd = 2)    # Predicted values for future rates of return
lines(date2, UCL1, col = "purple", lty = 2)   # Predicted 95% upper confidence level bound
lines(date2, LCL1, col = "deeppink", lty = 2) # Predicted 95% lower confidence level bound
legend(data1$Date[1], -10,
       legend = c("Observed Rates of Return",
                  "Modeled Rates of Return",
                  "Predicted Future Rates of Return",
                  "Predicted 95% Upper Conf. Level Bound",
                  "Predicted 95% Lower Conf. Level Bound"),
       col = c("black", "red", "blue", "purple", "deeppink"),
       lty = c(1,1,1,2,2), lwd = c(1,1,2,1,1),
       bty = "n")
# The previous plot extends to all "n2" predicted % rates of return.

# Most recent % rate of return:
RoR_today1 <- data1[n1, 8]

# Plot6: predictions model for future % RoR's:
plot(date2, pred2,      # Next "n2" predicted % RoR's
     xlab = paste(string3, "to", format(pred_last1, "%b. %d, %Y")),
     ylab = "Rates of Return (in %)",
     ylim = c(min(pred2)-5, max(pred2)+5),
     main = "Predicted Rates of Return Across 25 Predicted Days",
     lwd = 2,
     type = "l")
lines(date2, rep(0,length(date2)), # y = 0.00%
      col = "darkgray", lty = 2)
lines(date2, rep(mean(data1$Rate_of_Return),length(date2)), # Mean % RoR across "n1"
      col = "red")
lines(date2, rep(mean(pred2),length(date2)), # Mean % RoR across "n2"
      col = "orange")
legend(date2[1], pred2[1],
       legend = c("Predicted Rates of Return", "y = 0", "y = Observed Mean Avg. RoR", "y = Predicted Mean Avg. RoR"),
       text.width = 5,
       col = c("black", "darkgray", "red", "orange"),
       lwd = c(2,1,1,1,1),
       lty = c(1,2,1,1,1),
       bty = "n")
# Future 25 predicted % rates of return on average is less than previous 253 mean % rate of return

# Our predicted RoR%'s matrix, with actual predictable dates
pred_temp1 <- as.data.frame(cbind(x2, pred2))
colnames(pred_temp1) <- c("Pred._Day", "Pred._RoR%")
class(pred_temp1$Pred._Day) = "Date"
pred_temp1$Pred._Day[1] <- date2[1]
for(i in 2:n2){pred_temp1$Pred._Day[i]<-date2[i]}

# Predicted Max. and Min. RoR%'s and their respective dates
pred_maxRoR1 <- max(pred2)
pred_minRoR1 <- min(pred2)

pred_temp1$Pred._Day <- format(pred_temp1$Pred._Day, "%b. %d, %Y")

pred_maxDate1 <- format(date2[(which.max(pred2))], "%b. %d, %Y")
pred_minDate1 <- format(date2[(which.min(pred2))], "%b. %d, %Y")
