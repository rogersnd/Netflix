# Netflix
>*An analysis on Netflix stock*  

---

### 1. NFLX_1_data.R

This code imports live data from Yahoo Finance's website and the data is manipulated through selected analyses on NFLX stocks in the Nasdaq Stock Market, and then are visualized in plots.  

*Note: all libraries needed for this project are included in this R file.*

##### Netflix Stocks over the past year...
  - Source link: [Yahoo Finance](https://finance.yahoo.com/quote/NFLX/history?p=NFLX "Yahoo Finance")
  - Data download link: [Yahoo Finance Data](https://query1.finance.yahoo.com/v7/finance/download/NFLX?period1=1629296203&period2=1660832203&interval=1d&events=history&includeAdjustedClose=true "Yahoo Finance Data")

##### Daily Returns.
A **daily return** is defined as the % change of the closing price between two days.  

We will denote closing price for a Netflix stock on given day, "i", the initial day as P<sub>*i*</sub>, and P<sub>*i-1*</sub> refers to the closing price for a Netflix stock for day before P<sub>*i*</sub>.  

Rate of Return, **R<sub>*i*</sub>**, is defined as:  
    R<sub>*i*</sub> = (P<sub>*i*</sub> - P<sub>*i-1*</sub>) /(P<sub>*i-1*</sub>)  

---

### 2. NFLX_2_time_series.R

This code performs a time series analysis on daily rates of return for Netflix Stock.  

Also, we will be predicting the next ***n<sub>2</sub>*** stock prices' rates of return.  
<<<<<<< HEAD

###### For this simulation, we will be choosing ***n<sub>2</sub>* = 25**.  

We want to create a large enough sample, an array of dates we call **date2**, so that we may filter out weekends and the holidays observed during the work week.  

###### From this sample, we choose **25** *(**n<sub>2</sub>**)* dates from **date2**.  

Adequate sample size for array of dates to manipulate *n<sub>2</sub>* dates from is **2\**n<sub>2</sub>* + 9 + 1**.  
     
  - *2\*n<sub>2</sub>* &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: if the day is a weekday *(keep)* or if day is a weekend *(omit about 2/7 of 2\*n<sub>2</sub>)*.  
=======

###### For this simulation, we will be choosing ***n<sub>2</sub>* = 25**.  

We want to create a large enough sample, an array of dates we call **date2**, so that we may filter out weekends and the holidays observed during the work week.  

###### From this sample, we choose **25** *(**n<sub>2</sub>**)* dates from **date2**.  

Adequate sample size for array of dates to manipulate *n<sub>2</sub>* dates from is **2\**n<sub>2</sub>* + 9 + 1**.  
     
  - *2\*n<sub>2</sub>* &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: if the day is a weekday *(keep)* or if day is a weekend *(omit about 2/7 of 2\*n<sub>2</sub>)*.  
>>>>>>> 04e194bb3bed49457bf295788bcb89842e0bda2a

  - &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*+ 9*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   : each year there are 9 holidays observed during the week *(omit up to max. of 9)*.  

  - &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*+ 1*   : begin indexing after last recorded day in data1.  

###### Holiday dates gathered from [Holidays]("https://www.nasdaq.com/market-activity/2022-stock-market-holiday-calendar#:~:text=US%20Stock%20Market%20Holidays%20Hours%20%20%20,May%2030%2C%202022%20%206%20more%20rows%20" "Holidays").  

At the end of this code, we identify the **highest and lowest future predicted rates of return** among the *n<sub>2</sub>* predicted days and also return the corresponding dates.  

---

### 3. NFLX_3_shiny_app.R  

This code pulls all calculated findings on Netflix Stock and are published on an interactive web application, *Shiny*.  

---
<<<<<<< HEAD
=======

>>>>>>> 04e194bb3bed49457bf295788bcb89842e0bda2a
