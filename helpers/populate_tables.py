from faker import Faker
import psycopg2
from datetime import date, timedelta
import random
from config import db_creds

fake = Faker()


def _establish_conn():
    user, pw = db_creds["user"], db_creds["password"]
    conn = psycopg2.connect(database="rembo", user=user, password=pw, host="localhost", port="5438")
    return conn


def _get_employee_ids():
    conn = _establish_conn()
    cursor = conn.cursor()
    cursor.execute("SELECT Employee_ID FROM Employee;")
    return [row[0] for row in cursor.fetchall()]


def _get_sales_territory_ids():
    conn = _establish_conn()
    cursor = conn.cursor()
    cursor.execute("SELECT Sales_Territory_ID FROM Sales_Territory;")
    return [row[0] for row in cursor.fetchall()]


def _get_customer_keys():
    conn = _establish_conn()
    cursor = conn.cursor()
    cursor.execute("SELECT Customer_Key FROM Customer;")
    return [row[0] for row in cursor.fetchall()]


# Populate Customers table
def populate_customers():
    conn = _establish_conn()
    cursor = conn.cursor()
    for _ in range(50000):
        last_name = fake.last_name()[:49]
        address_line1 = fake.address()[:49]
        address_line2 = fake.address()[:49]

        age = fake.random_int(min=14, max=90)
        # birth_date = fake.date_of_birth()
        birth_date = date.today() - timedelta(days=age * 365)
        commute_distance = fake.random_number(digits=2)
        customer_alternate_key = fake.uuid4()[:49]
        customer_key = fake.uuid4()[:49]
        date_first_purchase = fake.date_between_dates(date_start=birth_date, date_end=date.today())
        email_address = fake.email()[:49]
        english_education = fake.random_element(elements=("High School", "College", "Graduate Degree"))
        english_occupation = fake.job()[:49]
        french_education = fake.random_element(elements=("High School", "College", "Graduate Degree"))
        first_name = fake.first_name()[:49]
        french_occupation = fake.job()[:49]
        gender = fake.random_element(elements=("Male", "Female"))[:49]
        house_owner_flag = fake.random_element(elements=("Y", "N"))[:49]
        marital_status = fake.random_element(elements=("Single", "Married", "Divorced", "Widowed"))
        middle_name = fake.first_name()[:49]
        name_style = fake.random_element(elements=("Western", "Asian", "Hispanic"))[:49]
        number_cars_owned = fake.random_number(digits=1)
        number_children_at_home = fake.random_number(digits=1)
        phone = fake.phone_number()[:49]
        spanish_education = fake.random_element(elements=("High School", "College", "Graduate Degree"))
        spanish_occupation = fake.job()[:49]
        suffix = fake.suffix()[:49]
        title = fake.prefix()[:49]
        total_children = fake.random_number(digits=1)
        yearly_income = fake.random_number(digits=6)

        # SQL query to insert fake data into the Customer table
        sql = """
            INSERT INTO Customer (Last_Name, Address_Line1, Address_Line2, Birth_Date, Age, Commute_Distance,
                    Customer_Alternate_Key, Customer_Key, Date_First_Purchase, Email_Address, English_Education,
                    English_Occupation, French_Education, First_Name, French_Occupation, Gender, House_Owner_Flag,
                    Marital_Status, Middle_Name, Name_Style, Number_Cars_Owned, Number_Children_At_Home, Phone,
                    Spanish_Education, Spanish_Occupation, Suffix, Title, Total_Children, Yearly_Income)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                            %s, %s, %s, %s, %s, %s)
            """
        cursor.execute(sql, (last_name, address_line1, address_line2, birth_date, age, commute_distance,
                             customer_alternate_key, customer_key, date_first_purchase, email_address,
                             english_education,
                             english_occupation, french_education, first_name, french_occupation, gender,
                             house_owner_flag,
                             marital_status, middle_name, name_style, number_cars_owned, number_children_at_home, phone,
                             spanish_education, spanish_occupation, suffix, title, total_children, yearly_income))

    # Commit the transaction
    conn.commit()

    cursor.close()
    conn.close()

    print("Fake data generation complete.")


