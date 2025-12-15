# Projects

## Insurance Risk Analysis Dashboard
**Tools:** Tableau, R, Statistical Analysis
Run EDA and hypothesis testing in R and created  an interactive dashboard analyzing insurance premium data to identify key demographic risk factors affecting policy pricing.

**Key Achievements:**
-Analyzed 1338 insurance records
-Identified high-risk customer segements
-Provided actionable recommendations for premium pricing
-Improved risk assessment accuracy through statistical modeling

Here is a visual walkthrough of my tableau Dashboard

![Screenshot 1](/assets/images/Capture.PNG)
![Screenshot 2](/assets/images/capture 1.PNG)
![Screenshot 3](/assets/images/Capture 2.PNG)
![Screenshot 4](/assets/images/Capture 3.PNG)
![Screenshot 5](/assets/images/Capture 4.PNG)
![Screenshot 6](/assets/images/Capture 5.PNG)
![Screenshot 7](/assets/images/Capture 6.PNG)
![Screenshot 8](/assets/images/Capture 7.PNG)

### Project Files

[View R Script](https://github.com/chidozinyakatira/chidozinyakatira/blob/main/Project%201.R)|
[View Dashboard](https://public.tableau.com/views/HealthInsurancedashboard/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) | [Github Repository](#)

---

## Customer Segmentation Dashboard
**Tools:** Tableau, R
# Overview
K-Means clustering analysis to identify distinct customer segments based on spending score
# Key findings
-Identified 6 distinct customer clusters
-Premium Young Professionals show highest spending potential
## Dashboard Features
-Interactive scatter plot visualization
-Cluster specific insights
- Gender based spending analysis
- Summary with key metrics

## Screenshots
Here is a visual walkthrough of my tableau Dashboard

![Screenshot 1](/assets/images/Dashboard1.png)
![Screenshot 2](/assets/images/Dashboard2.png)

## Project Files
[View Dashboard](https://public.tableau.com/views/KmeansClustering_17543408802920/Dashboard2?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
[View R Script](https://github.com/chidozinyakatira/chidozinyakatira/blob/main/Kmeans%20Clustering.R)

---

## Programming Language Popularity forecast

**tools:** Python

# Overview
This project analyzes and forecasts the popularity trends of three major programming languages: C++, Java, and Python using time series forecasting techniques. The analysis employs SARIMA (Seasinal Autoregressive Integrated Moving Average) modeling to predict future popularity bases on historical data patterns.
# Key Methodology

**Data Preprocessing:** Stationarity tests using Adfuller tests and data transformation

**Seasonal Decomposition:** Breaking downtime series into trend, seasonal, and residual components.

**Model Selection:** SARIMA(1,1,1)(1,1,1,52) was chosen for C++ and Python and SARIMA(2,1,1)(1,1,1,52) for Java bases on model diagonostics and performance metrics.

**Validation:** An analysis of residuals was conducted

**Accuracy:** Comparison of 12-week forecasts against actual observed values

# Appropriateness of Model Chosen

Appropriateness of chosen forecasting method
Python
From the plot of fitted data , i see the model captures both the general trend and seasonal fluctuations effectively, the strong alignment between actual and fitted values indicates the model parameters are well calibrated

The plot of residuals shows that residuals fluctuate around zero throughout time period, indicating no systematic bias, The residuals appear to have relatively constant variance

The acf of residuals are approximately shows most values falling the confidence bands, This indicates the residuals are approximately white noise, confirming the model has adequately captured the temporal dependencies

Java
From the plot of fitted data, we see that the fitted values track the original Java data

The residuals fluctuate randomly around zero, this supports model adequacy and suggests the SARIMA model has captured the underlying structure

The acf of residuals shows that there is no significant autocorrelation in residuals, this confirms that the model has adequately the temporal dependencies

model diagonistics support the chosen specification, ACF analysis validates the absence of remaining autocorrelation.

C++
The residual analysis plot shows values oscillating around zero with no clear, indicating good model fit

ACF of residuals: the autocorrelation values fall within confidence bands, confirming residuals are approximately white noise

The fitted vs actual comparison shows the model captures both trend and seasonal variations well

# Project Files
[View my python File](https://github.com/chidozinyakatira/chidozinyakatira/blob/main/_Project%201%20(5).ipynb)

## Online Retail Country Revenue Analysis (Hadoop & R)

 **Project Overview**
This project analyzes sales data from a UK-based online retail company (2009–2011) to evaluate revenue performance across countries. The goal is to support strategic international market expansion decisions using distributed data processing.

**Dataset**

Source: UCI / Kaggle Online Retail II Dataset

Records include invoice numbers, product codes, quantities, prices, and country of shipment.

**Technologies Used**

Hadoop (HDFS)

MapReduce (R)

R (data processing & visualization)

ggplot2

**Methodology**

Loaded raw transactional data into HDFS.

Cleaned data by removing:

Records with null country values

Records with non-positive quantities

Implemented a MapReduce job in R to compute total revenue per country.

Sorted results in descending order to identify top markets.

Visualized the top 5 countries by revenue using a bar chart.

**Key Insights**

Revenue is highly concentrated in a small number of European countries.

Top-performing markets represent strong candidates for further investment.

Lower-performing countries may require targeted marketing or operational review.

**Business Value**
This analysis demonstrates how distributed computing can support data-driven international expansion strategies in retail.

# Screenshots

![Screenshot 1](/assets/images/Hadoop sales by country txt.png)
![Screenshot 2](/assets/images/MapReduce commands.png)
![Screenshot 3](/assests/images/MapReduce success.png)
![Screenshot 4](/assets/Question 1 hdfs commands part 2.png)
![Screenshot 5](/assests/Question 1 hdfs commands.png)
![Screenshot 6](/assets/images/Top5_Countries_Chart.png)

# Project Files
[View my clean data File](https://github.com/chidozinyakatira/chidozinyakatira/blob/main/clean_data.R)
[View my mapper File](https://github.com/chidozinyakatira/chidozinyakatira/blob/main/mapper.R)
[View my Reducer File](https://github.com/chidozinyakatira/chidozinyakatira/blob/main/reducer.R)
[View my visualisation File](https://github.com/chidozinyakatira/chidozinyakatira/blob/main/visualisation.R)

---
  


