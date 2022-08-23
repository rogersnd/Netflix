# Netflix
An analysis of Netflix stock.

---------------------------------------------------------------------------
"NFLX_1_data.R" Netflix Stock Prices (NFLX), part 1/3
# This code imports live data from Yahoo Finance's website and
#    the data is manipulated through selected analyses on NFLX stocks
#    in the Nasdaq Stock Market, and then are visualized in plots.

# Netflix Stocks over the past year...
# Source link:
#    https://finance.yahoo.com/quote/NFLX/history?p=NFLX
# Data download link:
#    https://query1.finance.yahoo.com/v7/finance/download/NFLX?period1=1629296203&period2=1660832203&interval=1d&events=history&includeAdjustedClose=true

# Daily Returns.
# A daily return is defined as the % change of the closing price between two days.
# We will denote closing price for a Netflix stock on given day, "i", the initial day as P_i, and P_i-1 refers to the closing price for a Netflix stock for day before P_i.

# "Rate of Return", R_i, is defined as:
#    R_i = (P_i - P_i-1)/(P_i-1)
---------------------------------------------------------------------------

---------------------------------------------------------------------------
"NFLX_2_time_series.R" Netflix Stock Prices (NFLX), part 1/3

# This code performs a time series analysis on daily rates of return for Netflix Stock.
#    Also, we will be predicting the next "n2" stock prices & rates of return.
#    (For this simulation, we will be choosing n2 = 25).

# We want to create a large enough sample, an array of dates we call "date2", to  filtering out weekends and holidays observed during the week.
# From this sample, we choose the number of "n2" dates.

# Adequate sample size for array of dates to manipulate "n2" dates
#    from is:    2*(n2) + 9 + 1
#       "2 * (n2)" - if the day is a weekday (keep) or if day is a weekend (omit, about 2/7 of 2 * n2)
#       " + 9"   - each year there are 9 holidays observed during the week (omit up to max. of 9)
#       " + 1"   - begin indexing after last recorded day in data1.

# Holiday dates gathered from: "https://www.nasdaq.com/market-activity/2022-stock-market-holiday-calendar#:~:text=US%20Stock%20Market%20Holidays%20Hours%20%20%20,May%2030%2C%202022%20%206%20more%20rows%20"

# At the end of this code, we identify the highest and lowest future predicted rates of return among the "n2" predicted days and also return the corresponding dates.
---------------------------------------------------------------------------

---------------------------------------------------------------------------
"NFLX_3_shiny_app.R" Netflix Stock Prices (NFLX), part 3/3
# This code pulls all calculated findings on Netflix Stock and are published on an interactive web application, Shiny.
---------------------------------------------------------------------------
