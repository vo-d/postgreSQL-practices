/* Dai Dai Vo - 3129620 */

/* Q1e */
CREATE TABLE AIRPORT(
    Airport_code CHAR(25),
    Name CHAR(50) NOT NULL,
    City CHAR(50) NOT NULL,
    State CHAR(50) NOT NULL,
    CONSTRAINT pk1 PRIMARY KEY(Airport_code)
);


CREATE TABLE AIRPLANE_TYPE(
    Airplane_type_name CHAR(25),
    Max_seats INT NOT NULL,
    Company CHAR(50) NOT NULL,
    CONSTRAINT pk2 PRIMARY KEY(Airplane_type_name)
);


CREATE TABLE AIRPLANE(
    Airplane_id INT,
    Total_number_of_seats INT NOT NULL,
    Airplane_type CHAR(50),
    CONSTRAINT fk11 FOREIGN KEY (Airplane_type) REFERENCES AIRPLANE_TYPE(Airplane_type_name),
    CONSTRAINT pk3 PRIMARY KEY(Airplane_id)
);


CREATE TABLE FLIGHT(
    Flight_number CHAR(25),
    Airline CHAR(50) NOT NULL,
    Weekdays CHAR(5) CHECK (Weekdays = 'Yes' OR Weekdays = 'No') NOT NULL,
    CONSTRAINT pk4 PRIMARY KEY(Flight_number)
);

CREATE TABLE FLIGHT_LEG(
    Flight_number CHAR(25),
    leg_number INT,
    Departure_airport_code CHAR(50),
    Scheduled_departure_time TIME NOT NULL,
    Arrival_airport_code CHAR(50),
    Scheduled_arrival_time TIME NOT NULL,
    CONSTRAINT fk1 FOREIGN KEY (Flight_number) REFERENCES FLIGHT(Flight_number),
    CONSTRAINT fk2 FOREIGN KEY (Departure_airport_code) REFERENCES AIRPORT(Airport_code),
    CONSTRAINT fk3 FOREIGN KEY (Arrival_airport_code) REFERENCES AIRPORT(Airport_code),
    CONSTRAINT ck1 PRIMARY KEY(Flight_number, leg_number),
    CONSTRAINT check_schedule CHECK (Scheduled_arrival_time > Scheduled_departure_time)
);


CREATE TABLE LEG_INSTANCE(
    Flight_number CHAR(25),
    leg_number INT,
    Date DATE,
    Number_of_available_seats INT NOT NULL,
    Airplane_id INT,
    Departure_airport_code CHAR(50),
    Departure_time TIME NOT NULL,
    Arrival_airport_code CHAR(50),
    Arrival_time TIME NOT NULL,
    CONSTRAINT fk4 FOREIGN KEY (Flight_number, leg_number) REFERENCES FLIGHT_LEG(Flight_number, leg_number),
    CONSTRAINT fk5 FOREIGN KEY (Airplane_id) REFERENCES AIRPLANE(Airplane_id),
    CONSTRAINT fk6 FOREIGN KEY (Departure_airport_code) REFERENCES AIRPORT(Airport_code),
    CONSTRAINT fk7 FOREIGN KEY (Arrival_airport_code) REFERENCES AIRPORT(Airport_code),
    CONSTRAINT ck2 PRIMARY KEY(Flight_number, leg_number, Date),
    CONSTRAINT check_date CHECK (Arrival_time > Departure_time)
);


CREATE TABLE FARE(
    Flight_number CHAR(25),
    Fare_code CHAR(25),
    Amount INT NOT NULL,
    Restriction CHAR(50),
    CONSTRAINT fk8 FOREIGN KEY (Flight_number) REFERENCES FLIGHT(Flight_number),
    CONSTRAINT ck3 PRIMARY KEY(Flight_number, Fare_code)
);


CREATE TABLE CAN_LAND(
    Airplane_type_name CHAR(25),
    Airport_code CHAR(25),
    CONSTRAINT fk9 FOREIGN KEY (Airplane_type_name) REFERENCES AIRPLANE_TYPE(Airplane_type_name),
    CONSTRAINT fk10 FOREIGN KEY (Airport_code) REFERENCES AIRPORT(Airport_code),
    CONSTRAINT ck4 PRIMARY KEY(Airplane_type_name, Airport_code)
);


CREATE TABLE SEAT_RESERVATION(
    Flight_number CHAR(25),
    leg_number INT,
    Date DATE,
    Seat_number CHAR(25),
    Customer_name CHAR(50) NOT NULL,
    Customer_phone char(25) NOT NULL,
    CONSTRAINT fk12 FOREIGN KEY (Flight_number, leg_number, Date) REFERENCES LEG_INSTANCE(Flight_number, leg_number, Date),
    CONSTRAINT ck5 PRIMARY KEY(Flight_number, leg_number, Date, Seat_number)
);


/* Q1f */
ALTER TABLE FLIGHT_LEG DROP CONSTRAINT fk1;
ALTER TABLE FLIGHT_LEG ADD 
CONSTRAINT fk1 FOREIGN KEY (Flight_number) REFERENCES FLIGHT(Flight_number)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE LEG_INSTANCE DROP CONSTRAINT fk4;
ALTER TABLE LEG_INSTANCE ADD 
CONSTRAINT fk4 FOREIGN KEY (Flight_number, leg_number) REFERENCES FLIGHT_LEG(Flight_number, leg_number)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE FARE DROP CONSTRAINT fk8;
ALTER TABLE FARE ADD 
CONSTRAINT fk8 FOREIGN KEY (Flight_number) REFERENCES FLIGHT(Flight_number)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE SEAT_RESERVATION DROP CONSTRAINT fk12;
ALTER TABLE SEAT_RESERVATION ADD 
CONSTRAINT fk12 FOREIGN KEY (Flight_number, leg_number, Date) REFERENCES LEG_INSTANCE(Flight_number, leg_number, Date)
ON DELETE CASCADE
ON UPDATE CASCADE;