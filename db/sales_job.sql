CREATE TABLE Sales(
Sales_Id INT NOT NULL,
CurrencyKey varchar(50) NULL,
CustomerKey varchar(50) NULL,
Discount_Amount varchar(50) NULL,
DueDate varchar(50) NULL,
DueDateKey varchar(50) NULL,
Extended_Amount varchar(50) NULL,
Freight varchar(50) NULL,
Order_Date varchar(50) NULL,
Order_Quantity varchar(50) NULL,
Product_Standard_Cost varchar(50) NULL,
Revision_Number varchar(50) NULL,
Sales_Amount varchar(50) NULL,
Sales_Order_Line_Number varchar(50) NULL,
Sales_Order_Number varchar(50) NULL,
SalesTerritoryKey varchar(50) NULL,
ShipDate varchar(50) NULL,
Tax_Amt varchar(50) NULL,
Total_Product_Cost varchar(50) NULL,
Unit_Price varchar(50) NULL,
Unit_Price_Discount_Pct varchar(50) NULL,
Employee_Id INT NOT NULL,
PRIMARY KEY (Sales_Id) NOT ENFORCED
)WITH (
    'connector' = 'postgres-cdc',
    'hostname' = 'irembopg',
    'port' = '5432',
    'username' = 'irembo_admin',
    'password' = 'Irembo1234!',
    'database-name' = 'rembo',
    'schema-name' = 'public',
    'table-name' = 'Sales',
    'slot.name' = 'sales_slot'
);


CREATE TABLE Customer(
Customer_Id INT NOT NULL,
Last_Name varchar(50) NULL,
Address_Line1 varchar(50) NULL,
Address_Line2 varchar(50) NULL,
Birth_Date varchar(50) NULL,
Age varchar(50) NULL,
Commute_Distance varchar(50) NULL,
Customer_Alternate_Key varchar(50) NULL,
Customer_Key varchar(50) NULL,
Date_First_Purchase varchar(50) NULL,
Email_Address varchar(50) NULL,
English_Education varchar(50) NULL,
English_Occupation varchar(50) NULL,
French_Education varchar(50) NULL,
First_Name varchar(50) NULL,
French_Occupation varchar(50) NULL,
Gender varchar(50) NULL,
House_Owner_Flag varchar(50) NULL,
Marital_Status varchar(50) NULL,
Middle_Name varchar(50) NULL,
Name_Style varchar(50) NULL,
Number_Cars_Owned varchar(50) NULL,
Number_Children_At_Home varchar(50) NULL,
Phone varchar(50) NULL,
Spanish_Education varchar(50) NULL,
Spanish_Occupation varchar(50) NULL,
Suffix varchar(50) NULL,
Title varchar(50) NULL,
Total_Children varchar(50) NULL,
Yearly_Income varchar(50) NULL,
PRIMARY KEY (Customer_Id) NOT ENFORCED
)WITH (
    'connector' = 'postgres-cdc',
    'hostname' = 'irembopg',
    'port' = '5432',
    'username' = 'irembo_admin',
    'password' = 'Irembo1234!',
    'database-name' = 'rembo',
    'schema-name' = 'public',
    'table-name' = 'Customer',
    'slot.name' = 'cust'
);

CREATE TABLE Employee(
Employee_Id INT NOT NULL,
Employee_Name varchar(50) NULL,
Employee_Territory_Region varchar(50) NULL,
PRIMARY KEY (Employee_Id) not enforced
) WITH (
    'connector' = 'postgres-cdc',
    'hostname' = 'irembopg',
    'port' = '5432',
    'username' = 'irembo_admin',
    'password' = 'Irembo1234!',
    'database-name' = 'rembo',
    'schema-name' = 'public',
    'table-name' = 'Employee',
    'slot.name' = 'flink'
);



CREATE TABLE Sales_Territory(
Sales_Territory_Id INT NOT NULL,
Sales_Territory_Country varchar(50) NULL,
Sales_Territory_Region varchar(50) NULL,
Sales_Territory_City varchar(50) NULL,
PRIMARY KEY (Sales_Territory_Id) not enforced
)WITH (
    'connector' = 'postgres-cdc',
    'hostname' = 'irembopg',
    'port' = '5432',
    'username' = 'irembo_admin',
    'password' = 'Irembo1234!',
    'database-name' = 'rembo',
    'schema-name' = 'public',
    'table-name' = 'Sales_Territory',
    'slot.name' = 'sales_territory'
);


CREATE TABLE enriched_sales(
    Sales_Id INT NOT NULL,
    CustomerKey varchar(50),
    Customer_FullName varchar(255), -- Get this as LastName_FirstName from Customer table
    -- CurrencyKey varchar(50) NULL, -- Currency not included because using USD generally
    Discount_Amount varchar(50) NULL,
    DueDate varchar(50) NULL,
    Extended_Amount varchar(50) NULL,
    Freight varchar(50) NULL,
    Order_Date varchar(50) NULL,
    Order_Quantity varchar(50) NULL,
    Product_Standard_Cost varchar(50) NULL,
    Revision_Number varchar(50) NULL,
    Sales_Amount varchar(50) NULL,
    Sales_Order_Number varchar(50) NULL,
    SalesTerritoryKey varchar(50) NULL,
    Sales_Territory_Country varchar(50) NULL, -- Get this from Sales_Territory table
    Sales_Territory_Region varchar(50) NULL, -- Get this from Sales_Territory table
    ShipDate varchar(50) NULL,
    Tax_Amt varchar(50) NULL,
    Total_Product_Cost varchar(50) NULL,
    Unit_Price varchar(50) NULL,
    Unit_Price_Discount_Pct varchar(50) NULL,
    Employee_Id INT NOT NULL,
    Employee_Name varchar(50) NULL -- Get this from Employee table
)  WITH(
        'connector' = 'jdbc',
        'url' = 'jdbc:clickhouse://irembo_ch:9000/rembo',
        'driver' = 'ru.yandex.clickhouse.ClickHouseDriver',
        'table-name' = 'enriched_sales'
);


CREATE TABLE Employees(
Employee_Id INT NOT NULL,
Employee_Name varchar(50) NULL,
Employee_Territory_Region varchar(50) NULL,
PRIMARY KEY (Employee_Id) not enforced
) WITH (
    'connector' = 'jdbc',
   'url' = 'jdbc:postgresql://irembopg:5432/rembo',
   'table-name' = 'Employee',
   'driver' = 'org.postgresql.Driver',
   'username' = 'irembo_admin',
   'password' = 'Irembo1234!'
);
