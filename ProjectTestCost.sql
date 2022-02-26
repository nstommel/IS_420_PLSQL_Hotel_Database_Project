SET SERVEROUTPUT ON;
DROP PROCEDURE Services_Income_By_Type;
DROP PROCEDURE Income_By_Room_Type;
DROP PROCEDURE Total_Income;
DROP PROCEDURE Specific_Hotel_Report;

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

--FOR TESTING: Display all costs of all rooms along with info about the rooms.
--Hotel number, starting date, and ending date are given in the deepest SELECT
--query.
SELECT Hotel_ID, Room_Number, Room_Type, --Reservation_Date, 
    Actual_Checkin_Date, 
    Actual_Checkout_Date, Reservation_ID, Room_Base_Cost, Rate_Type 
--    Room_Total_Cost, Room_Cost_Rated, 
--    CASE
--        WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 1 AND
--            MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) < 2
--            THEN Room_Cost_Rated * 0.95
--        WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 2
--            THEN Room_Cost_Rated * 0.90
--        ELSE
--            Room_Cost_Rated * 1
--    END AS Room_Cost_Final
FROM
(SELECT Hotel_ID, Room_Number, Room_Type, Reservation_Date, Actual_Checkin_Date, 
    Actual_Checkout_Date, Reservation_ID, Room_Base_Cost, Rate_Type, 
    Room_Total_Cost, 
    CASE Rate_Type
        WHEN 1 THEN Room_Total_Cost * 1
        WHEN 2 THEN Room_Total_Cost * 1.25
        WHEN 3 THEN Room_Total_Cost * 1.5
    END AS Room_Cost_Rated
    FROM
(SELECT RA.Hotel_ID, RA.Room_Number, Room_Type, Reservation_Date, Actual_Checkin_Date, 
    Actual_Checkout_Date, RE.Reservation_ID, Room_Base_Cost, Rate_Type, 
    TO_NUMBER(Actual_Checkout_Date - Actual_Checkin_Date) * Room_Base_Cost
    AS Room_Total_Cost
FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
WHERE RE.Reservation_ID = RA.Reservation_ID
AND RO.Room_Number = RA.Room_Number
AND RO.Hotel_ID = RA.Hotel_ID
AND H.Hotel_ID = RO.Hotel_ID
--AND DATE '2021-01-04' < Actual_Checkout_Date 
--AND DATE '2021-01-08' >= Actual_Checkin_Date
--AND H.Hotel_ID = 1
AND Is_Cancelled = 'F'));

--16-1
SELECT H.Hotel_ID, RO.Room_Number, Room_Type, Reservation_Date, Actual_Checkin_Date, 
    Actual_Checkout_Date, RE.Reservation_ID, Room_Base_Cost, Rate_Type, Is_Cancelled 
FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
WHERE RE.Reservation_ID = RA.Reservation_ID
AND RO.Room_Number = RA.Room_Number
AND RO.Hotel_ID = RA.Hotel_ID
AND H.Hotel_ID = RO.Hotel_ID;
--
----Display total income by room type only.
--SELECT Room_Type, SUM(Room_Cost_Final) AS Income_By_Room_Type FROM
--(SELECT Room_Type, 
--    CASE
--        WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 1 AND
--            MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) < 2
--            THEN Room_Cost_Rated * 0.95
--        WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 2
--            THEN Room_Cost_Rated * 0.90
--        ELSE
--            Room_Cost_Rated * 1
--    END AS Room_Cost_Final
--FROM
--(SELECT Room_Type, Reservation_Date, Actual_Checkin_Date, Actual_Checkout_Date, 
--    CASE Rate_Type
--        WHEN 1 THEN Room_Total_Cost * 1
--        WHEN 2 THEN Room_Total_Cost * 1.25
--        WHEN 3 THEN Room_Total_Cost * 1.5
--    END AS Room_Cost_Rated
--    FROM
--(SELECT Room_Type, Reservation_Date, Actual_Checkin_Date, 
--    Actual_Checkout_Date, Rate_Type, 
--    TO_NUMBER(Actual_Checkout_Date - Actual_Checkin_Date) * Room_Base_Cost
--    AS Room_Total_Cost
--FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
--WHERE RE.Reservation_ID = RA.Reservation_ID
--AND RO.Room_Number = RA.Room_Number
--AND RO.Hotel_ID = RA.Hotel_ID
--AND H.Hotel_ID = RO.Hotel_ID
--AND DATE '2021-01-04' < Actual_Checkout_Date 
--AND DATE '2021-01-08' >= Actual_Checkin_Date
--AND H.Hotel_ID = 1
--AND Is_Cancelled = 'F')))
----Group final query results by Room_Type
--GROUP BY Room_Type;

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
        SELECT Room_Type, SUM(Room_Cost_Final) AS Income_By_Room_Type FROM
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
        (SELECT Room_Type, Reservation_Date, Actual_Checkin_Date, Actual_Checkout_Date, 
            CASE Rate_Type
                WHEN 1 THEN Room_Total_Cost * 1
                WHEN 2 THEN Room_Total_Cost * 1.25
                WHEN 3 THEN Room_Total_Cost * 1.5
            END AS Room_Cost_Rated
            FROM
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
        DBMS_OUTPUT.PUT_LINE(Room_Type_Loc || ': $' || Income_By_Room_Type_Loc);
    END LOOP;
    CLOSE C;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An exception occurred.');
END;
/

BEGIN
    Income_By_Room_Type(1, '2021-01-04', '2021-01-08');
END;
/
--First find room types that are not found within the main query, then union
--the results of this operation with the results from the main query into one 
--table containing all the incomes by room type.
--SELECT Room_Type, 0 AS Income_By_Room_Type FROM
--    (SELECT DISTINCT Room_Type
--    FROM Room 
--    WHERE Room_Type NOT IN 
--        (SELECT DISTINCT Room_Type
--        FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
--        WHERE RE.Reservation_ID = RA.Reservation_ID
--        AND RO.Room_Number = RA.Room_Number
--        AND RO.Hotel_ID = RA.Hotel_ID
--        AND H.Hotel_ID = RO.Hotel_ID
--        AND DATE '2021-01-04' < Actual_Checkout_Date 
--        AND DATE '2021-01-08' >= Actual_Checkin_Date
--        AND H.Hotel_ID = 1
--        AND Is_Cancelled = 'F'))
----Union together income by existing room types and non-existing room types.
--UNION
--SELECT Room_Type, SUM(Room_Cost_Final) AS Income_By_Room_Type FROM
--(SELECT Room_Type, 
--    CASE
--        WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 1 AND
--            MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) < 2
--            THEN Room_Cost_Rated * 0.95
--        WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 2
--            THEN Room_Cost_Rated * 0.90
--        ELSE
--            Room_Cost_Rated * 1
--    END AS Room_Cost_Final
--FROM
--(SELECT Room_Type, Reservation_Date, Actual_Checkin_Date, Actual_Checkout_Date, 
--    CASE Rate_Type
--        WHEN 1 THEN Room_Total_Cost * 1
--        WHEN 2 THEN Room_Total_Cost * 1.25
--        WHEN 3 THEN Room_Total_Cost * 1.5
--    END AS Room_Cost_Rated
--    FROM
--(SELECT Room_Type, Reservation_Date, Actual_Checkin_Date, 
--    Actual_Checkout_Date, Rate_Type, 
--    TO_NUMBER(Actual_Checkout_Date - Actual_Checkin_Date) * Room_Base_Cost
--    AS Room_Total_Cost
--FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
--WHERE RE.Reservation_ID = RA.Reservation_ID
--AND RO.Room_Number = RA.Room_Number
--AND RO.Hotel_ID = RA.Hotel_ID
--AND H.Hotel_ID = RO.Hotel_ID
--AND DATE '2021-01-04' < Actual_Checkout_Date 
--AND DATE '2021-01-08' >= Actual_Checkin_Date
--AND H.Hotel_ID = 1
--AND Is_Cancelled = 'F')))
----Group main query results by Room_Type
--GROUP BY Room_Type;

--FOR TESTING. Get services in a given hotel in a date range. Note that
--services that appear in this table for the date range are tied to a
--reservation within the given date range at a given hotel, 
--not necessarily the service_date.
SELECT Service_Event_ID, Hotel_ID, R.Reservation_ID, Actual_Checkin_Date, Actual_Checkout_Date, Service_Type, 
    CASE Service_Type
        WHEN 'restaurant meal' THEN 20
        WHEN 'pay-per-view movie' THEN 5
        WHEN 'laundry' THEN 10
    END AS Service_Cost
FROM Reservation R, Service_Event S
WHERE R.Reservation_ID = S.Reservation_ID
--AND DATE '2021-01-04' < Actual_Checkout_Date 
--AND DATE '2021-01-08' >= Actual_Checkin_Date
--AND Hotel_ID = 1;
ORDER BY Service_Event_ID;

--16-2
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

----Give the total cost of all services corresponding to reservations within
----the given date range in a given hotel.
--SELECT SUM(CASE Service_Type
--           WHEN 'restaurant meal' THEN 20
--           WHEN 'pay-per-view movie' THEN 5
--           WHEN 'laundry' THEN 10
--           END) AS Total_Service_Cost
--FROM Reservation R, Service_Event S
--WHERE R.Reservation_ID = S.Reservation_ID
--AND DATE '2021-01-04' < Actual_Checkout_Date 
--AND DATE '2021-01-08' >= Actual_Checkin_Date
--AND Hotel_ID = 1;
--
----Part B, income of services by type in a specific date range
--SELECT Service_Type, SUM(CASE Service_Type
--                            WHEN 'restaurant meal' THEN 20
--                            WHEN 'pay-per-view movie' THEN 5
--                            WHEN 'laundry' THEN 10
--                         END) AS Service_Cost
--FROM Reservation R, Service_Event S
--WHERE R.Reservation_ID = S.Reservation_ID
--AND DATE '2021-01-04' < Actual_Checkout_Date 
--AND DATE '2021-01-08' >= Actual_Checkin_Date
--AND Hotel_ID = 1
--GROUP BY Service_Type;

