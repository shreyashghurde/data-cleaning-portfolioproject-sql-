/*

Cleaning Data in SQL Queries

*/


Select *
From portfolioproject2.dbo.Sheet1$

---------------------------------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDate, CONVERT(Date,SaleDate)
From portfolioproject2.dbo.Sheet1$


--Update Sheet1$
--SET SaleDate = CONVERT(Date,SaleDate)

--select*
--from portfolioproject2.dbo.Sheet1$

-- If it doesn't Update properly

ALTER TABLE Sheet1$
Add SaleDateConverted Date;

Update Sheet1$
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From portfolioproject2.dbo.Sheet1$
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From portfolioproject2.dbo.Sheet1$ a
JOIN portfolioproject2.dbo.Sheet1$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From portfolioproject2.dbo.Sheet1$ a
JOIN portfolioproject2.dbo.Sheet1$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject2.dbo.Sheet1$
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject2.dbo.Sheet1$


ALTER TABLE sheet1$
Add PropertySplitAddress Nvarchar(255);

Update Sheet1$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update Sheet1$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProject2.dbo.Sheet1$





Select OwnerAddress
From PortfolioProject2.dbo.Sheet1$


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject2.dbo.Sheet1$



ALTER TABLE Sheet1$
Add OwnerSplitAddress Nvarchar(255);

Update Sheet1$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE sheet1$
Add OwnerSplitCity Nvarchar(255);

Update Sheet1$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Sheet1$
Add OwnerSplitState Nvarchar(255);

Update Sheet1$
SET ownerSplitstates = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select OwnerAddress,ownerSplitAddress,ownerSplitcity,ownerSplitstates
From PortfolioProject2.dbo.Sheet1$


--------------------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
From PortfolioProject2.dbo.Sheet1$
group by SoldAsVacant


select SoldAsVacant,
CASE WHEN SoldAsVacant='Y' THEN 'YES'
 WHEN SoldAsVacant='N' THEN 'NO'
 else SoldAsVacant
 end
From PortfolioProject2.dbo.Sheet1$
order by 2

Update Sheet1$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
with row_numCTE as (
select *,ROW_NUMBER() over (PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference ORDER BY UniqueID)row_num
From PortfolioProject2.dbo.Sheet1$
--order by ParcelID
)
delete
from row_numCTE
where row_num>1
--order by PropertyAddress



--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select *
From PortfolioProject2.dbo.Sheet1$

alter table PortfolioProject2.dbo.Sheet1$
DROP COLUMN PropertyAddress,OwnerAddress,TaxDistrict

alter table PortfolioProject2.dbo.Sheet1$
DROP COLUMN SaleDate2,SaleDate,SaleDate21



-------------------------------------------------------------------------------------------------------------------------------------------------------









