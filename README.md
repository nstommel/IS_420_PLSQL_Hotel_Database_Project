# IS_420_PLSQL_Hotel_Database_Project
This group project implements a hotel management database complete with data, queries, and PL/SQL procedures. A full entity relationship diagram as well as normalized relational model are provided below as images. This database and its corresponding procedures are quite complex and were created as a group in which I served as project leader. Only the procedures implemented in my part of the project are included in the Presentation-Code file. The rest of the procedures implemented by other members of the group can be examined by opening the Team_Project.pdf file found in this repository.

# Description
Hilton Hotels Inc., is a fictitious hotel company. Hilton is in desperate need of upgrading its hotel management system and has sought your help. Your team has been contacted by Hilton and you have signed a contract to help them organize their office operations, using an Oracle database. You will code a PL/SQL procedures and functions with a number of operations that Hilton will be using to perform the day-to-day business with rooms, reservations etc.

Hilton is a typical hotel chain. Customers make reservations for specific dates and get specific services offered by hotel (nights they stay, hotel restaurant, etc.) which they pay for when they check out. 

# Database Design
There are several types of information to be stored in the database on hotels in different cities operated by Hilton, customers, reservations, cancellations etc.   You are free to make your own design in the database and create your own tables. The following list outlines the minimum information you should capture in the database. Feel free to add more tables and attributes if necessary to support the office operations more effectively.

The database you will create will have information on hotels, such as Address, Phone, Room Types available etc.

You should also store information on customers, such as Name, Address, Phone, Credit Card, etc.

The most vital part of the database should be information on reservations. It should include Client Name, Dates, Rate, Room Type, etc.

# Assumptions
To make this project manageable and within time limits we have to make several assumptions. The purpose of these assumptions is to give specific details to certain situations to guide your coding efforts.

1. The rates of each hotel fluctuate according to the season. Each hotel can set their own exact rate, but they have to follow the Rate Type as shown in the Table. The higher the rate type, the more expensive is the room rate per hotel. Feel free to create your own specific rates for each particular hotel in the Hilton chain.<br/>
2. You should make reservations for consecutive days for a specific Room type.<br/>
3. Guests can check-in with or without reservations.<br/>
4. If a reservation is made 2 months in advance or more, the customer gets a 10% discount on the rate. If the reservation is made 1 month in advance, the customer gets a 5% discount. Otherwise, the customer has to pay full rate.<br/>
5. There are no taxes charged to customers. Hilton made a deal with the IRS not to collect taxes from guests (to make things easier for the implementation)<br/>
6. Room types: single room 1-bed, double-room 2-beds, suites, conference rooms<br/>
7. Guests pay their bills when they check-out.<br/>
8. A guest can reserve and stay in multiple rooms at the same time (e.g. a large family) and must pay for all reserved rooms.<br/>
9. The services that are offered by all Hilton hotels are the same. They include:<br/>
a. Restaurant services (assume $20 per person per meal)<br/>
b. Pay-per-view movies (assume $5 per movie)<br/>
c. Laundry services (assume $10 per time – regardless of number of items)<br/>
10. Guests can check out earlier (before the last day they reserved a room) or later (they can stay longer if there is room availability)<br/>
11. Guests cannot reserve rooms that span across months with different rates. You do not have to implement this, but do not enter reservations with this type of information

# Operations implemented for the Hotel Management System:

Each operation must be implemented as a PL/SQL function or procedure. 
1. Graig [\*] Add a new hotel: Create a new hotel with appropriate information about the hotel as input parameters
2. John[\*] Find a hotel: Provide as input the address of the hotel and return its hotel ID
3. Eldho[\*] Sell existing hotel: Sell a hotel by providing its hotel ID. Mark it as sold, do not delete the record.
4. Eldho[\*\*] Make a reservation: Input parameters: Hotel, guest’s name, start date, end dates, room type, date of reservation, etc. Output: reservation ID (this is called confirmation code in real-life ). NOTE: Only one guest per reservation. However, the same guest can make multiple reservations.
5. John[\*] Find a reservation: Input is guest’s name and date, hotel ID. Output is reservation ID
6. Eldho[\*] Add a service to a reservation: Input: ReservationID, specific service. Add it to the reservation for a particular date. Multiple services are allowed on a reservation for the same date.
7. John[\*] Show reservation details: Input the reservation ID and print all information about this reservation
8.  Graig[\*] Cancel a reservation: Input the reservationID and mark the reservation as cancelled (do NOT delete it)
9. John[\*\*] Change a reservationDate: Input the reservation ID and change reservation start and end date, if there is availability in the same room type for the new date interval
10. Eldho[\*\*] Change a reservationRoomType: Input the reservation ID and change reservation room type if there is availability for that room type during the reservation’s date interval
11. Nick[\*\*] Available Rooms at hotel: Input a specific hotel ID a room type and a date interval. Return the number of available rooms of that type during the interval.
12. Nick[\*] AvailabilityOfRoomHotelPerInterval: Input a room type, hotel ID, date interval and return the number of available rooms during that time interval 
13. Graig[\*\*\*] RoomCheckoutReceipt: Input: ReservationID  Output: 
a. Guest name
b. Room number, rate per day and possibly multiple rooms (if someone reserved several rooms) 
c. Services rendered per date, type, and amount
d. Discounts applied (if any)
e. Total amount to be paid 
14. Jesse[\*] SoldHotels: Print all sold hotel information. Show ID, location, etc. 
15. Nick[\*] ShowCancelations: Print all canceled reservations in the hotel management system. Show reservation ID, hotel name, location, guest name, room type, dates
16. Nick[\*\*] SpecificHotelReport: Input: hotelID, start-date, end-date. Print (for the given time interval): 
a. Income by room type
b. Income of services, by service type
c. Total income from all sources.
17. Graig[\*\*] TotalHiltontMontlyReport: Total income from all sources of all hotels. Totals must be printed by month, and for each month by room type, service type. Include discounts.
18. Nick[\*\*] TotalHiltontStateReport: Input is state. Print total income from all sources of all hotels by room type and service type in the given state. Include discounts.

The asterisks denote level of difficulty. 
