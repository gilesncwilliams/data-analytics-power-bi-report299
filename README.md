# data-analytics-power-bi-report299



## Importing Data: Methods Used

### Load and Transform the Orders Table

Using Power BI's Get Data function, I imported the SQL database from the Azure account.


In the Power Queary Editor:

Used the Split Column feature to separate the date and times from the [Order Date] and [Shipping Date] into their own columns

Apllied a filter to the [Order Date] column to uncheck any rows with null values so they are not imported into the table in Power BI.


### Import and Transform the Products Dimension Table

After importing the CSV using Power BI's data connector, I used the Remove Duplicates function on the product code to ensure each product code is unique, and removed any remaining nulls.


### Import and Transform the Store Dimension Table

Imported the Stores table from Azure Blob Storage. 
Need to use the Combine Files button in the Power Query Editor to convert and import the data from Stores.csv in the Blob's container to ensure the data imports correctly.
Unnecessary columns that were created during the CSV conversion process were then removed. 

Used Replace Values to correct the errors with with some of the values in the Region column.

### Import and Transform the Customers Dimension Table

Used the Combine and Transform feature to combine the three regional customer csvs and import as one table into Power BI.

Then created a Full Name column by combining the [First Name] and [Last Name] columns



## Create the Data Model

### Dates Table

I created the Date table using the below function:

Dates = CALENDAR(MIN(Orders[Order Date]), DATE(2023,12,31))

I had observed that the first order was 01/01/2010, so used the MIN(Orders[Order Date]) function to create the earliest date.
And the last order was in June 2023, and as we needed to include all dates to end of the year containing the latest date in the Orders['Shipping Date'] column, I used the date 31/12/2023 in the function.

The Dates tables was marked as a Date Table in Power BI to enhance filtering later on in the project. 

### Star Schema

Below is a screenshot of the star schema displaying each of the tables and relationships between each. 

![alt text](<README_images_and_gifs/Screenshot 2025-01-30 at 11.48.03.png>)

All the relationships cardinality was one to many in a single direction between the dimension tables and the Orders fact table.

### Measures and Calculated Columns

After creating a dedicated Measures table, the below measures were created, along with their DAX formula:

- Total Orders = COUNTROWS(Orders)

- Total Quantity = SUM(Orders[Product Quantity])

- Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price]))

- Total Profit = SUMX(Orders, (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price])) * Orders[Product Quantity])

- Total Customers = DISTINCTCOUNT(Orders[User ID])

- Revenue YTD = TOTALYTD([Total Revenue], Orders[Order Date])

- Profit YTD = TOTALYTD([Total Profit], Orders[Order Date])



## Creating the Report




### Theme

I used the Sticky Strawberry theme from the Fabri community's theme gallery. To give the report a stylish feel, whilst maintaining a clear overall visual asthetic. 

### The Customer Detail page



Here we have displayed lots of useful info about the business's customers.
These include the visualsdisplaying the total number of unique customers, revenue, a line graph charting the number of customers, and details about the top customers based on revenue.

![alt text](<README_images_and_gifs/Screenshot 2025-01-31 at 14.20.37.png>)

#### Headline Visual Cards

The headline visual cards reflect the values of Total number of customers and average revenue per customer.
These cards will update as the date slicer is adjusted.

#### Summary Donut Charts

These charts display Total customers by County and produict category. 
Using the donut chart to display the share of countries and categories by customer E.g.

 ![alt text](<README_images_and_gifs/Screenshot 2025-01-31 at 14.23.56.png>)

The slices can be colour coded in Power BI's Report view Format Pane and in the Slice / Colurs section

![alt text](<README_images_and_gifs/Screenshot 2025-01-31 at 14.21.33.png>)

With cross-filtering applied, the user can click on each of the years or categories within the donut charts and the visuals across the page will update accordingly. This could be useful if you wanted to see the top customers by product category or average revenue for each category. 

#### Customers Trending Line Chart

USing a line chart to display the increase in customer numbers over time. 

![alt text](<README_images_and_gifs/Screenshot 2025-01-31 at 14.22.32.png>)


The chart can be drilled down into years, quarters and months to display more detailed as required.

We can add a trend line from the format pane like so:

![alt text](<README_images_and_gifs/Screenshot 2025-01-31 at 14.22.03.png>)

Using forecast we can show, based on the existing data the conitinued upward trend of customer numbers.
The forecast displays a 95% confidence amount through ther shaded area around the forecast line.

![alt text](<README_images_and_gifs/Screenshot 2025-01-31 at 14.22.13.png>)


#### Creating Top Customer info

Using the Table visual we can create a top 20 of customers, displaying their full name, revenue and number of orders. The full list of customers was filted using the Top N filter in the Filter pane.

![alt text](<README_images_and_gifs/Screenshot 2025-01-31 at 14.24.03.png>)

We can add data bars to the revenue column using the Cell elements from the format pane

![alt text](<README_images_and_gifs/Screenshot 2025-01-31 at 14.24.46.png>)

Users can click on each of the column headers to sort the table by ascending and desending values.

We also created cards for the Top customer's name, reveue and number of orders. As the card visual is limited to only one data point, I initially used a table visual to display the top cusotmers data before converting to a card to diaplay the single value.


