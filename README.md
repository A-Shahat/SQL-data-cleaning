This project contains SQL scripts to clean and transform raw housing data. The scripts perform various data manipulation tasks to standardize formats, handle missing values, and prepare the data for further analysis or use.

## Table of Contents

- [Features](#features)
- [Data Source](#data-source)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Data Cleaning Steps](#data-cleaning-steps)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Date Standardization**: Converts and standardizes date formats.
- **Address Population**: Fills in missing property addresses using existing data.
- **Address Parsing**: Splits concatenated address fields into separate address, city, and state columns for both property and owner addresses.
- **Data Transformation**: Changes categorical values for consistency.
- **Duplicate Removal**: Identifies and removes duplicate records.
- **Column Management**: Drops unnecessary columns to streamline the dataset.

## Data Source

The SQL scripts are designed to work with a table named `Nashville Housing Data`. 

## Prerequisites

- A SQL Server environment (or any compatible SQL database) where the `Nashville Housing Data` table is accessible.
- Basic understanding of SQL commands.

## Usage

1.  **Load Data**: Ensure your raw housing data is loaded into a table named `Nashville Housing Data` in your SQL environment.
2.  **Execute Script**: Run the `Housing_Data_Cleanning.sql` script in your SQL client or management studio.


## Data Cleaning Steps

The `Housing_Data_Cleanning.sql` script performs the following operations:

### 1. Standardize Date Format

- Converts the `SaleDate` column to a standard `DATE` format.
- Renames the newly created date column to `SaleDate`.
- Drops the original `SaleDate` column.

### 2. Populate Property Address

- Fills `NULL` values in `PropertyAddress` by joining records with the same `ParcelID` but different `UniqueID`s.

### 3. Breaking out Address into (Address - City)

- Extracts the street address and city from the `PropertyAddress` column.
- Creates new columns `Address` and `City`.
- Drops the original `PropertyAddress` column.

### 4. Breaking out Owner Address into (Address - City - State)

- Parses the `OwnerAddress` column to extract the owner's address, city, and state.
- Creates new columns `Address_owner`, `City_owner`, and `State_owner`.

### 5. Changing SoldAsVacant Column

- Standardizes the `SoldAsVacant` column values from 'Y'/'N' to 'Yes'/'No'.

### 6. Removing Duplicates

- Identifies and removes duplicate rows based on `ParcelID`, `SalePrice`, `SaleDate`, `Address`, and `LegalReference`.

### 7. Deleting Unused Columns

- Removes the `OwnerAddress` and `sale_date` (original) columns from the table.

## Contributing

Feel free to fork this repository, make improvements, and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is open-sourced under the MIT License. See the `LICENSE` file for more details.
