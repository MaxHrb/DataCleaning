# DataCleaning

## This small project was done to showcase serveral variations of data cleaning in SQL
### This SQL code is written to modify the NashvilleHousing database, which contains data on housing properties in Nashville. The code appears to be part of a larger data cleaning or data transformation project, and it is performing several operations on the data, including converting date formats, breaking up and reformatting addresses, and changing values in certain fields.

The first part of the code includes two SQL queries that convert the format of the SaleDate field from a non-date format to a date format. The first query selects two columns: the original SaleDate field and a new column created using the CONVERT function to convert the SaleDate field to a date format. The second query updates the SaleDate field in the NashvilleHousing table using the same CONVERT function.

The second part of the code involves breaking up the PropertyAddress field into separate columns for Address, City, and State. This is done using the SUBSTRING function and CHARINDEX function to locate and extract the desired portions of the PropertyAddress field. The code creates three new columns in the NashvilleHousing table for the Address, City, and State components of the property address, and updates the table accordingly.

The third part of the code does something similar with the OwnerAddress field, using the PARSENAME and REPLACE functions to split the OwnerAddress field into separate columns for Address, City, and State. It also creates three new columns in the NashvilleHousing table for these components of the owner address, and updates the table accordingly.

The final part of the code is a query that groups the SoldAsVacant field into unique values and counts the number of occurrences of each value. It is likely a data exploration query to help understand the distribution of values in this field.