--TEST
--First find the names of services not included in the date range and assign
--the value 0 to their income, then union the results of this query with the
--sum of income from services by service type.
--SELECT Service_Type, 0 AS Service_Cost FROM
--(SELECT DISTINCT Service_Type
--FROM Service_Event
--WHERE Service_Type NOT IN
--    (SELECT Service_Type 
--    FROM Reservation R, Service_Event S
--    WHERE R.Reservation_ID = S.Reservation_ID
--    AND DATE '2021-01-06' < Actual_Checkout_Date 
--    AND DATE '2021-01-08' >= Actual_Checkin_Date
--    AND Hotel_ID = 1))
----Join together the services not found as $0 with the sum of income from
----other services.
--UNION
--SELECT Service_Type, SUM(CASE Service_Type
--                            WHEN 'restaurant meal' THEN 20
--                            WHEN 'pay-per-view movie' THEN 5
--                            WHEN 'laundry' THEN 10
--                         END) AS Service_Cost
--FROM Reservation R, Service_Event S
--WHERE R.Reservation_ID = S.Reservation_ID
--AND DATE '2021-01-06' < Actual_Checkout_Date 
--AND DATE '2021-01-08' >= Actual_Checkin_Date
--AND Hotel_ID = 1
--GROUP BY Service_Type;

--Procedure for part B of 16:
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
        DBMS_OUTPUT.PUT_LINE(Service_Type_Loc || ': $' || Service_Cost_Loc);
    END LOOP;
    CLOSE C;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An exception occurred.');
END;
/

--Small subprogram to call procedure
BEGIN
    Services_Income_By_Type(1, '2021-01-04', '2021-01-08');
    --Show income including services not present in this range 
    --(in this case laundry)
    --Services_Income_By_Type(1, '2021-01-06', '2021-01-08');
END;
/

--Find total income from all sources in SQL query.
--SELECT SUM(Income) AS Total_Income FROM
--(SELECT 
--    SUM(CASE
--        WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 1 AND
--            MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) < 2
--            THEN Room_Cost_Rated * 0.95
--        WHEN MONTHS_BETWEEN(Actual_Checkin_Date, Reservation_Date) >= 2
--            THEN Room_Cost_Rated * 0.90
--        ELSE
--            Room_Cost_Rated * 1
--    END) AS Income
--FROM
--(SELECT Reservation_Date, Actual_Checkin_Date, Actual_Checkout_Date, 
--    CASE Rate_Type
--        WHEN 1 THEN Room_Total_Cost * 1
--        WHEN 2 THEN Room_Total_Cost * 1.25
--        WHEN 3 THEN Room_Total_Cost * 1.5
--    END AS Room_Cost_Rated
--    FROM
--(SELECT Reservation_Date, Actual_Checkin_Date, 
--    Actual_Checkout_Date, Rate_Type, 
--    TO_NUMBER(Actual_Checkout_Date - Actual_Checkin_Date) * Room_Base_Cost
--    AS Room_Total_Cost
--FROM Room_Assignment RA, Reservation RE, Room RO, Hotel H
--WHERE RE.Reservation_ID = RA.Reservation_ID
--AND RO.Room_Number = RA.Room_Number
--AND RO.Hotel_ID = RA.Hotel_ID
--AND H.Hotel_ID = RO.Hotel_ID
--AND DATE '2021-01-04' < Actual_Checkout_Date 
--AND DATE '2021-01-08' >= Actual_Checkin_Date
--AND H.Hotel_ID = 1))
----Union together income from services and rooms so it can be summed together
--UNION
--SELECT SUM(CASE Service_Type
--           WHEN 'restaurant meal' THEN 20
--           WHEN 'pay-per-view movie' THEN 5
--           WHEN 'laundry' THEN 10
--           END) AS Total_Service_Cost
--FROM Reservation R, Service_Event S
--WHERE R.Reservation_ID = S.Reservation_ID
--AND DATE '2021-01-04' < Actual_Checkout_Date 
--AND DATE '2021-01-08' >= Actual_Checkin_Date
--AND Hotel_ID = 1
--AND Is_Cancelled = 'F');

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
    DBMS_OUTPUT.PUT_LINE('= $' || Total_Income_Loc);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Something went wrong, too few rows.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Something went wrong, too many rows.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('A different exception occurred.');
END;
/

BEGIN
    Total_Income(1, '2021-01-04', '2021-01-08');
    --A date range where no reservations lie gives a $0 total thanks to the
    --first union.
    --Total_Income(1, '2022-01-04', '2022-01-08');
END;
/

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
--Test all 3 functions in parent function
BEGIN
    Specific_Hotel_Report(1, '2021-01-04', '2021-01-08');
END;
/
