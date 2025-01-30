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

![alt text](<Screenshot 2025-01-30 at 11.48.03.png>)

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

