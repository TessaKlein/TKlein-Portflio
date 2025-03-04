-- Silhouette Collective database build script.
-- Published November 2024.

-- Create the database.

IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE NAME = N'SilhouetteCollective')
	CREATE DATABASE SilhouetteCollective
GO

-- Switch to the new database.

USE SilhouetteCollective

-- Drop the existing tables.

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'PurchaseItem'
       )
	DROP TABLE PurchaseItem;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Purchase'
       )
	DROP TABLE Purchase;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Item'
       )
	DROP TABLE Item;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Brand'
       )
	DROP TABLE Brand;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Customer'
       )
	DROP TABLE Customer;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Shopper'
       )
	DROP TABLE Shopper;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Color'
       )
	DROP TABLE Color;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'EventType'
       )
	DROP TABLE EventType;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'State'
       )
	DROP TABLE [State];

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Region'
       )
	DROP TABLE Region;

-- Create the tables.

CREATE TABLE Region (
	RegionCode			NCHAR(2) CONSTRAINT pk_region_code PRIMARY KEY,
	RegionName			NVARCHAR(55) CONSTRAINT nn_region_name NOT NULL
	);

CREATE TABLE [State] (
	StateCode			NCHAR(2) CONSTRAINT pk_state_code PRIMARY KEY,
	StateName			NVARCHAR(55) NOT NULL,
	RegionCode			NCHAR(2) CONSTRAINT fk_state_region FOREIGN KEY REFERENCES Region(RegionCode) NOT NULL
	);

CREATE TABLE EventType (
	EventTypeID			INT IDENTITY CONSTRAINT pk_event_type_id PRIMARY KEY,
	EventType			NVARCHAR(55) NOT NULL
	);

CREATE TABLE Color (
	ColorID				INT IDENTITY CONSTRAINT pk_color_id PRIMARY KEY,
	Color				NVARCHAR(55) NOT NULL
	);

CREATE TABLE Shopper (
	ShopperID			INT IDENTITY CONSTRAINT pk_shopper_id PRIMARY KEY,
	FirstName			NVARCHAR(55) NOT NULL,
	LastName			NVARCHAR(55) NOT NULL,
	Gender				NVARCHAR(1) CONSTRAINT ck_shopper_gender CHECK (Gender IN ('M', 'F', 'N')) NOT NULL,
	Birthdate			DATE NOT NULL,
	StreetAddress		NVARCHAR(55) NOT NULL,
	City				NVARCHAR(55) NOT NULL,
	StateCode			NCHAR(2) CONSTRAINT fk_shopper_state_code FOREIGN KEY REFERENCES [State](StateCode) NOT NULL,
	PostalCode			NVARCHAR(5) NOT NULL,
	Telephone			NVARCHAR(10) NOT NULL,
	Email				NVARCHAR(55) NOT NULL
);

CREATE TABLE Customer (
	CustomerID			INT IDENTITY CONSTRAINT pk_customer_id PRIMARY KEY,
	FirstName			NVARCHAR(55) NOT NULL,
	LastName			NVARCHAR(55) NOT NULL,
	Gender				NVARCHAR(1) CONSTRAINT ck_customer_gender CHECK (Gender IN ('M', 'F', 'N')),
	Birthdate			DATE,
	StreetAddress		NVARCHAR(55),
	City				NVARCHAR(55),
	StateCode			NCHAR(2) CONSTRAINT fk_customer_state_code FOREIGN KEY REFERENCES [State](StateCode),
	PostalCode			NVARCHAR(5),
	Telephone			NVARCHAR(10),
	Email				NVARCHAR(55),
	ColorID				INT CONSTRAINT fk_customer_color FOREIGN KEY REFERENCES Color(ColorID)
	);

CREATE TABLE Brand (
	BrandID				INT IDENTITY CONSTRAINT pk_brand_id PRIMARY KEY,
	Brand				NVARCHAR(55) NOT NULL
	);

CREATE TABLE Item (
	ItemID				INT IDENTITY CONSTRAINT pk_item_id PRIMARY KEY,
	Item				NVARCHAR(55) NOT NULL,
	ColorID				INT CONSTRAINT fk_item_color FOREIGN KEY REFERENCES Color(ColorID),
	BrandID				INT CONSTRAINT fk_item_brand FOREIGN KEY REFERENCES Brand(BrandID),
	Price				MONEY NOT NULL,
	Cost				MONEY NOT NULL
	);

