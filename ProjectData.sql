--Delete existing rows in reverse order of insertion to ensure constraint 
--integrity. Run the following delete statements if re-inserting data.
DELETE FROM Service_Event;
DELETE FROM Room_Assignment;
DELETE FROM Room;
DELETE FROM Reservation;
DELETE FROM Hotel;
DELETE FROM Customer;
--Drop the following sequences if re-inserting data.
DROP SEQUENCE Hotel_PK_Seq;
DROP SEQUENCE Customer_PK_Seq;
DROP SEQUENCE Room_PK_Seq;
DROP SEQUENCE Reservation_PK_Seq;
DROP SEQUENCE Service_Event_PK_Seq;

CREATE SEQUENCE Hotel_PK_Seq
INCREMENT BY 1
START WITH 1;
--(Hotel_ID, Address_Street, Address_City, Address_State, Address_Zipcode, 
--Phone_Number, Is_Sold)
INSERT INTO Hotel VALUES(Hotel_PK_Seq.NEXTVAL, '1739 W Nursery Rd', 
    'Linthicum Heights', 'MD', '21090', '410-694-0808', 'F');
INSERT INTO Hotel VALUES(Hotel_PK_Seq.NEXTVAL, '401 W Pratt St', 'Baltimore', 
    'MD', '21201', '443-573-8700', 'F');
INSERT INTO Hotel VALUES(Hotel_PK_Seq.NEXTVAL, '903 Dulaney Valley Rd', 
    'Towson', 'MD', '21204', '410-321-7400', 'F');
INSERT INTO Hotel VALUES(Hotel_PK_Seq.NEXTVAL, '80 Compromise St' , 'Annapolis', 
    'MD', '21401', '410-268-7555', 'F');
INSERT INTO Hotel VALUES(Hotel_PK_Seq.NEXTVAL, '750 Kearny St', 'San Francisco', 
    'CA', '94108', '415-433-6600', 'F');


