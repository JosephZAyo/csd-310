-- Group 1
-- Miles Shinsato
-- Nardos Gebremedhin
-- Jessica Long-Heinicke
-- Joseph Ayo
-- Adrian Marquez

-- drop database user if exists
DROP USER IF EXISTS 'winery_user'@'localhost';

-- create movies_user and grant them all privileges to the movies database 
CREATE USER 'winery_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'wine';

-- grant all privileges to the movies database to user movies_user on localhost 
GRANT ALL PRIVILEGES ON winerycase.* TO 'winery_user'@'localhost';

-- Create the database if it doesn't already exist
CREATE DATABASE IF NOT EXISTS winerycase;

-- Use the newly created database
USE winerycase;

-- Departments Table (Create it first to avoid foreign key errors)
CREATE TABLE IF NOT EXISTS Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(255) NOT NULL
);

-- Insert records into Departments table
INSERT INTO Departments (DepartmentName)
VALUES
    ('Owner'),
    ('Marketing'),
    ('Finances and Payroll'),
    ('Production Line'),
    ('Distribution');

-- Suppliers Table (no foreign keys yet)
CREATE TABLE IF NOT EXISTS Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    DeliverySchedule VARCHAR(255),
    PerformanceRating DECIMAL(5, 2)
);

-- Insert records into Suppliers table
INSERT INTO Suppliers (Name, ContactInfo, DeliverySchedule, PerformanceRating)
VALUES
    ('SaxCo', '602-487-3262', '8th, 18th, 28th', 4),
    ('Vermont Wooden Box Co.', '310-238-3998', '5th, 25th', 5),
    ('Midwest Barrel Co.', '420-226-3939', '1st', 3);

