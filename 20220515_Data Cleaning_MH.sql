

/**
			PortfolioProject Data Exploration & Data Cleaning
			Author: Max Harbauer 15.05.2022
**/



Select SaleDate from NashvilleHousing


Select SaleDateConverted, convert(date,SaleDate)
from NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


---This part is just for testing----
		ALTER TABLE NashvilleHousing
		Add SaleDateConverted Date;

		Update NashvilleHousing
		SET SaleDateConverted = CONVERT(Date,SaleDate)



--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address


--Nr1
Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

/*--By the following join, "doublers" at ParceID and PropertyAdress are removed or overwritten*/
--Nr2
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null 


--Nr3
Select 
a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
--Where a.PropertyAddress is null --Remember: If update from Q4 is already done, the where clause tables going to be empty



--Nr4
--Important: By updating of NashvillHousing use the alias---
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


----------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
--Here it is a matter of separating or removing delimiters (here the comma) (At the beginning always look into the columns whether and if yes which delimiters there are)
--Nr1
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

--Nr2
select
	SUBSTRING(PropertyAddress, 1, ---Starting with at first Komma in the Charindex
	CHARINDEX(',', PropertyAddress)) as Adress --Charindex (CharacterIndex)
from NashvilleHousing

---Charindex sucht die Position heraus
--Nr2.1
select
	SUBSTRING(PropertyAddress, 1, 
	CHARINDEX(',', PropertyAddress)) as Adress, 
CHARINDEX(',', PropertyAddress)--- counts entires (letters) until the komma
from NashvilleHousing

--Nr3
select
	SUBSTRING(PropertyAddress, 1, 
	CHARINDEX(',', PropertyAddress)-1) as Adress 
from NashvilleHousing

--Nr4
select
	SUBSTRING(PropertyAddress, 1, 
	CHARINDEX(',', PropertyAddress)-1) as Adress -- Charindex 
	SUBSTRING(PropertyAddress, 1, 
	CHARINDEX(',', PropertyAddress)-1) as Adress
from NashvilleHousing


--Nr5
SELECT
SUBSTRING(PropertyAddress, 1, 
	CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, 
	CHARINDEX(',', PropertyAddress) + 1 , 
	LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


--Nr5.1 ohne Charindex +1 
SELECT
SUBSTRING(PropertyAddress, 1, 
	CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, 
	CHARINDEX(',', PropertyAddress),
	LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

 

---NashvilleHousing Update---
ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProject.dbo.NashvilleHousing
--------------------------------------------------------

---Was ähnliches kann man jetzt bei der OwnerAdress machen---
Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing




Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.NashvilleHousing





--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



Select *
From PortfolioProject.dbo.NashvilleHousing


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Removing Duplicates
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
order by ParcelID



Select *
From PortfolioProject.dbo.NashvilleHousing




WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1--shows all duplicates
Order by PropertyAddress




WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Delete ---deletes all duplicates
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



---Probe
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1--shows all duplicates
Order by PropertyAddress


Select *
From PortfolioProject.dbo.NashvilleHousing


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



/**ALTERNATIVE ideas for improvement**/



-- Convert SaleDate column to the DATE data type
UPDATE NashvilleHousing SET SaleDate = CONVERT(DATE, SaleDate);

-- Populate PropertyAddress column and break it into individual columns
UPDATE nh
SET PropertyAddress = TRIM(LEFT(PropertyAddress, CHARINDEX(',', PropertyAddress) - 1)),
PropertyCity = TRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, CHARINDEX(',', PropertyAddress, CHARINDEX(',', PropertyAddress) + 1) - CHARINDEX(',', PropertyAddress) - 1)),
PropertyState = TRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress, CHARINDEX(',', PropertyAddress) + 1) + 1, LEN(PropertyAddress)))
FROM NashvilleHousing nh;

-- Populate OwnerAddress column and break it into individual columns
UPDATE nh
SET OwnerAddress = REPLACE(OwnerAddress, ' ', ' '),
OwnerSplitAddress = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)),
OwnerSplitCity = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)),
OwnerSplitState = TRIM(PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1))
FROM NashvilleHousing nh;

-- Change Y and N to Yes and No in SoldAsVacant column
UPDATE NashvilleHousing SET SoldAsVacant = CASE SoldAsVacant WHEN 'Y' THEN 'Yes' WHEN 'N' THEN 'No' ELSE SoldAsVacant END;

-- Create an index on the ParcelID column for faster JOINs
CREATE INDEX IX_NashvilleHousing_ParcelID ON NashvilleHousing(ParcelID);

-- Select statement for testing
SELECT ParcelID, SaleDate, PropertyAddress, PropertyCity, PropertyState, OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState, SoldAsVacant
FROM NashvilleHousing;




