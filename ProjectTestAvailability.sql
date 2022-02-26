SET SERVEROUTPUT ON;
DROP PROCEDURE Num_Available_Rooms_Of_Type;
DROP PROCEDURE Num_Available_Rooms;
DROP PROCEDURE Show_Cancellations;

--###########################################
--SAME INSERT CODE BELOW AS #16 (Specific Hotel Report)
DELETE FROM Service_Event;
DELETE FROM Room_Assignment;
DELETE FROM Room;
DELETE FROM Reservation;
DELETE FROM Hotel;
DELETE FROM Customer;

--Insert records.
INSERT INTO Customer VALUES(1, 'John', 'Doe', '2307 Hilltop Ln', 'Baltimore', 'MD', 
    '21042', '512-684-9856', '5356285351597444', 'johndoe@gmail.com');
INSERT INTO Customer VALUES(2, 'Mary', 'Smith', '1602 Riverside Ct', 'Columbia', 'MD',
    '21835', '423-978-0342', '5178435945815366', 'marysmith@yahoo.com');
INSERT INTO Customer VALUES(3, 'Chris', 'Jones', '3201 Maple Dr', 'Richmond', 'VA', 
    '23230', '612-308-9721', '5569120773421788', 'cjones@aol.com');
    
INSERT INTO Hotel VALUES(1, '9142 Port Ln', 'Seattle', 'WA', '31024', 
    '312-759-8036', 'F');
INSERT INTO Hotel VALUES(2, '3021 Casino Dr', 'Las Vegas', 'NV', '24354', 
    '516-978-4023', 'F');

INSERT INTO Reservation VALUES(1, 1, 1, DATE '2020-11-20', DATE '2021-01-01', 
    DATE '2021-01-01', DATE '2021-01-05', DATE '2021-01-05', 2, 0, 'F');
INSERT INTO Reservation VALUES(2, 1, 2, DATE '2021-01-06', DATE '2021-01-06', 
    DATE '2021-01-06', DATE '2021-01-07', DATE '2021-01-07', 1, 0, 'F');
INSERT INTO Reservation VALUES(3, 1, 2, DATE '2021-01-09', DATE '2021-01-09', 
    DATE '2021-01-09', DATE '2021-01-11', DATE '2021-01-11', 3, 0, 'F');
INSERT INTO Reservation VALUES(4, 2, 3, DATE '2021-01-07', DATE '2021-01-07', 
    DATE '2021-01-07', DATE '2021-01-08', DATE '2021-01-08', 2, 0, 'F');

INSERT INTO Room VALUES(1, 1, 'single-room', 100.00);
INSERT INTO Room VALUES(2, 1, 'single-room', 100.00);
INSERT INTO Room VALUES(3, 1, 'double-room', 200.00);
INSERT INTO Room VALUES(4, 1, 'luxury-suite', 500.00);
INSERT INTO Room VALUES(5, 1, 'conference-room', 400.00);
INSERT INTO Room VALUES(6, 1, 'conference-room', 400.00);
INSERT INTO Room VALUES(1, 2, 'suite', 300.00);
INSERT INTO Room VALUES(2, 2, 'conference-room', 400.00);

INSERT INTO Room_Assignment VALUES(1, 1, 1);
INSERT INTO Room_Assignment VALUES(2, 1, 3);
INSERT INTO Room_Assignment VALUES(3, 1, 1);
INSERT INTO Room_Assignment VALUES(3, 1, 2);
INSERT INTO Room_Assignment VALUES(3, 1, 3);
INSERT INTO Room_Assignment VALUES(1, 2, 4);
INSERT INTO Room_Assignment VALUES(2, 2, 4);