-- Supplier Scheduled Delivery vs Actual Delivery
CREATE TABLE IF NOT EXISTS Delivery (
    SupplierID INT,
    ScheduledDelivery DATE,
    ActualDelivery DATE,
    Difference DECIMAL(10, 2) GENERATED ALWAYS AS (
        TIMESTAMPDIFF(SECOND, ScheduledDelivery, ActualDelivery) / 3600
    ) STORED,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Insert records into delivery table
INSERT INTO Delivery (SupplierID, ScheduledDelivery, ActualDelivery)
VALUES
    ('1', '2024-10-13', '2024-10-14'),
    ('1', '2024-10-31', '2024-11-02'),
    ('1', '2024-11-24', '2024-11-29'),
    ('1', '2024-12-01', '2024-12-01'),
    ('2', '2024-10-12', '2024-10-12'),
    ('2', '2024-11-30', '2024-11-29'),
    ('2', '2024-12-05', '2024-12-06'),
    ('3', '2024-10-03', '2024-10-03'),
    ('3', '2024-10-30', '2024-11-01'),
    ('3', '2024-12-01', '2024-12-01'),
    ('3', '2024-12-09', '2024-12-07');


-- Inventory Table
CREATE TABLE IF NOT EXISTS Inventory (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    ItemName VARCHAR(255) NOT NULL,
    Quantity INT,
    ReorderLevel INT,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Insert records into Inventory table
INSERT INTO Inventory (ItemName, Quantity, ReorderLevel, SupplierID)
VALUES
    ('Bottle', 1500, 500, 1),
    ('Cork', 3000, 1000, 1),
    ('Boxes', 50, 30, 2),
    ('Labels', 1000, 500, 2),
    ('Vats', 20, 15, 3),
    ('Tubing', 500, 400, 3);

-- Wines Table (no foreign keys yet)
CREATE TABLE IF NOT EXISTS Wines (
    WineID INT AUTO_INCREMENT PRIMARY KEY,
    WineName VARCHAR(255) NOT NULL,
    Type VARCHAR(50),
    Stock INT,
    Price DECIMAL(10, 2)
);

-- Insert records into Wines table
INSERT INTO Wines (WineID, WineName, Type, Stock, Price)
VALUES
    (1, 'Decoy', 'Merlot', 13, 25),
    (2, 'Barefoot', 'Cabernet', 126, 20),
    (3, 'Christian Moreau', 'Chablis', 45, 286),
    (4, 'Sutter Home', 'Chardonnay', 250, 8);

-- Create WineSales Table
CREATE TABLE IF NOT EXISTS WineSales (
    SalesID INT AUTO_INCREMENT PRIMARY KEY,
    WineID INT,
    Quarter1Sales DECIMAL(10, 2),
    Quarter2Sales DECIMAL(10, 2),
    Quarter3Sales DECIMAL(10, 2),
    Quarter4Sales DECIMAL(10, 2),
    TotalSales DECIMAL(10, 2) GENERATED ALWAYS AS (
        Quarter1Sales + Quarter2Sales + Quarter3Sales + Quarter4Sales
    ) STORED,
    FOREIGN KEY (WineID) REFERENCES Wines(WineID)
);

-- Insert data into WineSales Table
INSERT INTO WineSales (WineID, Quarter1Sales, Quarter2Sales, Quarter3Sales, Quarter4Sales)
VALUES
    (1, 500.00, 450.00, 600.00, 700.00),
    (2, 1200.00, 1100.00, 1300.00, 1250.00),
    (3, 300.00, 350.00, 400.00, 450.00),
    (4, 800.00, 750.00, 700.00, 850.00);

-- Distributors Table (no foreign keys yet)
CREATE TABLE IF NOT EXISTS Distributors (
    DistributorID INT AUTO_INCREMENT PRIMARY KEY,
    DistributorName VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    TotalSold DECIMAL(10, 2)
);

-- Insert records into Distributors table
INSERT INTO Distributors (DistributorID,DistributorName, ContactInfo, TotalSold)
VALUES
    (1,'Quail Distributing', '684-348-3837', 250),
    (2,'Action Wine + Spirits', '928-345-2726', 434),
    (3,'J&L Wines', '144-563-2004', 322),
    (4,'Springboard Wine Company', '247-753-5623', 689),
    (5,'Pinnacle Imports', '478-555-3346', 211),
    (6,'DNS Wines', '342-556-7783', 431);



-- Employees Table (now we have the Departments table created first)
CREATE TABLE IF NOT EXISTS Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeName VARCHAR(255) NOT NULL,
    Role VARCHAR(255) NOT NULL,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Insert records into Employees table (excluding unnamed employees)
INSERT INTO Employees (EmployeeID, EmployeeName, Role, DepartmentID)
VALUES
    (1, 'Stan Bacchus', 'Owner', 1),
    (2, 'Davis Bacchus', 'Owner', 1),
    (3, 'Janet Collins', 'Finances & Payroll', 3),
    (4, 'Roz Murphy', 'Marketing', 2),
    (5, 'Bob Ulrich', 'Assistant (to Roz)', 2),
    (6, 'Henry Doyle', 'Production', 4),
    (7, 'Maria Costanza', 'Distribution', 5),
    (8,'John Doe', 'Production Line Worker', 4),
    (9,'Jane Smith', 'Production Line Worker', 4),
    (10,'Mike Johnson', 'Production Line Worker', 4),
    (11,'Sarah Brown', 'Production Line Worker', 4),
    (12,'Chris Davis', 'Production Line Worker', 4),
    (13,'Emma Wilson', 'Production Line Worker', 4),
    (14,'Liam Martinez', 'Production Line Worker', 4),
    (15,'Olivia Anderson', 'Production Line Worker', 4),
    (16,'Noah Thomas', 'Production Line Worker', 4),
    (17,'Sophia White', 'Production Line Worker', 4),
    (18,'Mason Lee', 'Production Line Worker', 4),
    (19,'Isabella Harris', 'Production Line Worker', 4),
    (20,'Ethan Clark', 'Production Line Worker', 4),
    (21,'Mia Lewis', 'Production Line Worker', 4),
    (22,'Logan Walker', 'Production Line Worker', 4),
    (23,'Amelia Hall', 'Production Line Worker', 4),
    (24,'Lucas Allen', 'Production Line Worker', 4),
    (25,'Charlotte Young', 'Production Line Worker', 4),
    (26,'Benjamin King', 'Production Line Worker', 4),
    (27,'Ava Scott', 'Production Line Worker', 4);

-- TimeTracking Table (now we have the Employees table created first)
CREATE TABLE IF NOT EXISTS TimeTracking (
    TrackingID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    Quarter1Hours DECIMAL(10, 2),
    Quarter2Hours DECIMAL(10, 2),
    Quarter3Hours DECIMAL(10, 2),
    Quarter4Hours DECIMAL(10, 2),
    TotalHours DECIMAL(10, 2) GENERATED ALWAYS AS (
        Quarter1Hours + Quarter2Hours + Quarter3Hours + Quarter4Hours
    ) STORED,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Insert records into TimeTracking table
INSERT INTO TimeTracking (TrackingID, EmployeeID, Quarter1Hours, Quarter2Hours, Quarter3Hours, Quarter4Hours)
VALUES
    (1, 1, 160, 160, 160, 160),
    (2, 2, 160, 160, 160, 160),
    (3, 3, 120, 120, 120, 120),
    (4, 4, 120, 120, 120, 120),
    (5, 5, 160, 160, 160, 160),
    (6, 6, 120, 120, 120, 120),
    (7,7,120,114,111,100),
    (8,8,29,120,111,124),
    (9,9,134,140,120,110),
    (10,10,100,100,100,100),
    (11,11, 122,211,100,200),
    (12,12,122,100,70,180),
    (13,13,100,100,100,100),
    (14,14,122,100,122,122),
    (15,15,100,100,100,100),
    (16,16,129,124,153,123),
    (17,17,120,231,122,200),
    (18,18,129,124,153,123),
    (19,19,129,124,153,123),
    (20,20,129,124,153,123),
    (21,21,129,124,153,123),
    (22,22,129,124,153,123),
    (23,23,129,124,153,123),
    (24,24,129,124,153,123),
    (25,25,129,124,153,123),
    (26,26,129,124,153,123),
    (27,27,129,124,153,123);


-- Orders Table (no foreign keys yet)
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    OrderDate VARCHAR(255),
    OrderStatus VARCHAR(50),
    DistributorID INT,
    WineID INT,
    UnitsSold VARCHAR(255),
    FOREIGN KEY (WineID) REFERENCES Wines(WineID),
    FOREIGN KEY (DistributorID) REFERENCES Distributors(DistributorID)
);

-- Insert records into Orders Table
INSERT INTO Orders (OrderID, OrderDate, OrderStatus, DistributorID, WineId, UnitsSold)
VALUES
    (100, '2024-10-13', 'FILLED', 1, 2, 10 ),
    (101, '2024-10-28', 'FILLED', 2, 1, 5),
    (103, '2024-11-15', 'FILLED', 3, 4, 2),
    (104, '2024-12-04', 'FILLED', 4, 3, 2),
    (105, '2024-12-07', 'PENDING', 5, 1, 8),
    (106, '2024-12-08', 'PENDING', 6, 3,4);