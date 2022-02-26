DROP PROCEDURE Num_Available_Rooms_Of_Type;
DROP PROCEDURE Num_Available_Rooms;
DROP PROCEDURE Income_By_Room_Type;
DROP PROCEDURE Services_Income_By_Type;
DROP PROCEDURE Total_Income;
DROP PROCEDURE Specific_Hotel_Report;
DROP PROCEDURE Show_Cancellations;
DROP PROCEDURE Services_Income_By_State;
DROP PROCEDURE Room_Type_Income_By_State;
DROP PROCEDURE TotalHiltonStateReport;

SET SERVEROUTPUT ON;
--#11. Available Rooms at hotel: Input a specific hotel ID a room type and a 
--date interval. Return the number of available rooms of that type during the 
--interval.
--#11 Code
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

--Using the sample data, here are all rooms of all types in all hotels obtained 
--from the following select query:
SELECT Hotel_ID, Room_Number, Room_Type
FROM Room
ORDER BY Hotel_ID, Room_Number;

--Here are all available rooms between the date range given in the procedure call 
--below of all types in all hotels obtained from the following select query:
SELECT Hotel_ID, Room_Number, Room_Type 
FROM Room 
WHERE (Hotel_ID, Room_Number) NOT IN
    (SELECT DISTINCT RA.Hotel_ID, RA.Room_Number
    FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
    WHERE RE.Reservation_ID = RA.Reservation_ID
    AND RO.Room_Number = RA.Room_Number
    AND RO.Hotel_ID = RA.Hotel_ID
    AND H.Hotel_ID = RO.Hotel_ID
    AND DATE '2017-01-07' < latest_checkout_date 
    AND DATE '2017-01-09' >= earliest_checkin_date
    AND Is_Sold = 'F'
    AND Is_Cancelled = 'F')
ORDER BY Hotel_ID, Room_Number;

--The following command produces the following number of 
--available single rooms in hotel 1, which is 2.
EXEC Num_Available_Rooms_Of_Type(1, 'single-room', '2017-01-07', '2017-01-09');

--Here are all available rooms between the date range given in the procedure call 
--below of all types in all hotels obtained from the following select query:
SELECT Hotel_ID, Room_Number, Room_Type 
FROM Room 
WHERE (Hotel_ID, Room_Number) NOT IN
    (SELECT DISTINCT RA.Hotel_ID, RA.Room_Number
    FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
    WHERE RE.Reservation_ID = RA.Reservation_ID
    AND RO.Room_Number = RA.Room_Number
    AND RO.Hotel_ID = RA.Hotel_ID
    AND H.Hotel_ID = RO.Hotel_ID
    AND DATE '2017-01-01' < latest_checkout_date 
    AND DATE '2017-01-04' >= earliest_checkin_date
    AND Is_Sold = 'F'
    AND Is_Cancelled = 'F')
ORDER BY Hotel_ID, Room_Number;

--The following procedure is called with a room type that is not available 
--in the specified date range, so the NO_DATA_FOUND exception is thrown and 
--a meaningful message is printed:
--No double rooms are available within the below date range, so
--NO_DATA_FOUND exception is thrown.
EXEC Num_Available_Rooms_Of_Type(1, 'luxury-suite', '2017-01-01', '2017-01-04');

--#12. AvailabilityOfRoomHotelPerInterval: Input a room type, hotel ID, date 
--interval and return the number of available rooms of all types during that 
--time interval.
--Code for #12:
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

--Using the sample data, here are all rooms of all types in all hotels obtained 
--from the following select query:
SELECT Hotel_ID, Room_Number, Room_Type
FROM Room
ORDER BY Hotel_ID, Room_Number;

--Here are all available rooms between the date range given in the procedure call 
--below of all types in all hotels obtained from the following select query:
SELECT Hotel_ID, Room_Number, Room_Type 
FROM Room 
WHERE (Hotel_ID, Room_Number) NOT IN
    (SELECT DISTINCT RA.Hotel_ID, RA.Room_Number
    FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
    WHERE RE.Reservation_ID = RA.Reservation_ID
    AND RO.Room_Number = RA.Room_Number
    AND RO.Hotel_ID = RA.Hotel_ID
    AND H.Hotel_ID = RO.Hotel_ID
    AND DATE '2017-01-07' < latest_checkout_date 
    AND DATE '2017-01-09' >= earliest_checkin_date
    AND Is_Sold = 'F'
    AND Is_Cancelled = 'F')