INSERT INTO Service_Event VALUES(1, 1, 'laundry', 10.00, DATE '2021-01-01');
INSERT INTO Service_Event VALUES(2, 2, 'restaurant meal', 20.00, DATE '2021-01-06');
INSERT INTO Service_Event VALUES(3, 2, 'pay-per-view movie', 5.00, DATE '2021-01-06');
INSERT INTO Service_Event VALUES(4, 1, 'laundry', 10.00, DATE '2021-01-04');
INSERT INTO Service_Event VALUES(5, 1, 'pay-per-view movie', 5.00, DATE '2021-01-03');
INSERT INTO Service_Event VALUES(6, 2, 'pay-per-view movie', 5.00, DATE '2021-01-06');
INSERT INTO Service_Event VALUES(7, 4, 'restaurant meal', 20.00, DATE '2021-01-07');
--################################################

--FOR TESTING: show all rooms in all hotels
SELECT Hotel_ID, Room_Number, Room_Type
FROM Room
ORDER BY Hotel_ID, Room_Number;
--FOR COMPARING RESULTS, keep uncommented
--Display all available rooms of all types in all hotels in a date range.
SELECT Hotel_ID, Room_Number, Room_Type 
FROM Room 
WHERE (Hotel_ID, Room_Number) NOT IN
    (SELECT DISTINCT RA.Hotel_ID, RA.Room_Number
    FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
    WHERE RE.Reservation_ID = RA.Reservation_ID
    AND RO.Room_Number = RA.Room_Number
    AND RO.Hotel_ID = RA.Hotel_ID
    AND H.Hotel_ID = RO.Hotel_ID
    AND DATE '2021-01-04' < latest_checkout_date 
    AND DATE '2021-01-06' >= earliest_checkin_date
    AND Is_Sold = 'F'
    AND Is_Cancelled = 'F')
ORDER BY Hotel_ID, Room_Number;

--TEST: Preliminary for #11 query
SELECT Hotel_ID, Room_Number, Room_Type 
FROM Room 
WHERE (Hotel_ID, Room_Number) NOT IN
    (SELECT DISTINCT RA.Hotel_ID, RA.Room_Number
    FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
    WHERE RE.Reservation_ID = RA.Reservation_ID
    AND RO.Room_Number = RA.Room_Number
    AND RO.Hotel_ID = RA.Hotel_ID
    AND H.Hotel_ID = RO.Hotel_ID
    AND DATE '2021-01-04' < latest_checkout_date 
    AND DATE '2021-01-06' >= earliest_checkin_date
    AND Is_Sold = 'F'
    AND Is_Cancelled = 'F')
AND Hotel_ID = 1
AND Room_Type = 'conference-room';

--#11 query, count number of available rooms of a given type in a given hotel
--in a date range.
--SELECT COUNT(Room_Type) 
--FROM Room 
--WHERE (Hotel_ID, Room_Number) NOT IN
--    (SELECT DISTINCT RA.Hotel_ID, RA.Room_Number
--    FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
--    WHERE RE.Reservation_ID = RA.Reservation_ID 
--    AND RO.Room_Number = RA.Room_Number
--    AND RO.Hotel_ID = RA.Hotel_ID
--    AND H.Hotel_ID = RO.Hotel_ID
--    AND DATE '2021-01-04' < latest_checkout_date 
--    AND DATE '2021-01-06' >= earliest_checkin_date
--    AND Is_Sold = 'F'
--    AND Is_Cancelled = 'F')
--AND Hotel_ID = 1
--AND Room_Type = 'conference-room'
--GROUP BY Room_Type;

CREATE OR REPLACE PROCEDURE Num_Available_Rooms_Of_Type(Hotel_ID_Param 
    IN NUMBER, Room_Type_Param IN VARCHAR, Start_Date_Param IN VARCHAR,
    End_Date_Param IN VARCHAR) IS
    Num_Available_Rooms_Loc NUMBER;