CREATE SEQUENCE Customer_PK_Seq
INCREMENT BY 1
START WITH 1;
--(Customer_ID, First_Name, Last_Name, Address_Street, Address_City, 
--Address_State, (Address_Zipcode, Phone_Number, CC_Number, Email_Address)
INSERT INTO Customer VALUES(Customer_PK_Seq.NEXTVAL, 'John', 'Doe', 
    '101 Cramer Terrace', 'Annandale', 'VA', '22000', '320-162-0093', 
    '4184908623156854', 'JohnDoe@gmail.com');
INSERT INTO Customer VALUES(Customer_PK_Seq.NEXTVAL, 'James', 'Kim', 
    '201 Dalaney Rd', 'Houston', 'TX', '77001', '281-123-6426', 
    '4556366231237652', 'JamesKim@yahoo.com');
INSERT INTO Customer VALUES(Customer_PK_Seq.NEXTVAL, 'George', 'Smith', 
    '301 Mermaid Ln', 'Los Angeles', 'CA', '90005', '213-174-0985', 
    '5185892910234571', 'SmithGeorge@outlook.com');
INSERT INTO Customer VALUES(Customer_PK_Seq.NEXTVAL, 'Darren', 'Johnson', 
    '401 Jackson St', 'Chicago', 'IL', '60007', '773-0572-0095', 
    '4885729513641561', 'DarrenJohnson@gmail.com');
INSERT INTO Customer VALUES(Customer_PK_Seq.NEXTVAL, 'Sarah', 'Jones', 
    '501 Cedar Blvd', 'Charlotte', 'NC', '28202', '704-0251-6926', 
    '3786240682902934', 'SarahJones@yahoo.com');

CREATE SEQUENCE Room_PK_Seq
INCREMENT BY 1
START WITH 1;
--(Room_Number, Hotel_Id, Room_Type, Room_Base_Cost)
INSERT INTO ROOM VALUES(Room_PK_Seq.NEXTVAL, 1, 'single-room', 102.69);
INSERT INTO ROOM VALUES(Room_PK_Seq.NEXTVAL, 1, 'luxury-suite', 152.25);
ALTER SEQUENCE Room_PK_Seq INCREMENT BY -1;
INSERT INTO ROOM VALUES(Room_PK_Seq.NEXTVAL, 2, 'double-room', 120.58);
ALTER SEQUENCE Room_PK_Seq INCREMENT BY 1;
INSERT INTO ROOM VALUES(Room_PK_Seq.NEXTVAL, 2, 'single-room', 102.69);
ALTER SEQUENCE Room_PK_Seq INCREMENT BY -1;
INSERT INTO ROOM VALUES(Room_PK_Seq.NEXTVAL, 3, 'double-room', 120.58);
ALTER SEQUENCE Room_PK_Seq INCREMENT BY 1;

--See room values.
SELECT * FROM room
ORDER BY hotel_id, room_number;

CREATE SEQUENCE Reservation_PK_Seq
INCREMENT BY 1
START WITH 1;
--(Reservation_ID, Hotel_ID, Customer_ID, Reservation_Date, 
--Earliest_Checkin_Date, Actual_Checkin_Date, Latest_Checkout_Date, 
--Actual_Checkout_Date, Rate_type, Total_Charged, Is_Cancelled)
INSERT INTO Reservation VALUES(Reservation_PK_Seq.NEXTVAL, 1, 2, 
    DATE '2016-11-11', DATE '2017-01-02', DATE '2017-01-02', DATE '2017-01-05', 
    DATE '2017-01-05', 3, 295.26, 'F');
INSERT INTO Reservation VALUES(Reservation_PK_Seq.NEXTVAL, 4, 1, 
    DATE '2018-03-18', DATE '2018-10-18', DATE '2018-03-10', DATE '2018-03-17', 
    DATE '2018-03-20', 1, 1090.22, 'F');
INSERT INTO Reservation VALUES(Reservation_PK_Seq.NEXTVAL, 3, 3, 
    DATE '2019-08-02', DATE '2019-09-06', DATE '2019-09-08', DATE '2019-09-15', 
    DATE '2019-09-15', 2, 1021.96, 'F');
INSERT INTO Reservation VALUES(Reservation_PK_Seq.NEXTVAL, 5, 4, 
    DATE '2020-05-10', DATE '2020-05-23', DATE '2020-05-20', DATE '2020-05-27', 
    DATE '2020-05-29', 2, 0, 'T');
INSERT INTO Reservation VALUES(Reservation_PK_Seq.NEXTVAL, 2, 5, 
    DATE '2021-06-02', DATE '2021-06-02', DATE '2021-06-02', DATE '2021-06-05', 
    DATE '2021-06-05', 3, 376.74, 'F');

--(Room_Number, Hotel_ID, Reservation_ID)
INSERT INTO Room_Assignment VALUES(1, 1, 1);
INSERT INTO Room_Assignment VALUES(2, 1, 2);
INSERT INTO Room_Assignment VALUES(1, 2, 3);
INSERT INTO Room_Assignment VALUES(2, 2, 4);
INSERT INTO Room_Assignment VALUES(1, 3, 5);

CREATE SEQUENCE Service_Event_PK_Seq
INCREMENT BY 1
START WITH 1;
--(Service_Event_ID, Reservation_ID, Service_Type, Service_Cost, Service_Date)
--Types: 'restaurant meal': $20, 'pay-per-view movie': $5, 'laundry': $10
INSERT INTO Service_Event VALUES(Service_Event_PK_Seq.NEXTVAL, 1, 
    'restaurant meal', 20, DATE '2017-01-03');
INSERT INTO Service_Event VALUES(Service_Event_PK_Seq.NEXTVAL, 2, 
    'pay-per-view movie', 5, DATE '2018-03-15');
INSERT INTO Service_Event VALUES(Service_Event_PK_Seq.NEXTVAL, 2, 'laundry', 10, 
    DATE '2019-09-10');
INSERT INTO Service_Event VALUES(Service_Event_PK_Seq.NEXTVAL, 3, 
    'pay-per-view movie', 5, DATE '2021-06-02');
INSERT INTO Service_Event VALUES(Service_Event_PK_Seq.NEXTVAL, 4, 'laundry', 10, 
    DATE '2021-06-03');