ORDER BY Hotel_ID, Room_Number;

--The following command calls the procedure and outputs the number of 
--available rooms of all types in just Hotel 1. The results are found below, 
--which can be verified by counting the number of available rooms in hotel 1 (4) 
--in the above query results:
EXEC Num_Available_Rooms(1, '2017-01-07', '2017-01-09');

--The following command calls the function for a non-existent hotel, 
--correctly returning 0 rooms:
EXEC Num_Available_Rooms(6, '2017-01-07', '2017-01-09');

--#16. SpecificHotelReport: Input: hotelID, start-date, end-date. Print 
--(for the given time interval):

--1.	Income by room type
--Code for part 1 of #16:
CREATE OR REPLACE PROCEDURE Income_By_Room_Type(Hotel_ID_Param IN NUMBER,
    Start_Date_Param IN VARCHAR, End_Date_Param IN VARCHAR) IS
    Room_Type_Loc Room.Room_Type%TYPE;
    Income_By_Room_Type_Loc NUMBER;
    CURSOR C IS
        --First find room types that are not found within the main query, then
        --union the results of this operation with the results from the main
        --query into one table containing all the incomes by room type.
        SELECT Room_Type, 0 AS Income_By_Room_Type FROM
            (SELECT DISTINCT Room_Type
            FROM Room
            WHERE Room_Type NOT IN
                (SELECT DISTINCT Room_Type
                FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
                WHERE RE.Reservation_ID = RA.Reservation_ID
                AND RO.Room_Number = RA.Room_Number
                AND RO.Hotel_ID = RA.Hotel_ID
                AND H.Hotel_ID = RO.Hotel_ID
                AND TO_DATE(Start_Date_Param, 'YYYY-MM-DD') < Actual_Checkout_Date
                AND TO_DATE(End_Date_Param, 'YYYY-MM-DD') >= Actual_Checkin_Date
                AND H.Hotel_ID = Hotel_ID_Param
                AND Is_Cancelled = 'F'))
        --Union together income by existing room types and non-existing room types.
        UNION
    --Find the total income from each type of room with SUM and group by room type.
        SELECT Room_Type, SUM(Room_Cost_Final) AS Income_By_Room_Type FROM
    --Apply discount of 5% or 10% depending on how far back the reservation was made
    --to get the final cost for each room.
        (SELECT Room_Type,
            CASE
                WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 1 AND
                    MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) < 2
                    THEN Room_Cost_Rated * 0.95
                WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 2
                    THEN Room_Cost_Rated * 0.90
                ELSE
                    Room_Cost_Rated * 1
            END AS Room_Cost_Final
        FROM
    --Then, increase the price of each room depending on the rate type of the
    --reservation (25% more for rate type 2, 50% more for rate type 3).
        (SELECT Room_Type, Reservation_Date, Actual_Checkin_Date, Actual_Checkout_Date,
            CASE Rate_Type
                    WHEN 1 THEN Room_Total_Cost * 1
                    WHEN 2 THEN Room_Total_Cost * 1.25
                    WHEN 3 THEN Room_Total_Cost * 1.5
            END AS Room_Cost_Rated
            FROM
    --First, find the aggregate base cost of rooms by multiplying their base cost
    --with the number of nights stayed at the hotel.
        (SELECT Room_Type, Reservation_Date, Actual_Checkin_Date,
            Actual_Checkout_Date, Rate_Type,
            TO_NUMBER(Actual_Checkout_Date - Actual_Checkin_Date) * Room_Base_Cost
            AS Room_Total_Cost
        FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
        WHERE RE.Reservation_ID = RA.Reservation_ID
        AND RO.Room_Number = RA.Room_Number
        AND RO.Hotel_ID = RA.Hotel_ID
        AND H.Hotel_ID = RO.Hotel_ID
        AND TO_DATE(Start_Date_Param, 'YYYY-MM-DD') < Actual_Checkout_Date
        AND TO_DATE(End_Date_Param, 'YYYY-MM-DD') >= Actual_Checkin_Date
        AND H.Hotel_ID = Hotel_ID_Param
        AND Is_Cancelled = 'F')))
        --Group main query results by Room_Type
        GROUP BY Room_Type;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Income by Room Type at Hotel #' || Hotel_ID_Param
        || ' for reservations between dates:');
    DBMS_OUTPUT.PUT_LINE(Start_Date_Param || ' and ' || End_Date_Param);
    OPEN C;
    LOOP
        FETCH C INTO Room_Type_Loc, Income_By_Room_Type_Loc;
        EXIT WHEN C%NOTFOUND;
        IF Income_By_Room_Type_Loc = 0 THEN
            DBMS_OUTPUT.PUT_LINE(Room_Type_Loc || ': $0.00');
        ELSE
            DBMS_OUTPUT.PUT_LINE(Room_Type_Loc || ': ' || 
            LTRIM(TO_CHAR(ROUND(Income_By_Room_Type_Loc, 2), '$9999999.99')));
        END IF;
    END LOOP;
    CLOSE C;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An exception occurred.');
