--Delete existing rows in reverse order of insertion to ensure constraint integrity.
DELETE FROM Service_Event;
DELETE FROM Room_Assignment;
DELETE FROM Room;
DELETE FROM Reservation;
DELETE FROM Hotel;
DELETE FROM Customer;

--Insert records for 2 customers and 2 reservations in 2 hotels.
INSERT INTO Customer VALUES(1, 'John', 'Doe', '1234 Test Ln', 'Baltimore', 'MD', 
    '21042', NULL, 'John R Doe', NULL, NULL, '123', 'johndoe@gmail.com');
INSERT INTO Customer VALUES(2, 'Mary', 'Smith', '1234 Test Ct', 'Columbia', 'MD',
    '21835', NULL, 'Mary A Smith', NULL, NULL, '987', 'marysmith@yahoo.com');
    
INSERT INTO Hotel VALUES(1, '9876 Test Ln', 'Seattle', 'WA', '31024', NULL, 'F');
INSERT INTO Hotel VALUES(2, '1234 Test Dr', 'Las Vegas', 'NV', '24354', NULL, 'T');

INSERT INTO Reservation VALUES(1, 1, 1, NULL, NULL, NULL, NULL, NULL, 1, 120.20, 'F');
INSERT INTO Reservation VALUES(2, 2, 2, NULL, NULL, NULL, NULL, NULL, 2, 240.65, 'T');

INSERT INTO Room VALUES(1, 1, 'single room one-bed', 100.00);
INSERT INTO Room VALUES(1, 2, 'double-room two-beds', 200.00);

INSERT INTO Room_Assignment VALUES(1, 1, 1);
INSERT INTO Room_Assignment VALUES(1, 2, 2);

INSERT INTO Service_Event VALUES(1, 1, 1, 'laundry', 10.00, NULL);
INSERT INTO Service_Event VALUES(2, 2, 2, 'restaurant meal', 20.00, NULL);

--Delete one hotel from existence (optional test).
DELETE FROM Hotel WHERE Hotel_ID = 1;

--Delete one customer (optional test).
DELETE FROM Customer WHERE Customer_ID = 1;

--Delete one reservation (optional test).
DELETE FROM Reservation WHERE Reservation_ID = 1;

--Observe contents of tables after deletion of hotel. All records pertaining to
--Hotel #1 have been deleted, including child records (those with foreign keys
--pointing to the hotel, or to associated tables like). Data integrity is 
--maintained with constraints intact and child records are easily deleted when 
--the parent record is also deleted, as they are no longer relevant AND they 
--prevent the deletion of the parent record. Customer records and other entries 
--in all other tables not relating to the deleted hotel are still there, as 
--intended. Using ON DELETE CASCADE in the table definitions where relevant 
--foreign keys are declared is the ideal way to deal with deletion involving 
--records from multiple tables. Use similar logic for Customer and Reservation.
SELECT * FROM room;
SELECT * FROM reservation;
SELECT * FROM room_assignment;
SELECT * FROM service_event;
SELECT * FROM hotel;
SELECT * FROM customer;