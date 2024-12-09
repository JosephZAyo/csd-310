# Miles Shinsato
# Nardos Gebremedhin
# Jessica Long-Heinicke
# Joseph Ayo
# Adrian Marquez


# Import Statements
import mysql.connector
from mysql.connector import errorcode
from tabulate import tabulate

config = {
    "user": "root",
    "password": "Copper!12",
    "host": "127.0.0.1",
    "database": "winerycase",
    "raise_on_warnings": True
}

try:
    db = mysql.connector.connect(**config)
    print(f"Database user {config['user']} connected to MySQL on host {config['host']} with database {config['database']}\n")

    cursor = db.cursor()

    # Function to display table data
    def display_table(query, headers, table_name):
        cursor.execute(query)
        rows = cursor.fetchall()
        if not rows:
            print(f"No data found for query: {table_name}\n")
        else:
            print(f"Displaying {table_name} data:\n")
            print(tabulate(rows, headers=headers, tablefmt="fancy_grid"))
            print("\n" + "-" * 60 + "\n")

    # Display data from tables
    display_table("SELECT SupplierID, Name, ContactInfo, DeliverySchedule, PerformanceRating FROM Suppliers",
                  ["SupplierID", "Name", "Contact Info", "Delivery Schedule", "Performance Rating"],
                  "Supplier")
    
    display_table("SELECT ItemID, ItemName, Quantity, ReorderLevel, SupplierID FROM Inventory",
                  ["ItemID", "Item Name", "Quantity", "Reorder Level", "SupplierID"],
                  "Inventory")
    
    display_table("SELECT WineID, WineName, Type, Stock, Price FROM Wines",
                  ["WineID", "Wine Name", "Type", "Stock", "Price"],
                  "Wines")
    
    display_table("SELECT DistributorID, DistributorName, ContactInfo, SalesQuota FROM Distributors",
                  ["DistributorID", "Distributor Name", "Contact Info", "Sales Quota"],
                  "Distributors")
    
    display_table("SELECT EmployeeID, EmployeeName, Role, DepartmentID FROM Employees",
                  ["EmployeeID", "Employee Name", "Role", "DepartmentID"],
                  "Employees")
    
    display_table("SELECT TrackingID, EmployeeID, Quarter1Hours, Quarter2Hours, Quarter3Hours, Quarter4Hours, TotalHours FROM TimeTracking",
                  ["TrackingID", "EmployeeID", "Q1 Hours", "Q2 Hours", "Q3 Hours", "Q4 Hours", "Total Hours"],
                  "TimeTracking")
    
    display_table("SELECT OrderID, OrderDate, OrderStatus, DistributorID, WineID FROM Orders",
                  ["OrderID", "Order Date", "Order Status", "DistributorID", "WineID"],
                  "Orders")

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("The supplied username or password are invalid")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("The specified database does not exist")
    else:
        print(err)

finally:
    if 'db' in locals() and db.is_connected():
        db.close()
        print("Database connection closed.")

''' 
db = None

try:
    db = mysql.connector.connect(**config)

    print("\n Database user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"],
                                                                                      config["database"]))

    input("\n\n Press any key to continue...")

    # Display the data from the Suppliers table
    cursor = db.cursor()
    cursor.execute("SELECT SupplierID, Name, ContactInfo, DeliverySchedule, PerformanceRating FROM Suppliers")
    supplier = cursor.fetchall()

    print("DISPLAYING Suppliers DATA")
    for supplier in supplier:
        try:
            print(f"Supplier ID: {supplier[0]}")
            print(f"Name: {supplier[1]}")
            print(f"Contact Info: {supplier[2]}")
            print(f"Delivery Schedule: {supplier[3]}")
            print(f"Performance Rating: {supplier[4]}")
            print("-" * 20)
        except IndexError:
            print(f"Error: Incomplete data for supplier: {supplier}")
    db.commit()

    # Display the data from the Inventory table
    cursor = db.cursor()
    cursor.execute(f"SELECT * FROM Inventory")
    inventorys = cursor.fetchall()
    print("DISPLAYING Suppliers DATA")
    for Inventory in inventorys:
        print(f"Item ID: {inventorys[0]}\nItem Name: {inventorys[1]}\nQuantity: {inventorys[2]}"
              f"\nReorder Level: {inventorys[3]}\nSupplier ID: {inventorys[4]}\n")
    db.commit()

    # Display the data from the Wines table
    cursor = db.cursor()
    cursor.execute(f"SELECT * FROM Wines")
    wine = cursor.fetchall()
    if not wine:
        print("No data found in Wines table.")
    else:
        print("DISPLAYING Wine DATA:")
        for wines in wines:
            try:
                print(f"Wine ID: {wine[0]}\nWine Name: {wine[1]}\nWine Type: {wine[2]}"
                f"\nStock: {wine[3]}\nPrice: {wine[4]}\n")
            except IndexError:
                print(f"Incomplete data for wine: {wine}")
    db.commit()

    # Display the data from the Distributors table
    cursor = db.cursor()
    cursor.execute(f"SELECT * FROM Distributors")
    distributor = cursor.fetchall()
    print("DISPLAYING Suppliers DATA")
    for Distributors in distributor:
        print(f"Distributor ID: {distributor[0]}\nName: {distributor[1]}\nContact Info: {distributor[2]}"
              f"\nSales Quota: {distributor[3]}")
    db.commit()

    # Display the data from the Orders table
    cursor = db.cursor()
    cursor.execute(f"SELECT * FROM Orders")
    order = cursor.fetchall()
    print("DISPLAYING Suppliers DATA")
    for Orders in order:
        print(f"Order ID: {order[0]}\nOrder Date: {order[1]}\nStatus: {order[2]}"
              f"\nDistributor ID: {order[3]}\nWine ID: {order[4]}\n")
    db.commit()

    # Display the data from the Employees table
    cursor = db.cursor()
    cursor.execute(f"SELECT * FROM Employees")
    employee = cursor.fetchall()
    print("DISPLAYING Suppliers DATA")
    for Employees in employee:
        print(f"Employee ID: {employee[0]}\nName: {employee[1]}\nRole: {employee[2]}"
              f"\nDepartment ID: {employee[3]}")
    db.commit()

    # Display the data from the Departments table
    cursor = db.cursor()
    cursor.execute(f"SELECT * FROM Departments")
    department = cursor.fetchall()
    print("DISPLAYING Suppliers DATA")
    for Departments in department:
        print(f"Department ID: {department[0]}\nDepartment Name: {department[1]}\n")
    db.commit()

    # Display the data from the TimeTracking table
    cursor = db.cursor()
    cursor.execute(f"SELECT * FROM TimeTracking")
    timetrackings = cursor.fetchall()
    print("DISPLAYING TimeTracking DATA")
    for TimeTracking in timetrackings:
        print(f"Time Tracking ID: {timetrackings[0]}\nEmployee ID: {timetrackings[1]}\nClock In: {timetrackings[2]}"
              f"\nClock Out: {timetrackings[3]}\nDate: {timetrackings[4]}\n")
    db.commit()

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("  The supplied username or password are invalid")

    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("  The specified database does not exist")

    else:
        print(err)

finally:
    if db:
        db.close()
'''