END;
/

--The following table produced from the SQL query below shows details of all 
--rooms found in all reservations in all hotels in a set of sample data. The base 
--cost of each room is given along with the date range occupied so it can be 
--manually compared to the results of the PL/SQL block below:
SELECT H.Hotel_ID, RO.Room_Number, Room_Type, Reservation_Date, Actual_Checkin_Date, 
    Actual_Checkout_Date, RE.Reservation_ID, Room_Base_Cost, Rate_Type, Is_Cancelled 
FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
WHERE RE.Reservation_ID = RA.Reservation_ID
AND RO.Room_Number = RA.Room_Number
AND RO.Hotel_ID = RA.Hotel_ID
AND H.Hotel_ID = RO.Hotel_ID;

--Using the procedure defined above, we find the income by room type in the date 
--range specified for only Hotel 1 in command below by factoring in 
--number of days stayed, discounts, and rate types to get the following output. 
--Note that room types that were not occupied during the date range give an 
--income value of $0.
--Charges for each room in the range at hotel 1 can be calculated manually and
--match the values given when the procedure is called below (add the two costs
--of single-rooms together):
--Base_Cost*Num_Days*Rate_Type_Increase*Discount=Final_Room_Cost
--res1,room1,hotel1,single-room 102.69*3*1.5*0.95=438.9998
--res1,room2,hotel1,luxury-suite 152.25*3*1.5*0.95=650.8688
--res6,room3,hotel1,single-room 102.69*4*1*0.90=369.684
--(for single rooms) 438.9998+369.684=$808.67375
EXEC Income_By_Room_Type(1, '2017-01-01', '2019-01-01');

--2. Income of services, by service type
--Code for part 2 of #16:
CREATE OR REPLACE PROCEDURE Services_Income_By_Type(Hotel_ID_Param IN NUMBER,
Start_Date_Param IN VARCHAR, End_Date_Param IN VARCHAR) IS
    Service_Type_Loc Service_Event.Service_Type%TYPE;
    Service_Cost_Loc NUMBER;
    CURSOR C IS
        SELECT Service_Type, 0 AS Service_Cost FROM
        (SELECT DISTINCT Service_Type
        FROM Service_Event
        WHERE Service_Type NOT IN
            (SELECT Service_Type
            FROM Reservation R, Service_Event S
            WHERE R.Reservation_ID = S.Reservation_ID
            AND TO_DATE(Start_Date_Param, 'YYYY-MM-DD') < Actual_Checkout_Date
            AND TO_DATE(End_Date_Param, 'YYYY-MM-DD') >= Actual_Checkin_Date
            AND Hotel_ID = Hotel_ID_Param))
        --Join together the services not found as $0 with the sum of income from
        --other services.
        UNION
        SELECT Service_Type, SUM(CASE Service_Type
                                    WHEN 'restaurant meal' THEN 20
                                    WHEN 'pay-per-view movie' THEN 5
                                    WHEN 'laundry' THEN 10
                                END) AS Service_Cost
        FROM Reservation R, Service_Event S
        WHERE R.Reservation_ID = S.Reservation_ID
        AND TO_DATE(Start_Date_Param, 'YYYY-MM-DD') < Actual_Checkout_Date
        AND TO_DATE(End_Date_Param, 'YYYY-MM-DD') >= Actual_Checkin_Date
        AND Hotel_ID = Hotel_ID_Param
        GROUP BY Service_Type;
