--Drop tables in reverse order created.
DROP TABLE Service_Event;
DROP TABLE Room_Assignment;
DROP TABLE Room;
DROP TABLE Reservation;
DROP TABLE Hotel;
DROP TABLE Customer;

CREATE TABLE Customer (
    Customer_ID INT, --in Oracle, INT type is an alias for NUMBER(38)
    First_Name VARCHAR2(20),
    Last_Name VARCHAR2(20),
    Address_Street VARCHAR2(30),
    Address_City VARCHAR2(20),
    Address_State CHAR(2),
    Address_Zipcode CHAR(5),
    Phone_Number VARCHAR2(14),
    CC_Number VARCHAR2(16),
    Email_Address VARCHAR2(40),
    CONSTRAINT Customer_PK PRIMARY KEY (Customer_ID)
);

CREATE TABLE Hotel (
    Hotel_ID INT,
    Address_Street VARCHAR2(30),
    Address_City VARCHAR2(20),
    Address_State CHAR(2),
    Address_Zipcode CHAR(5),
    Phone_Number VARCHAR2(14),
    Is_Sold CHAR(1)
        --Use CHECK to restrict values of attribute to boolean values.
        CHECK (Is_Sold IN ('T', 'F')),
    CONSTRAINT Hotel_PK PRIMARY KEY (Hotel_ID)
);

CREATE TABLE Reservation (
    Reservation_ID INT,
    Hotel_ID INT,
    Customer_ID INT,
    Reservation_Date DATE,
    Earliest_Checkin_Date DATE,
    Actual_Checkin_Date DATE,
    Latest_Checkout_Date DATE,
    Actual_Checkout_Date DATE,
    Rate_Type NUMBER(1)
        CHECK (Rate_Type IN (1, 2, 3)), --Use CHECK to restrict Rate_Type values
    Total_Charged NUMBER(38, 2),
    Is_Cancelled CHAR(1)
        --Use CHECK to restrict values of attribute to boolean values.
        CHECK (Is_Cancelled IN ('T', 'F')),
    CONSTRAINT Reservation_PK PRIMARY KEY (Reservation_ID),
    CONSTRAINT Reservation_Hotel_FK FOREIGN KEY (Hotel_ID)
        REFERENCES Hotel(Hotel_ID)
        --When Hotel row is deleted, delete Reservation child rows as well.
        --https://www.techonthenet.com/oracle/foreign_keys/foreign_delete.php
        ON DELETE CASCADE,
    CONSTRAINT Reservation_Customer_FK FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
        --When Customer row is deleted, delete Reservation child rows as well.
        ON DELETE CASCADE
);

CREATE TABLE Room (
    Room_Number INT,
    Hotel_ID INT,
    Room_Type VARCHAR2(30)
        --Use CHECK to restrict possible values of Room_Type.
        CHECK (Room_Type IN ('single-room', 'double-room',
            'suite', 'luxury-suite', 'conference-room')),
    Room_Base_Cost NUMBER (6, 2),
    CONSTRAINT Room_PK PRIMARY KEY (Room_Number, Hotel_ID),
    CONSTRAINT Room_Hotel_FK FOREIGN KEY (Hotel_ID)
        REFERENCES Hotel(Hotel_ID)
        --When Hotel row is deleted, delete Room child rows as well.
        ON DELETE CASCADE
);

CREATE TABLE Room_Assignment (
    Room_Number INT,
    Hotel_ID INT,
    Reservation_ID INT,
    CONSTRAINT RA_PK PRIMARY KEY (Room_Number, Hotel_ID, Reservation_ID),
    --RA_Room_FK is a composite foreign key that refers to a composite
    --primary key in the Room table.
    CONSTRAINT RA_Room_FK FOREIGN KEY (Room_Number, Hotel_ID)
        REFERENCES Room(Room_Number, Hotel_ID)
        --When Room row is deleted, delete Room_Assignments child rows as well.
        ON DELETE CASCADE,
    CONSTRAINT RA_Reservation_FK FOREIGN KEY (Reservation_ID)
        REFERENCES Reservation(Reservation_ID)
        --When Reservation row is deleted, delete Room_Assignment child rows 
        --as well.
        ON DELETE CASCADE
);

CREATE TABLE Service_Event (
    Service_Event_ID INT,
    Reservation_ID INT,
    Service_Type VARCHAR2(20)
        --Use CHECK to restrict possible values of Service_Event.
        CHECK (Service_Type IN ('restaurant meal', 'pay-per-view movie',
            'laundry')),
    Service_Cost NUMBER(6, 2),
    Service_Date DATE,
    CONSTRAINT SE_PK PRIMARY KEY (Service_Event_ID),
    CONSTRAINT SE_Reservation_FK FOREIGN KEY (Reservation_ID)
        REFERENCES Reservation(Reservation_ID)
        --When Reservation row is deleted, delete child Service_Event rows 
        --as well.
        ON DELETE CASCADE
);