BEGIN
    SELECT COUNT(Room_Type) INTO Num_Available_Rooms_Loc
    FROM Room 
    WHERE (Hotel_ID, Room_Number) NOT IN
        (SELECT DISTINCT RA.Hotel_ID, RA.Room_Number
        FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
        WHERE RE.Reservation_ID = RA.Reservation_ID 
        AND RO.Room_Number = RA.Room_Number
        AND RO.Hotel_ID = RA.Hotel_ID
        AND H.Hotel_ID = RO.Hotel_ID
        AND TO_DATE(Start_Date_Param, 'YYYY-MM-DD') < latest_checkout_date 
        AND TO_DATE(End_Date_Param, 'YYYY-MM-DD') >= earliest_checkin_date
        AND Is_Sold = 'F'
        AND Is_Cancelled = 'F')
    AND Hotel_ID = Hotel_ID_Param
    AND Room_Type = Room_Type_Param
    GROUP BY Room_Type;
    
    DBMS_OUTPUT.PUT_LINE('The number of available rooms of type ' || 
        Room_Type_Param || ' in hotel #' || Hotel_ID_Param || ' from dates:');
    DBMS_OUTPUT.PUT_LINE(Start_Date_Param || ' to ' || End_Date_Param);
    DBMS_OUTPUT.PUT_LINE('= ' || Num_Available_Rooms_Loc);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No rooms available of type ' || Room_Type_Param ||
        ' in hotel #' || Hotel_ID_Param || ' from dates:');
        DBMS_OUTPUT.PUT_LINE(Start_Date_Param || ' to ' || End_Date_Param);
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Something went wrong, too many rows.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('A different exception occurred.');
END;
/

BEGIN
--    Num_Available_Rooms_Of_Type(1, 'conference-room', '2021-01-04', 
--        '2021-01-06');
    --No double rooms are available within the below date range, so 
    --NO_DATA_FOUND exception is thrown.
    Num_Available_Rooms_Of_Type(1, 'double-room', '2021-01-04', 
        '2021-01-06');
END;
/

--#12 query, count number of all available rooms in a given hotel in a date range
--SELECT COUNT(Room_Number) 
--FROM Room 
--WHERE (Hotel_ID, Room_Number) NOT IN
--    (SELECT DISTINCT RA.Hotel_ID, RA.Room_Number
--    FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
--    WHERE RE.Reservation_ID = RA.Reservation_ID 
--    AND RO.Room_Number = RA.Room_Number
--    AND RO.Hotel_ID = RA.Hotel_ID
--    AND H.Hotel_ID = RO.Hotel_ID
--    AND DATE '2021-01-04' < latest_checkout_date 
--    AND DATE '2021-01-06' >= earliest_checkin_date
--    AND Is_Sold = 'F'
--    AND Is_Cancelled = 'F')
--AND Hotel_ID = 1;

--Procedure for #12
CREATE OR REPLACE PROCEDURE Num_Available_Rooms(Hotel_ID_Param 
    IN NUMBER, Start_Date_Param IN VARCHAR, End_Date_Param IN VARCHAR) IS
    Num_Available_Rooms_Loc NUMBER;
BEGIN
    SELECT COUNT(Room_Number) INTO Num_Available_Rooms_Loc
    FROM Room 
    WHERE (Hotel_ID, Room_Number) NOT IN
        (SELECT DISTINCT RA.Hotel_ID, RA.Room_Number
        FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
        WHERE RE.Reservation_ID = RA.Reservation_ID 
        AND RO.Room_Number = RA.Room_Number
        AND RO.Hotel_ID = RA.Hotel_ID
        AND H.Hotel_ID = RO.Hotel_ID
        AND TO_DATE(Start_Date_Param, 'YYYY-MM-DD') < latest_checkout_date 
        AND TO_DATE(End_Date_Param, 'YYYY-MM-DD') >= earliest_checkin_date
        AND Is_Sold = 'F'
        AND Is_Cancelled = 'F')
    AND Hotel_ID = Hotel_ID_Param;
    DBMS_OUTPUT.PUT_LINE('The number of available rooms of all types in hotel #' 
        || Hotel_ID_Param || ' from dates:');
    DBMS_OUTPUT.PUT_LINE(Start_Date_Param || ' to ' || End_Date_Param);
    DBMS_OUTPUT.PUT_LINE('= ' || Num_Available_Rooms_Loc);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Something went wrong, no data found.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Something went wrong, too many rows.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('A different exception occurred.');