#### Date slider

Finally I added a date slider to allow users to filter the page by year.  This will affect the visuals so for example the Top customer cards and category donut charts will update according the range of years entered in the slider.



### The Executive Summary page

The next task was to create a report page for the high level executive summary of key metric to give an overview of the companies performance.
The page can be filtered by date to allow for narrowing in on the data for different time periods as required.

![alt text](<README_images_and_gifs/Screenshot 2025-02-03 at 12.11.33.png>)


#### Card Visuals for key metrics

![alt text](<README_images_and_gifs/Screenshot 2025-02-03 at 12.25.08.png>)

#### Revenue trending line chart

Similarly to the Customer page, here is displayed a line chart showing the total revenue from 2010 onwards. Included are a trend line and forecasting.


#### Revenue by Country and store type donuts charts

In a similar style to the donut charts on the Customer Page, here we are displaying the showing Total Revenue broken down by the stores' countries and type.

#### Bar Chart of Orders by Product Category

Using the bar chart to display the number of orders per product category. 

![alt text](<README_images_and_gifs/Screenshot 2025-02-03 at 12.20.46.png>)


#### KPIs

Using the PREVIOUSQUARTER DAX function, I created Target revenue, profit and orders measures. These targets, equal to 5% growth in each measure compared to the previous quarter

![alt text](<README_images_and_gifs/Screenshot 2025-02-03 at 12.20.59.png>)


As an example, the DAX formaul for the Target Revenue meaure is:

Target Revenue = 
CALCULATE(
    [Total Revenue],
    PREVIOUSQUARTER('Dates'[Date])
) * 1.05

This Target Revenue measure is used to as the 'target' field in the KPI card, and when the page is filtered on a particular quarter the 3 KPI visuals will update to reflect the peformacne of the quarter compared to its target (a 5% increase from the previous quarter)

How I set the trend axis, Start of Quarter, so the the colours and icons change depending upon the revenue, profit or number of orders performed compared to the target. White is good, red is bad. 
![alt text](<README_images_and_gifs/Screenshot 2025-02-03 at 12.18.08-1.png>)      



#### Cross-filtering

As mentioned above, cross-filtering is enabled on this page so users can click on different quarters in the line graph and the visuals will update accordingly. E.g. by clicking on Q2 2023, the KPI cards will update to show performance for that quarter.

![alt text](<README_images_and_gifs/Screenshot 2025-02-03 at 12.21.55.png>)


### The Product Detail page

THis page is designed to both give to top-line overview of the product category performance and, using the page's slicer toolbar, an in-depth look at product category and which products are performing well. 

![alt text](<README_images_and_gifs/Screenshot 2025-02-04 at 09.47.04.png>)


#### Current Quarter Performance Gauge Visuals

![alt text](<README_images_and_gifs/Screenshot 2025-02-04 at 09.48.32.png>)

Three guage's showing the revenue, profit and orders of the current quarter's performance when compared to a target of the previous quarter's value + 10%.
The guages were set up with the Total Profit as the value and then the 10& Target as the Max value in the guage. 

![alt text](<README_images_and_gifs/Screenshot 2025-02-04 at 09.52.21.png>)

then using conditional formatting to colour the callout value red if the goal had not yet been reached.

![alt text](<README_images_and_gifs/Screenshot 2025-02-04 at 09.52.36.png>)

Finally a filter was added to each of the guages to filter the data just for the current quarter

![alt text](<README_images_and_gifs/Screenshot 2025-02-04 at 09.51.52.png>)



#### Using an Area Chart to display revenue by Product Category

This chart displays how the different product categories have performed over time, allowing the products team to identify any trends from past peformance. Again this chart can be filtered by prodcut category and region using the toolbar slicer or clicking within the graph on different time periods to drill down further, also updating the scatter graph and Top 10 products for that time period.

![alt text](<README_images_and_gifs/Screenshot 2025-02-04 at 09.48.03.png>)


#### Top 10 Perfomring products visual

Using a table to visualise the top 10 products across the business. Displaying the total revenue, total orders and total profit for each product. Again the table will adapt following user selected filtering from the slicer toolbar.

#### Scatter Graph of Quantity Sold vs Profit per item

![alt text](<README_images_and_gifs/Screenshot 2025-02-04 at 09.48.47.png>)


To assist the Product Team in making recommedations for products to the marketing team for a promotional campaign.  icreated a visual that allows them to quickly see which product ranges are both top-selling items and also profitable, and using the slicer (See below) the graph can be filtered by prodcut category and/or country for specific regional targeteed marketing campaigns. 

#### Slicer Toolbar

To manage how the page is filtered, I set up a slicer toobbar that, upon clicking the filter icon in the navigation bar, pop-out out to reveal the slicer options for Country and Product Category so users can easily filter the page to drill down into the data for each product further.

After setting up the slicers on the toolbox, I used Power BI's bookmark feature to take snapshots of the toolbar open and closed and then assigned the corresponding bookmark to the filter button at the top of the navigation bar, and back button on the toolbar to close the toolbar. 

#### Filter state cards

These are designed to keep track of the current slicer filter state of the product page so users can see what is being filted on the page by the slicers in the toolbar.