def populate_territory():
    conn = _establish_conn()
    cursor = conn.cursor()

    insert_query = """
        INSERT INTO Sales_Territory (Sales_Territory_Country, Sales_Territory_Region, Sales_Territory_City) 
        VALUES ('Uganda', 'Entebbe', 'Entebbe'),
                ('Nigeria', 'Lagos', 'Lagos'),
                ('Mozambique', 'Maputo', 'Maputo'),
                ('Egypt', 'Cairo', 'Cairo'),
                ('UK', 'London', 'London'),
                ('Kenya', 'Nairobi', 'Nairobi'),
                ('Germany', 'North Rhine-Westphalia', 'Cologne'),
                ('France', 'Ile-de-France', 'Paris'),
                ('South Africa', 'Western Cape', 'Cape Town'),
                ('China', 'Beijing', 'Beijing'),
                ('Japan', 'Tokyo', 'Tokyo');
        """
    try:
        cursor.execute(insert_query)
        conn.commit()
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cursor.close()
        conn.close()


def populate_employees():
    conn = _establish_conn()
    cursor = conn.cursor()
    fake = Faker()
    try:
        for _ in range(500):
            employee_name = fake.name()
            employee_territory_region = fake.random_element(
                elements=(
                    "Entebbe",
                    "Lagos",
                    "Maputo",
                    "Cairo",
                    "London",
                    "Nairobi",
                    "North Rhine-Westphalia",
                    "Ile-de-France",
                    "Western Cape",
                    "Beijing",
                    "Tokyo"
                )
            )
            query = """
            INSERT INTO Employee (Employee_Name, Employee_Territory_Region)
            VALUES (%s, %s);
            """
            cursor.execute(query, (employee_name, employee_territory_region))
        conn.commit()
    except Exception as e:
        print(f"Error inserting record: {e}")

    finally:
        cursor.close()
        conn.close()


def populate_sales(num_records):
    conn = _establish_conn()
    cursor = conn.cursor()
    employee_ids = _get_employee_ids()
    sales_territory = _get_sales_territory_ids()
    customer_keys = _get_customer_keys()

    try:
        for _ in range(num_records):
            """
            
            TODO: there is a lot of logic to be considered regarding the data generated here:
            - sales amount and unit price and quantity need to be aligned.
            
            """
            start_date = date.today() - timedelta(days=5 * 365)

            Order_Date = fake.date_between(start_date=start_date, end_date=date.today())
            # logic, just enforcing the generated duedate to not be longer than 60days
            DueDate = fake.date_between(start_date=Order_Date, end_date=(date.today() + timedelta(days=60)))
            #shipment date cannot be in the future
            ShipDate = fake.date_between(start_date=Order_Date, end_date=date.today())
            # CurrencyKey = fake.currency_code()
            CurrencyKey = "USD"  #Making the currency be in USD because I won't have the time to add additional logic for conversion
            CustomerKey = random.choice(customer_keys)
            Discount_Amount = fake.random_number(digits=2)
            DueDateKey = fake.uuid4()
            Extended_Amount = fake.random_number(digits=4)
            Freight = fake.random_number(digits=3)

            Order_Quantity = fake.random_number(digits=2)
            Product_Standard_Cost = fake.random_number(digits=3)
            Revision_Number = fake.random_number(digits=1)
            Sales_Amount = fake.random_number(digits=4)
            Sales_Order_Line_Number = fake.random_number(digits=3)
            Sales_Order_Number = fake.random_number(digits=5)
            SalesTerritoryKey = random.choice(sales_territory)

            Tax_Amt = fake.random_number(digits=3)
            Total_Product_Cost = fake.random_number(digits=4)
            Unit_Price = fake.random_number(digits=3)
            Unit_Price_Discount_Pct = fake.random_number(
                digits=2)  # TODO: Calculate this based on the unit price and discount amount
            Employee_Id = random.choice(employee_ids)

            insert_query = """
                INSERT INTO Sales (CurrencyKey, CustomerKey, Discount_Amount, DueDate, DueDateKey, Extended_Amount, Freight, Order_Date, Order_Quantity, Product_Standard_Cost, Revision_Number, Sales_Amount, Sales_Order_Line_Number, Sales_Order_Number, SalesTerritoryKey, ShipDate, Tax_Amt, Total_Product_Cost, Unit_Price, Unit_Price_Discount_Pct, Employee_Id)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
                """
            cursor.execute(insert_query, (
                CurrencyKey, CustomerKey, Discount_Amount, DueDate, DueDateKey, Extended_Amount, Freight, Order_Date,
                Order_Quantity, Product_Standard_Cost, Revision_Number, Sales_Amount, Sales_Order_Line_Number,
                Sales_Order_Number,
                SalesTerritoryKey, ShipDate, Tax_Amt, Total_Product_Cost, Unit_Price, Unit_Price_Discount_Pct,
                Employee_Id)
                           )

        conn.commit()
    except Exception as e:
        print(f"Error inserting record: {e}")

    finally:
        cursor.close()
        conn.close()
