
CREATE TABLE enriched_sales(
    Sales_Id INT NOT NULL,
    Customer_Id INT,
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
        'connector' = 'clickhouse',
        'url' = 'clickhouse://172.18.0.5:8123',
        'username' = 'Rroot',
        'password' = 'R1234!',
        'database-name' = 'rembo',
        'table-name' = 'enriched_sales'
--         'maxRetryTimes' = '3'
--         'batchSize' = '8000',
--         'flushIntervalMs' = '1000'
--         'ignoreDelete' = 'true',
--         'shardWrite' = 'false',
--         'writeMode' = 'partition',
--         'shardingKey' = 'id'
);


CREATE TABLE Employee(
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
) WITH (
    'connector' = 'jdbc',
   'url' = 'jdbc:postgresql://irembopg:5432/rembo',
   'table-name' = 'Customer',
   'driver' = 'org.postgresql.Driver',
   'username' = 'irembo_admin',
   'password' = 'Irembo1234!'
);

CREATE TABLE Sales_Territory(
    Sales_Territory_Id INT NOT NULL,
    Sales_Territory_Country varchar(50) NULL,
    Sales_Territory_Region varchar(50) NULL,
    Sales_Territory_City varchar(50) NULL,
    PRIMARY KEY (Sales_Territory_Id) not enforced
)WITH (
    'connector' = 'jdbc',
   'url' = 'jdbc:postgresql://irembopg:5432/rembo',
   'table-name' = 'Sales_Territory',
   'driver' = 'org.postgresql.Driver',
   'username' = 'irembo_admin',
   'password' = 'Irembo1234!'
);

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
    'connector' = 'jdbc',
   'url' = 'jdbc:postgresql://irembopg:5432/rembo',
   'table-name' = 'Sales',
   'driver' = 'org.postgresql.Driver',
   'username' = 'irembo_admin',
   'password' = 'Irembo1234!'
);



INSERT INTO enriched_sales

select
    Sales_Id,
--    CustomerKey,
    c.Customer_Id,
    concat(c.First_Name, ' ', c.Last_Name)  Customer_FullName , -- Get this as LastName_FirstName from Customer table
    -- CurrencyKey, -- Currency not included because using USD generally
    Discount_Amount,
    DueDate,
    Extended_Amount,
    Freight,
    Order_Date,
    Order_Quantity,
    Product_Standard_Cost,
    Revision_Number,
    Sales_Amount,
    Sales_Order_Number,
    SalesTerritoryKey,
    Sales_Territory_Country, -- Get this from Sales_Territory table
    Sales_Territory_Region, -- Get this from Sales_Territory table
    ShipDate,
    Tax_Amt,
    Total_Product_Cost,
    Unit_Price,
    Unit_Price_Discount_Pct,
    s.Employee_Id,
    Employee_Name -- Get this from Employee table
 from Sales s
 inner join Customer c on c.Customer_Key  = s.CustomerKey
 inner join Sales_Territory st on st.Sales_Territory_Id = cast(s.SalesTerritoryKey as int)
 inner join Employee e on e.Employee_Id = s.Employee_Id;


/*
 -- Below code implements table Employee with cdc connector but won't work
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
   'slot.name' = 'employee_slot'
 );

  -- customer table
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

 -- Sales_territory

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


 -- test table with fylestem connector
 CREATE TABLE Users(
    id INT NOT NULL,
    first_name varchar(255),
    last_name varchar(255),
    email varchar(255),
    gender varchar(50),
    ip_address varchar(50)
) WITH(
    'connector' = 'filesystem',
    'path' = 'file:///opt/flink/testdata',
     'format' = 'csv',
     'source.monitor-interval' = '1'
     );
 */