END;
/

BEGIN
    Num_Available_Rooms(1, '2021-01-04', '2021-01-06');
    --Get number of rooms available for non-existent hotel, 0 correctly returned.
    --Num_Available_Rooms(3, '2021-01-04', '2021-01-06');
END;
/

COMMIT;

--Code for #15
--Cancel reservations 1, 2, and 4
UPDATE Reservation
SET Is_Cancelled = 'T'
WHERE Reservation_ID = 1
OR Reservation_ID = 2
OR Reservation_ID = 4;

--Print all canceled reservations in the hotel management system. 
--Show reservation ID, hotel name, location, guest name, dates
SELECT Reservation_ID, 'Hotel #' || H.Hotel_ID AS Hotel_Name, H.Address_City || 
    ', ' || H.Address_State AS Hotel_Location, First_Name || ' ' || Last_Name 
    AS Guest_Name, Earliest_CHeckin_Date, Latest_Checkout_Date
FROM Reservation RE, Hotel H, Customer C
WHERE H.Hotel_ID = RE.Hotel_ID
AND C.Customer_ID = RE.Customer_ID
AND Is_Cancelled = 'T';

--Print all reservations plus room types associated with them.
SELECT RE.Reservation_ID, 'Hotel #' || RE.Hotel_ID AS Hotel_Name, 
    H.Address_City || ', ' || H.Address_State AS Hotel_Location, 
    First_Name || ' ' || Last_Name AS Guest_Name, Room_Type, Reservation_Date,
    Earliest_Checkin_Date, Latest_Checkout_Date, Is_Cancelled
FROM Reservation RE, Room_Assignment RA, Room RO, Customer C, Hotel H
WHERE RE.Reservation_ID = RA.Reservation_ID
AND RO.Hotel_ID = RA.Hotel_ID
AND RO.Room_Number = RA.Room_Number
AND H.Hotel_ID = RE.Hotel_ID
AND C.Customer_ID = RE.Customer_ID
ORDER BY Reservation_ID;

CREATE OR REPLACE PROCEDURE Show_Cancellations IS
    CURSOR C IS 
        SELECT DISTINCT RE.Reservation_ID, 'Hotel #' || RE.Hotel_ID AS Hotel_Name, 
        H.Address_City || ', ' || H.Address_State AS Hotel_Location, 
        First_Name || ' ' || Last_Name AS Guest_Name, Room_Type,
        Reservation_Date, Earliest_Checkin_Date, Latest_Checkout_Date
        FROM Reservation RE, Room_Assignment RA, Room RO, Customer C, Hotel H
        WHERE RE.Reservation_ID = RA.Reservation_ID
        AND RO.Hotel_ID = RA.Hotel_ID
        AND RO.Room_Number = RA.Room_Number
        AND H.Hotel_ID = RE.Hotel_ID
        AND C.Customer_ID = RE.Customer_ID
        AND Is_Cancelled = 'T'
        ORDER BY Reservation_ID;
    Row_Loc C%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Here is information about all cancellations in the' ||
        ' hotel database:');
    DBMS_OUTPUT.NEW_LINE;
    OPEN C;
    LOOP
        FETCH C INTO Row_Loc;
        EXIT WHEN C%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Reservation ID=' || Row_Loc.Reservation_ID || 
            ', Hotel Name=' || Row_Loc.Hotel_Name || ', Hotel Location=' || 
            Row_Loc.Hotel_Location || ', Guest Name=' || Row_Loc.Guest_Name || 
            ', Room Type=' || Row_Loc.Room_Type); 
        DBMS_OUTPUT.PUT_LINE('        Reservation Date=' || 
            Row_Loc.Reservation_Date || ', Earliest_Checkin_Date=' || 
            Row_Loc.Earliest_Checkin_Date || ', Latest_Checkout_Date=' || 
            Row_Loc.Latest_Checkout_Date);
    END LOOP;
    CLOSE C;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An exception occurred.');
END;
/

BEGIN
    Show_Cancellations;
END;
/

ROLLBACK;