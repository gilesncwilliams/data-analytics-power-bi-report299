# data-analytics-power-bi-report299



## Methods Used to Import Data

### Load and Transform the Orders Table

In the Power Queary Editor:

Used the Split Column feature to separate the date and times from the [Order Date] and [Shipping Date] into their own columns

Apllied a filter to the [Order Date] column to uncheck any rows with null values so they are not imported into the table in Power BI.


### Import and Transform the Products Dimension Table

Used the Remove Duplicates function on the product code to ensure each product code is unique


### Import and Transform the Store Dimension Table

Imported the Stores table from Azure Blob Storage. 
Need to use the Combine Files button in the Power Query Editor to convert and import the data from Stores.csv in the Blob's container to ensure the data imports correctly.
Unnecessary columns that were created during the CSV conversion process were then removed. 

Used Replace Values to correct the errors with with some of the values in the Region column.

### Import and Transform the Customers Dimension Table

Used the Combine and Transform feature to combine the three regional customer csvs and import as one table into Power BI.

Then created a Full Name column by combining the [First Name] and [Last Name] columns