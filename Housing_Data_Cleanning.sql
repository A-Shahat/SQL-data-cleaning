SELECT *
FROM Housing_data;

--Standarize date format
ALTER TABLE Housing_data
ADD sale_date DATE;

UPDATE Housing_data
SET sale_date = CONVERT(DATE, SaleDate);

ALTER TABLE Housing_data DROP COLUMN SaleDate;

EXEC sp_rename 'Housing_data.sale_date', 'SaleDate', 'COLUMN';

SELECT 
    SaleDate
FROM 
    Housing_data;

--Populate Property Address
SELECT 
     a.ParcelID,b.ParcelID,
     a.PropertyAddress,b.PropertyAddress,
     ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM
     Housing_data a
JOIN
     Housing_data b
ON
     a.ParcelID=b.ParcelID AND
     a.[UniqueID ]<>b.[UniqueID ]
WHERE
     a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM
     Housing_data a
JOIN
     Housing_data b
ON
     a.ParcelID=b.ParcelID AND
     a.[UniqueID ]<>b.[UniqueID ]
WHERE
     a.PropertyAddress IS NULL;

--Breaking out Adress into (Address - City)
SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM
     Housing_data;

ALTER TABLE Housing_data
ADD 
    Address Nvarchar (255),
    City Nvarchar (255);

UPDATE Housing_data
SET 
Address  = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

ALTER TABLE Housing_data DROP COLUMN PropertyAddress;

--Breaking out Owner Adress into (Address - City - State)
SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS Address_owner
,PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS City_owner
,PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS State_owner
FROM
    Housing_data;

ALTER TABLE Housing_data
ADD 
    Address_owner Nvarchar (255),
    City_owner Nvarchar (255),
    State_owner Nvarchar (255);

UPDATE Housing_data
SET 
Address_owner  = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
City_owner = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
State_owner = PARSENAME(REPLACE(OwnerAddress,',','.'),1);

--Changing SoldAsVaccant column
SELECT 
     SoldAsVacant,
CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END
FROM
    Housing_data;

UPDATE Housing_data
SET SoldAsVacant=
CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END
FROM
    Housing_data;

--Removing Duplicates
WITH Duplicate_CTE AS
(
SELECT*,
ROW_NUMBER() OVER
(
PARTITION BY 
             ParcelID,
             SalePrice,
             SaleDate,
             Address,
             legalReference
ORDER BY
             uniqueID
) Row_num
FROM
           Housing_data
)
DELETE 
FROM Duplicate_CTE
WHERE Row_num>1;

--Deleting unused columns
ALTER TABLE Housing_data DROP COLUMN OwnerAddress,sale_date;