BEGIN
    OPEN C;
    DBMS_OUTPUT.PUT_LINE('Cost of services by type at Hotel #' || Hotel_ID_Param
        || ' for reservations between dates:');
    DBMS_OUTPUT.PUT_LINE(Start_Date_Param || ' and ' || End_Date_Param);
    LOOP
            FETCH C INTO Service_Type_Loc, Service_Cost_Loc;
            EXIT WHEN C%NOTFOUND;
            IF Service_Cost_Loc = 0 THEN
                DBMS_OUTPUT.PUT_LINE(Service_Type_Loc || ': $0.00');
            ELSE
                DBMS_OUTPUT.PUT_LINE(Service_Type_Loc || ': ' || 
                    LTRIM(TO_CHAR(ROUND(Service_Cost_Loc, 2), '$9999999.99')));
            END IF;
    END LOOP;
    CLOSE C;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An exception occurred.');
END;
/

--The following table created using the SQL query provided below shows 
--information for all service events in all reservations in all hotels in all 
--date ranges:
SELECT Service_Event_ID, Hotel_ID, R.Reservation_ID, Actual_Checkin_Date, 
    Actual_Checkout_Date, Service_Type, 
    CASE Service_Type
        WHEN 'restaurant meal' THEN 20
        WHEN 'pay-per-view movie' THEN 5
        WHEN 'laundry' THEN 10
    END AS Service_Cost
FROM Reservation R, Service_Event S
WHERE R.Reservation_ID = S.Reservation_ID
ORDER BY Service_Event_ID;

--The below procedure call finds the total income from all services of each type 
--in the specified date range in Hotel 1, which can be confirmed by looking at 
--the table above, calculated manually as follows.
--laundry (SE_ID2,Res1),(SE_ID3,Res1) 10+10=$20
--pay-per-view movie (SE_ID9,Res6) $5
--restaurant meal (SE_ID1,Res1),(SE_ID8,Res6) 20+20=40 
EXEC Services_Income_By_Type(1, '2017-01-01', '2019-01-01');

--3.	Total income from all sources.
--Code for part 3 of #16:
CREATE OR REPLACE PROCEDURE Total_Income(Hotel_ID_Param IN NUMBER,
    Start_Date_Param IN VARCHAR, End_Date_Param IN VARCHAR) IS
    Total_Income_Loc NUMBER;
BEGIN
    --Total income is summed with the number 0 by union and SUM function so that
    --if no reservations fall within the date range, 0 is printed instead of
    --NULL. Within, the total amount from services and the total amount from
    --rooms is also summed together using a UNION and SUM function.
    SELECT SUM(Income_Nonzero) INTO Total_Income_Loc FROM
    ((SELECT SUM(Income) AS Income_Nonzero FROM
    (SELECT
        SUM(CASE
            WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 1 AND
                MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) < 2
                THEN Room_Cost_Rated * 0.95
            WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 2
                THEN Room_Cost_Rated * 0.90
            ELSE
                Room_Cost_Rated * 1
        END) AS Income
    FROM
    (SELECT Reservation_Date, Actual_Checkin_Date, Actual_Checkout_Date,
        CASE Rate_Type
            WHEN 1 THEN Room_Total_Cost * 1
            WHEN 2 THEN Room_Total_Cost * 1.25
            WHEN 3 THEN Room_Total_Cost * 1.5
        END AS Room_Cost_Rated
        FROM
    (SELECT Reservation_Date, Actual_Checkin_Date,
        Actual_Checkout_Date, Rate_Type,
        TO_NUMBER(Actual_Checkout_Date - Actual_Checkin_Date) * Room_Base_Cost
        AS Room_Total_Cost
    FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
    WHERE RE.Reservation_ID = RA.Reservation_ID
    AND RO.Room_Number = RA.Room_Number
    AND RO.Hotel_ID = RA.Hotel_ID
    AND H.Hotel_ID = RO.Hotel_ID
    AND TO_DATE(Start_Date_Param, 'YYYY-MM-DD') < Actual_Checkout_Date
    AND TO_DATE(End_Date_Param, 'YYYY-MM-DD') >= Actual_Checkin_Date
    AND H.Hotel_ID = Hotel_ID_Param))
    --Union together income from services and rooms so it can be summed together
    UNION
    SELECT SUM(CASE Service_Type
                    WHEN 'restaurant meal' THEN 20
                    WHEN 'pay-per-view movie' THEN 5
                    WHEN 'laundry' THEN 10
                END) AS Total_Service_Cost
    FROM Reservation R, Service_Event S
    WHERE R.Reservation_ID = S.Reservation_ID
    AND TO_DATE(Start_Date_Param, 'YYYY-MM-DD') < Actual_Checkout_Date
    AND TO_DATE(End_Date_Param, 'YYYY-MM-DD') >= Actual_Checkin_Date
    AND R.Hotel_ID = Hotel_ID_Param
    AND Is_Cancelled = 'F'))
    UNION
    (SELECT 0 FROM DUAL));
    
    DBMS_OUTPUT.PUT_LINE('Total income from all rooms and services at hotel #'
            || Hotel_ID_Param || ' for reservations between dates:');
    DBMS_OUTPUT.PUT_LINE(Start_Date_Param || ' and ' || End_Date_Param);
    IF Total_Income_Loc = 0 THEN
        DBMS_OUTPUT.PUT_LINE('= $0.00');
    ELSE
        DBMS_OUTPUT.PUT_LINE('=' || LTRIM(TO_CHAR(ROUND(Total_Income_Loc, 2), 
            '$9999999.99')));
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Something went wrong, too few rows.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Something went wrong, too many rows.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('A different exception occurred.');
END;
/

