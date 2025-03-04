-- Silhouette Collective data mart build script.
-- Published November 2024.

-- Create the database.

IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE NAME = N'SilhouetteCollectiveDM')
	CREATE DATABASE SilhouetteCollectiveDM
GO

-- Switch to the new database.

USE SilhouetteCollectiveDM

-- Drop the tables.

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'FactPurchase'
       )
	DROP TABLE FactPurchase;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimEventType'
       )
	DROP TABLE DimEventType;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimItem'
       )
	DROP TABLE DimItem;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimShopper'
       )
	DROP TABLE DimShopper;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimCustomer'
       )
	DROP TABLE DimCustomer;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimDate'
       )
	DROP TABLE DimDate;

-- Create the tables.

CREATE TABLE DimDate (
	Date_SK				INT CONSTRAINT pk_date_key PRIMARY KEY, 
	Date				DATE,
	FullDate			NCHAR(10), -- Date in MM-DD-YYYY format
	DayOfMonth			INT, -- Day number of Month
	DayName				NVARCHAR(9), -- Monday, Tuesday, etc. 
	DayOfWeek			INT, -- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth	INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear		INT,
	DayOfQuarter		INT,
	DayOfYear			INT,
	WeekOfMonth			INT,-- Week Number of Month 
	WeekOfQuarter		INT, -- Week Number of the Quarter
	WeekOfYear			INT,-- Week Number of the Year
	Month				INT, -- Number of the Month 1 to 12.
	MonthName			NVARCHAR(9), -- January, February etc.
	MonthOfQuarter		INT, -- Month Number belongs to Quarter
	Quarter				NCHAR(2),
	QuarterName			NCHAR(2), -- First,Second..
	Year				INT, -- Year value of Date stored in Row
	CYearName			NCHAR(7), -- CY 2017,CY 2018
	FYearName			NCHAR(7), -- CY 2017,CY 2018
	MonthYear			NCHAR(10), -- Jan-2018,Feb-2018
	MMYYYY				INT,
	FirstDayOfMonth		DATE,
	LastDayOfMonth		DATE,
	FirstDayOfQuarter	DATE,
	LastDayOfQuarter	DATE,
	FirstDayOfYear		DATE,
	LastDayOfYear		DATE,
	IsWeekday			BIT, -- 0=Weekend ,1=Weekday,
	IsWeekdayName		NVARCHAR(55), -- Weekend, Weekday
	IsHoliday			BIT, -- 1=National Holiday, 0-Not a National Holiday
	IsHolidayName		NVARCHAR(55), -- National Holiday or Not a National Holiday
	Holiday				NVARCHAR(55), --Name of Holiday in US
	Season				INT, --Number of season 1 (Fall to Summer)
	SeasonName			NVARCHAR(10)
	);

CREATE TABLE DimCustomer (
	Customer_SK			INT IDENTITY CONSTRAINT pk_customer_key PRIMARY KEY,
	Customer_BK			INT NOT NULL,
	FirstName			NVARCHAR(55) NOT NULL,
	LastName			NVARCHAR(55) NOT NULL,
	LFName				NVARCHAR(125) NOT NULL,
	FLName				NVARCHAR(125) NOT NULL,
	City				NVARCHAR(55) NOT NULL,
	[State]				NVARCHAR(55) NOT NULL,
	Region				NVARCHAR(55) NOT NULL,
	Gender				NVARCHAR(55) NULL,
	AgeGroup			NVARCHAR(55) NOT NULL,
	Generation			NVARCHAR(55) NOT NULL
	);

CREATE TABLE DimShopper (
	Shopper_SK			INT IDENTITY CONSTRAINT pk_shopper_key PRIMARY KEY,
	Shopper_BK			INT NOT NULL,
	FirstName			NVARCHAR(55) NOT NULL,
	LastName			NVARCHAR(55) NOT NULL,
	LFName				NVARCHAR(125) NOT NULL,
	FLName				NVARCHAR(125) NOT NULL,
	City				NVARCHAR(55) NOT NULL,
	[State]				NVARCHAR(55) NOT NULL,
	Region				NVARCHAR(55) NOT NULL,
	Gender				NVARCHAR(55) NULL,
	AgeGroup			NVARCHAR(55) NOT NULL,
	Generation			NVARCHAR(55) NOT NULL
	);

CREATE TABLE DimItem (
	Item_SK				INT IDENTITY CONSTRAINT pk_product_key PRIMARY KEY,
	Item_BK				INT NOT NULL,
	Item				NVARCHAR(55) NOT NULL,
	Color				NVARCHAR(55) NOT NULL,
	Brand				NVARCHAR(55) NOT NULL,
	);

CREATE TABLE DimEventType (
	EventType_SK		INT IDENTITY CONSTRAINT pk_event_type_key PRIMARY KEY,
	EventType_BK		INT NOT NULL,
	EventType			NVARCHAR(55) NOT NULL
	);

CREATE TABLE FactPurchase
	(
	PurchaseID			INT NOT NULL,
	PurchaseItemID		INT NOT NULL,
	PurchaseDate		INT CONSTRAINT fk_order_date_key FOREIGN KEY REFERENCES DimDate(Date_SK),
	Customer_SK			INT CONSTRAINT fk_customer_key FOREIGN KEY REFERENCES DimCustomer(Customer_SK),
	Shopper_SK			INT CONSTRAINT fk_shopper_key FOREIGN KEY REFERENCES DimShopper(Shopper_SK),
	Item_SK				INT CONSTRAINT fk_product_key FOREIGN KEY REFERENCES DimItem(Item_SK), 
	EventType_SK		INT CONSTRAINT fk_gift_type_key FOREIGN KEY REFERENCES DimEventType(EventType_SK),
	ItemPrice			MONEY NOT NULL,
	ItemCost			MONEY NOT NULL,
	ItemProfit			MONEY NOT NULL,
	Quantity			INT NOT NULL, 
	Revenue				MONEY NOT NULL,
	Cost				MONEY NOT NULL,
	Profit				MONEY NOT NULL,
	CONSTRAINT pk_fact_order_key PRIMARY KEY(PurchaseID, PurchaseItemID, PurchaseDate, Customer_SK, Shopper_SK, Item_SK, EventType_SK)
);