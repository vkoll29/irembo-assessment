CREATE TABLE enriched_sales (
    Sales_Id Int32 NOT NULL,
     Customer_Id INT,
    Customer_FullName String,
    Discount_Amount Nullable(String),
    DueDate Nullable(String),
    Extended_Amount Nullable(String),
    Freight Nullable(String),
    Order_Date Nullable(String),
    Order_Quantity Nullable(String),
    Product_Standard_Cost Nullable(String),
    Revision_Number Nullable(String),
    Sales_Amount Nullable(String),
    Sales_Order_Number Nullable(String),
    SalesTerritoryKey Nullable(String),
    Sales_Territory_Country String,
    Sales_Territory_Region String,
    ShipDate Nullable(String),
    Tax_Amt Nullable(String),
    Total_Product_Cost Nullable(String),
    Unit_Price Nullable(String),
    Unit_Price_Discount_Pct Nullable(String),
    Employee_Id Int32 NOT NULL,
    Employee_Name String
) ENGINE = MergeTree()
ORDER BY Sales_Id
--PARTITION BY toYYYYMM(Order_Date);

CREATE USER Rroot IDENTIFIED BY 'R1234!';

GRANT ALL ON rembo.* TO 'Rroot'@'%' WITH GRANT OPTION;