--The income from all sources in Hotel 1 in the specified date range provided in
--the below PL/SQL block is the sum of all income from rooms and from service 
--events. The results are shown after the first block. The total income in this 
--sample range can be verified by summing the results of part 1 and part 2 above.
--res1,room1,hotel1,single-room 102.69*3*1.5*0.95=438.9998
--res1,room2,hotel1,luxury-suite 152.25*3*1.5*0.95=650.8688
--res6,room3,hotel1,single-room 102.69*4*1*0.90=369.684
--+
--laundry (SE_ID2,Res1),(SE_ID3,Res1) 10+10=$20
--pay-per-view movie (SE_ID9,Res6) $5
--restaurant meal (SE_ID1,Res1),(SE_ID8,Res6) 20+20=40
--438.9998 + 650.8688 + 369.684 + 20 + 5 + 40 = $1524.5526
EXEC Total_Income(1, '2017-01-01', '2019-01-01');

--4.	Parent report function
--All three functions above are combined into a single function for the purpose 
--of providing all the information for a single hotel and date range in one 
--procedure call.

--Code for part 4 of #16:
--The final procedure calls all three sub-functions.
CREATE OR REPLACE PROCEDURE Specific_Hotel_Report(Hotel_ID_Param IN NUMBER,
    Start_Date_Param IN VARCHAR, End_Date_Param IN VARCHAR) IS
BEGIN
    Services_Income_By_Type(Hotel_ID_Param, Start_Date_Param, End_Date_Param);
    DBMS_OUTPUT.NEW_LINE;
    Income_By_Room_Type(Hotel_ID_Param, Start_Date_Param, End_Date_Param);
    DBMS_OUTPUT.NEW_LINE;
    Total_Income(Hotel_ID_Param, Start_Date_Param, End_Date_Param);
    DBMS_OUTPUT.NEW_LINE;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An exception occurred.');
END;
/

--The following command finds all information for Hotel 1 in the given 
--sample data necessary for the report by calling the parent function 
--Specific_Hotel_Report.
EXEC Specific_Hotel_Report(1, '2017-01-01', '2019-01-01');

--#15 ShowCancelations: Print all canceled reservations in the hotel 
--management system. Show reservation ID, hotel name, location, guest name, 
--room type, dates.
--Code for #15:
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
        --Output is broken up into two lines, indicated by 8 spaces in front of 
        --each continued line.
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

--Save data up to this point.
COMMIT;

--The following update query is issued to change some reservations to cancelled 
--in order to demonstrate functionality:
UPDATE Reservation
SET Is_Cancelled = 'T'
WHERE Reservation_ID = 1
OR Reservation_ID = 2
OR Reservation_ID = 4
OR Reservation_ID = 5;

--Using the following select query with sample data, the following information 
--can be shown about all rooms that are found in all reservations:
SELECT RE.Reservation_ID, Is_Cancelled, 'Hotel #' || RE.Hotel_ID AS Hotel_Name, 
    H.Address_City || ', ' || H.Address_State AS Hotel_Location, 
    First_Name || ' ' || Last_Name AS Guest_Name, Room_Type, Reservation_Date,
    Earliest_Checkin_Date, Latest_Checkout_Date