CREATE TABLE Purchase (
	PurchaseID			INT IDENTITY CONSTRAINT pk_purchase_id PRIMARY KEY,
	PurchaseDate		DATE NOT NULL,
	CustomerID			INT CONSTRAINT fk_purchase_customer FOREIGN KEY REFERENCES Customer(CustomerID),
	ShopperID			INT CONSTRAINT fk_purchase_shopper FOREIGN KEY REFERENCES Shopper(ShopperID),
	EventTypeID			INT CONSTRAINT fk_purchase_event FOREIGN KEY REFERENCES EventType(EventTypeID)
	);

CREATE TABLE PurchaseItem (
	PurchaseItemID		INT IDENTITY CONSTRAINT pk_purchase_item_id PRIMARY KEY,
	PurchaseID			INT CONSTRAINT fk_purchase_item_purchase FOREIGN KEY REFERENCES Purchase(PurchaseID),
	ItemID				INT CONSTRAINT fk_purchase_item_item FOREIGN KEY REFERENCES Item(ItemID),
	Quantity			INT NOT NULL
	);

-- Bulk load the data.

BULK INSERT SilhouetteCollective.dbo.Region FROM 'C:\Users\kathr\OneDrive\Desktop\SilhouetteCollective\DM ETL\OLTP\Region.csv'
WITH (
	CHECK_CONSTRAINTS,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

BULK INSERT SilhouetteCollective.dbo.[State] FROM 'C:\Users\kathr\OneDrive\Desktop\SilhouetteCollective\DM ETL\OLTP\State.csv'
WITH (
	CHECK_CONSTRAINTS,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

BULK INSERT SilhouetteCollective.dbo.EventType FROM 'C:\Users\kathr\OneDrive\Desktop\SilhouetteCollective\DM ETL\OLTP\EventType.csv'
WITH (
	CHECK_CONSTRAINTS,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

BULK INSERT SilhouetteCollective.dbo.Color FROM 'C:\Users\kathr\OneDrive\Desktop\SilhouetteCollective\DM ETL\OLTP\Color.csv'
WITH (
	CHECK_CONSTRAINTS,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

BULK INSERT SilhouetteCollective.dbo.Shopper FROM 'C:\Users\kathr\OneDrive\Desktop\SilhouetteCollective\DM ETL\OLTP\Shopper.csv'
WITH (
	CHECK_CONSTRAINTS,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

BULK INSERT SilhouetteCollective.dbo.Customer FROM 'C:\Users\kathr\OneDrive\Desktop\SilhouetteCollective\DM ETL\OLTP\Customer.csv'
WITH (
	CHECK_CONSTRAINTS,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

BULK INSERT SilhouetteCollective.dbo.Brand FROM 'C:\Users\kathr\OneDrive\Desktop\SilhouetteCollective\DM ETL\OLTP\Brand.csv'
WITH (
	CHECK_CONSTRAINTS,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

BULK INSERT SilhouetteCollective.dbo.Item FROM 'C:\Users\kathr\OneDrive\Desktop\SilhouetteCollective\DM ETL\OLTP\Item.csv'
WITH (
	CHECK_CONSTRAINTS,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

BULK INSERT SilhouetteCollective.dbo.Purchase FROM 'C:\Users\kathr\OneDrive\Desktop\SilhouetteCollective\DM ETL\OLTP\Purchase.csv'
WITH (
	CHECK_CONSTRAINTS,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

BULK INSERT SilhouetteCollective.dbo.PurchaseItem FROM 'C:\Users\kathr\OneDrive\Desktop\SilhouetteCollective\DM ETL\OLTP\PurchaseItem.csv'
WITH (
	CHECK_CONSTRAINTS,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

-- Check the record counts for each table.

GO
SET NOCOUNT ON
SELECT 'Brand' AS "Table",		COUNT(*) AS Records	FROM Brand				UNION
SELECT 'Color',					COUNT(*)			FROM Color				UNION
SELECT 'Customer',				COUNT(*)			FROM Customer			UNION
SELECT 'EventType',				COUNT(*)			FROM EventType			UNION
SELECT 'Item',					COUNT(*)			FROM Item				UNION
SELECT 'Purchase',				COUNT(*)			FROM Purchase			UNION
SELECT 'PurchaseItem',			COUNT(*)			FROM PurchaseItem		UNION
SELECT 'Region',				COUNT(*)			FROM Region				UNION
SELECT 'Shopper',				COUNT(*)			FROM Shopper			UNION
SELECT 'State',					COUNT(*)			FROM [State]
SET NOCOUNT OFF
GO