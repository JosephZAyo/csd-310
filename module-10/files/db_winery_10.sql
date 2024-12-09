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

-- Inventory Table (no foreign keys yet)
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

-- Distributors Table (no foreign keys yet)
CREATE TABLE IF NOT EXISTS Distributors (
    DistributorID INT AUTO_INCREMENT PRIMARY KEY,
    DistributorName VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255),
    SalesQuota DECIMAL(10, 2)
);

-- Insert records into Distributors table
INSERT INTO Distributors (DistributorID,DistributorName, ContactInfo, SalesQuota)
VALUES
    (1,'Quail Distributing', '684-348-3837', 0),
    (2,'Action Wine + Spirits', '928-345-2726', 0),
    (3,'J&L Wines', '144-563-2004', 0),
    (4,'Springboard Wine Company', '247-753-5623', 0),
    (5,'Pinnacle Imports', '478-555-3346', 0),
    (6,'DNS Wines', '342-556-7783', 0);

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
    (7, 'Maria Costanza', 'Distribution', 5);

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
    (6, 6, 120, 120, 120, 120);

-- Orders Table (no foreign keys yet)
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    OrderStatus VARCHAR(50),
    DistributorID INT,
    WineID INT,
    FOREIGN KEY (WineID) REFERENCES Wines(WineID),
    FOREIGN KEY (DistributorID) REFERENCES Distributors(DistributorID)
);

-- Insert records into Orders Table
INSERT INTO Orders (OrderID, OrderDate, OrderStatus, DistributorID, WineId)
VALUES
    (100, 10/13/2024, FILLED, 1, 2 ),
    (101, 10/15/2024, FILLED, 2, 1),
    (103, 11/11/2024, FILLED, 3, 4),
    (104, 12/1/2024, FILLED, 4, 3),
    (105, 12/7/2024, PENDING, 5, 1),
    (106, 12/8/2024, PENDING, 6, 3);