FROM Reservation RE, Room_Assignment RA, Room RO, Customer C, Hotel H
WHERE RE.Reservation_ID = RA.Reservation_ID
AND RO.Hotel_ID = RA.Hotel_ID
AND RO.Room_Number = RA.Room_Number
AND H.Hotel_ID = RE.Hotel_ID
AND C.Customer_ID = RE.Customer_ID
ORDER BY Reservation_ID;


--Calling the procedure Show_Cancellations gives the following 
--output only for cancelled reservations, note that for reservations that have 
--multiple room types, there are additional rows to show that the room type 
--belongs to the reservation. Rows with duplicate room types (that is, if 
--multiple rooms of the same type are reserved in the same reservation) are 
--suppressed by using DISTINCT in the procedure. As you can see, reservation 
--details with associated room types are printed from reservations where 
--Is_Cancelled is true ('T').
EXEC Show_Cancellations;

--Restore data back before update query.
ROLLBACK;

--Code for #18
CREATE OR REPLACE PROCEDURE Services_Income_By_State(Hotel_State_Param IN 
    Hotel.Address_State%TYPE) IS
    Service_Type_Loc Service_Event.Service_Type%TYPE;
    Service_Cost_Loc NUMBER;
    CURSOR C IS
        SELECT Service_Type, 0 AS Service_Cost FROM
        (SELECT DISTINCT Service_Type
        FROM Service_Event
        WHERE Service_Type NOT IN
            (SELECT Service_Type
            FROM Reservation R, Service_Event S, Hotel H
            WHERE R.Reservation_ID = S.Reservation_ID
            AND H.Hotel_ID = R.Hotel_ID
            AND H.Address_State = Hotel_State_Param))
        --Join together the services not found as $0 with the sum of income from
        --other services.
        UNION
        SELECT Service_Type, SUM(CASE Service_Type
                                    WHEN 'restaurant meal' THEN 20
                                    WHEN 'pay-per-view movie' THEN 5
                                    WHEN 'laundry' THEN 10
                                END) AS Service_Cost
        FROM Reservation R, Service_Event S, Hotel H
        WHERE R.Reservation_ID = S.Reservation_ID
        AND H.Hotel_ID = R.Hotel_ID
        AND H.Address_State = Hotel_State_Param
        GROUP BY Service_Type;
BEGIN
    OPEN C;
    DBMS_OUTPUT.PUT_LINE('Cost of services by type at all hotels in state ' 
        || Hotel_State_Param);
    LOOP
            FETCH C INTO Service_Type_Loc, Service_Cost_Loc;
            EXIT WHEN C%NOTFOUND;
            IF Service_Cost_Loc = 0 THEN
                DBMS_OUTPUT.PUT_LINE(Service_Type_Loc || ': $0.00');
            ELSE
                DBMS_OUTPUT.PUT_LINE(Service_Type_Loc || ': ' || 
                    LTRIM(TO_CHAR(ROUND(Service_Cost_Loc, 2), '$9999999.99')));
            END IF;
    END LOOP;
    CLOSE C;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An exception occurred.');
END;
/

EXEC Services_Income_By_State('MD');

