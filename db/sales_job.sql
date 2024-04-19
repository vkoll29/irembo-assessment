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
) WITH(
    'connector' = 'postgres-cdc',
    'hostname' = 'localhost',
    'port' = '5432',
    'username' = 'irembo_admin',
    'password' = 'Irembo1234!',
    'database-name' = 'rembo',
    'schema-name' = 'public',
    'table-name' = 'sales',
    'slot.name' = 'sales_slot'
);


-- CREATE TABLE enriched_sales(
--     SELECT
-- )