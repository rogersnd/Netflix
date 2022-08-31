# Author: Noah Rogers
# Netflix Stock Prices (NFLX), part 3/3

# Define UI
{
ui <- fluidPage(theme = shinytheme("yeti"),
                navbarPage("Netflix Stock Prices (NFLX)",
                           tabPanel("Information",
                                    sidebarPanel(
                                      tags$h3("Number of Netflix stocks collected:"),
                                      n1,
                                      tags$h3("Oldest NFLX Stock Date:"),
                                      format(oldest1, "%b. %d, %Y"),
                                      tags$h3("Most Recent NFLX Stock Date:"),
                                      format(current1, "%b. %d, %Y"),
                                    ), # sidebarPanel
                                    mainPanel(
                                      h1("Netflix Stock Prices"),
                                      plotOutput("plot1"),
                                      tags$h3("Description of Figure:"),
                                      print("Netflix Stock Prices have overall significantly reduced Sept. 2021 but is increasing steadily since May 2022.")
                                    ),
                           ), # Navbar 1, tabPanel
                           tabPanel("Daily Returns",
                                    sidebarPanel(
                                      tags$h3("Definition:"),
                                      print("Daily returns is defined as the percentage change of the closing price between the two days. We will denote closing price for a Netflix stock on given day 'i' since the initial day as P_i, and P_i-1 refers to the closing price for a Netflix stock for its day before.  We will denote 'rate of returns' as R_i and define it as: R_i = (P_i - P_i-1)/(P_i-1)"),
                                    ), #sidebarPanel
                                    mainPanel(
                                      h1("Daily Returns"),
                                      plotOutput("plot2"),
                                      tags$h3("Description of Figure:"),
                                      print("Over time, the mean rates of return is close to zero with two observed spikes in stronger, negative rates of return."),
                                    ),
                           ), # Navbar 2, tabPanel
                           tabPanel("Histogram",
                                    mainPanel(
                                      h1("Histogram"),
                                      plotOutput("plot3"),
                                      tags$h3("Description of Figure:"),
                                      print("Histogram for the rates of return has a center just below 0% with a skewed left distribution; the spread ranges from a low of below -35% to a high of over 10%; potential outliers."),
                                    ),
                           ), # Navbar 3, tabPanel
                           tabPanel("Boxplot",
                                    mainPanel(
                                      h1("Boxplot"),
                                      plotOutput("plot4"),
                                      tags$h3("Description of Figure:"),
                                      print("The boxplot has several outliers, as is expected with stock market rates of return. The rates of return has an overall range of 46.2468 with the median at -0.2104; the minimum value is -35.1166 and the maximum value is 11.1302."),
                                    )
                           ), # Navbar 4, tabPanel
                           tabPanel("Summary",
                                    sidebarPanel(
                                      tags$h3("Items for Summary"),
                                      print("We are interested in obtaining the following values for the Rates of Return: minimum, 1st quartile, median, mean, 3rd quartile, and maximum."),
                                    ), #sidebarPanel
                                    mainPanel(
                                      h1("Summary - Rates of Return"),
                                      uiOutput('matrix1'),
                                    )
                           ), # Navbar 5, tabPanel
                           tabPanel("Time Series",
                                    sidebarPanel(
                                      tags$h3('Predicting Days Onward...'),
                                      paste("We are using our predictions to look forward 25 days from ",format(current1, "%b. %d, %Y")),
                                    ), #sidebarPanel
                                    mainPanel(
                                      h1("Time Series Plot and Prediction Model"),
                                      plotOutput("plot5"),
                                      tags$h3("Description of Figure:"),
                                      print('The previous plot extends to all 25 predicted % rates of return.'),
                                    )
                           ), # Navbar 6, tabPanel
                           tabPanel("Predictions via Times Series Model",
                                    sidebarPanel(
                                      tags$h3("Lowest Predicted rate of returns %:"),
                                      pred_minRoR1,
                                      print("whose predicted date is:"),
                                      pred_minDate1,
                                      tags$h3("Highest Predicted rate of returns %:"),
                                      pred_maxRoR1,
                                      print("whose predicted date is:"),
                                      pred_maxDate1,
                                      tags$h3("Predicted Dates and Rates of Return:"),
                                      uiOutput('matrix2'),
                                    ), #sidebarPanel
                                    mainPanel(
                                      h1("Predictions Model Across 25 Days"),
                                      plotOutput("plot6"),
                                      tags$h3("Description of Figure:"),
                                      print("Future 25 predicted % rates of return on average is less than the previous the mean % rate of return of 253 previous NFLX stock."),
                                    )
                           ), # Navbar 7, tabPanel
                )# navbarPage
               ) # fluidPage
} # End of UI definition

# Define server function
server <- function(input, output, session){
  # OutputPlot1
  output$plot1 <- renderImage({
    # Save the file as temporary
    outfile <- tempfile(fileext='png')

    png(outfile, width = 400, height = 400)
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
    dev.off()

    # Return a list containing the filename
    list(src = outfile,
         alt = "This is alternate text")
  },
  deleteFile = TRUE)

  # OutputPlot2
  output$plot2 <- renderImage({
    # Save the file as temporary
    outfile <- tempfile(fileext='png')

    png(outfile, width = 400, height = 400)
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
    dev.off()

    # Return a list containing the filename
    list(src = outfile,
         alt = "This is alternate text")
  },
  deleteFile = TRUE)

  # OutputPlot3
  output$plot3 <- renderImage({
    # Save the file as temporary
    outfile <- tempfile(fileext='png')

    png(outfile, width = 400, height = 400)
    hist(data1$Rate_of_Return,
         xlab = "Rates of Return",
         col = "seagreen",
         main = "Hist. for Rates of Return")
    dev.off()

    # Return a list containing the filename
    list(src = outfile,
         alt = "This is alternate text")
  },
  deleteFile = TRUE)

  # OutputPlot4
  output$plot4 <- renderImage({
    # Save the file as temporary
    outfile <- tempfile(fileext='png')

    png(outfile, width = 400, height = 400)
    boxplot(data1$Rate_of_Return,
            xlab = "Daily Rates of Return",
            ylab = "Rates of Return (in %)",
            main = "Boxplot for Rates of Return",
            col = "seagreen",
            horizontal = T)
    dev.off()

    # Return a list containing the filename
    list(src = outfile,
         alt = "This is alternate text")
  },
  deleteFile = TRUE)

  # OutputPlot5
  output$plot5 <- renderImage({
    # Save the file as temporary
    outfile <- tempfile(fileext='png')

    png(outfile, width = 400, height = 400)
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
    dev.off()
    # Return a list containing the filename
    list(src = outfile,
         alt = "This is alternate text")
  },
  deleteFile = TRUE)

  # OutputPlot6
  output$plot6 <- renderImage({
    # Save the file as temporary
    outfile <- tempfile(fileext='png')

    png(outfile, width = 500, height = 400)
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
    dev.off()

    # Return a list containing the filename
    list(src = outfile,
         alt = "This is alternate text")
  },
  deleteFile = TRUE)

  # OutputMatrix1
  output$matrix1 <- renderTable({
    matrix <- summary1
    matrix
  })

  # OutputMatrix2
  output$matrix2 <- renderTable({
    matrix <- pred_temp1
    matrix
  })

} # End of server function definition

# Create Shiny object
shinyApp(ui = ui, server = server)