CREATE OR REPLACE PROCEDURE Room_Type_Income_By_State(Hotel_State_Param IN
    Hotel.Address_State%TYPE) IS
    Room_Type_Loc Room.Room_Type%TYPE;
    Income_By_Room_Type_Loc NUMBER;
    CURSOR C IS
        --First find room types that are not found within the main query, then
        --union the results of this operation with the results from the main
        --query into one table containing all the incomes by room type.
        SELECT Room_Type, 0 AS Income_By_Room_Type FROM
            (SELECT DISTINCT Room_Type
            FROM Room
            WHERE Room_Type NOT IN
                (SELECT DISTINCT Room_Type
                FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
                WHERE RE.Reservation_ID = RA.Reservation_ID
                AND RO.Room_Number = RA.Room_Number
                AND RO.Hotel_ID = RA.Hotel_ID
                AND H.Hotel_ID = RO.Hotel_ID
                AND H.Address_State = Hotel_State_Param
                AND Is_Cancelled = 'F'))
        --Union together income by existing room types and non-existing room types.
        UNION
    --Find the total income from each type of room with SUM and group by room type.
        SELECT Room_Type, SUM(Room_Cost_Final) AS Income_By_Room_Type FROM
    --Apply discount of 5% or 10% depending on how far back the reservation was made
    --to get the final cost for each room.
        (SELECT Room_Type,
            CASE
                WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 1 AND
                    MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) < 2
                    THEN Room_Cost_Rated * 0.95
                WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 2
                    THEN Room_Cost_Rated * 0.90
                ELSE
                    Room_Cost_Rated * 1
            END AS Room_Cost_Final
        FROM
    --Then, increase the price of each room depending on the rate type of the
    --reservation (25% more for rate type 2, 50% more for rate type 3).
        (SELECT Room_Type, Reservation_Date, Actual_Checkin_Date, Actual_Checkout_Date,
            CASE Rate_Type
                    WHEN 1 THEN Room_Total_Cost * 1
                    WHEN 2 THEN Room_Total_Cost * 1.25
                    WHEN 3 THEN Room_Total_Cost * 1.5
            END AS Room_Cost_Rated
            FROM
    --First, find the aggregate base cost of rooms by multiplying their base cost
    --with the number of nights stayed at the hotel.
        (SELECT Room_Type, Reservation_Date, Actual_Checkin_Date,
            Actual_Checkout_Date, Rate_Type,
            TO_NUMBER(Actual_Checkout_Date - Actual_Checkin_Date) * Room_Base_Cost
            AS Room_Total_Cost
        FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
        WHERE RE.Reservation_ID = RA.Reservation_ID
        AND RO.Room_Number = RA.Room_Number
        AND RO.Hotel_ID = RA.Hotel_ID
        AND H.Hotel_ID = RO.Hotel_ID
        AND H.Address_State = Hotel_State_Param
        AND Is_Cancelled = 'F')))
        --Group main query results by Room_Type
        GROUP BY Room_Type;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Income by Room Type at all hotels in state ' 
        || Hotel_State_Param);
    OPEN C;
    LOOP
        FETCH C INTO Room_Type_Loc, Income_By_Room_Type_Loc;
        EXIT WHEN C%NOTFOUND;
        IF Income_By_Room_Type_Loc = 0 THEN
            DBMS_OUTPUT.PUT_LINE(Room_Type_Loc || ': $0.00');
        ELSE
            DBMS_OUTPUT.PUT_LINE(Room_Type_Loc || ': ' || 
            LTRIM(TO_CHAR(ROUND(Income_By_Room_Type_Loc, 2), '$9999999.99')));
        END IF;
    END LOOP;
    CLOSE C;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An exception occurred.');
END;
/

EXEC Room_Type_Income_By_State('MD');

CREATE OR REPLACE PROCEDURE TotalHiltonStateReport(
    State_Param IN Hotel.Address_State%TYPE) IS
BEGIN
    Room_Type_Income_By_State(State_Param);
    DBMS_OUTPUT.NEW_LINE;
    Services_Income_By_State(State_Param);
    DBMS_OUTPUT.NEW_LINE;
END;
/

SELECT H.Hotel_ID, RO.Room_Number, Room_Type, Reservation_Date, Actual_Checkin_Date, 
    Actual_Checkout_Date, RE.Reservation_ID, Room_Base_Cost, Rate_Type, Is_Cancelled 
FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
WHERE RE.Reservation_ID = RA.Reservation_ID
AND RO.Room_Number = RA.Room_Number
AND RO.Hotel_ID = RA.Hotel_ID
AND H.Hotel_ID = RO.Hotel_ID
AND H.Address_State = 'MD'
ORDER BY RO.Hotel_ID, RO.Room_Number;

SELECT Service_Event_ID, H.Hotel_ID, R.Reservation_ID, Actual_Checkin_Date, 
    Actual_Checkout_Date, Service_Type, 
    CASE Service_Type
        WHEN 'restaurant meal' THEN 20
        WHEN 'pay-per-view movie' THEN 5
        WHEN 'laundry' THEN 10
    END AS Service_Cost
FROM Reservation R, Service_Event S, Hotel H
WHERE R.Reservation_ID = S.Reservation_ID
AND H.Hotel_ID = R.Hotel_ID
AND H.Address_State = 'MD'
ORDER BY Service_Event_ID;

EXEC TotalHiltonStateReport('MD');

--$0 income totals printed correctly.
EXEC TotalHiltonStateReport('VA');