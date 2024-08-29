IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Aeropuerto')
BEGIN
    DROP DATABASE Aeropuerto;
END;
GO

CREATE DATABASE Aeropuerto;
GO

USE Aeropuerto;
GO
--1. Pais
create table pais(
	id_pais int IDENTITY(1,1) primary key not null,
	nombre varchar(50) not null
);


CREATE INDEX idx_nombre_pais ON pais(nombre);

--2. Tabla ciudad
create table ciudad(
	id_ciudad int IDENTITY(1,1) primary key,
	id_pais integer not null,
	nombre varchar(50) not null,
	foreign key (id_pais) REFERENCES pais(id_pais) on update cascade on delete cascade
);
CREATE INDEX idx_id_pais_ciudad ON ciudad(id_pais);
CREATE INDEX idx_nombre_ciudad ON ciudad(nombre);

--3. Tabla Airport
create table Airport
(
	id_airport int IDENTITY(1,1)  PRIMARY key not null ,
	id_ciudad int not null,
	name VARCHAR(50) not null,
	foreign key (id_ciudad) REFERENCES ciudad (id_ciudad) on update cascade on DELETE cascade
);
CREATE INDEX idx_id_ciudad_airport ON Airport(id_ciudad);
CREATE INDEX idx_name_airport ON Airport(name);

--4. Tabla document
create table document(
	id_document int IDENTITY primary key,
	descripcion varchar(50) not null,
	check (id_document > 0)
);

CREATE INDEX idx_descripcion_document ON document(descripcion);

--5. Tabla flight_category
create table flight_category(
	id_category int IDENTITY(1,1) primary key,
	descripcion varchar(50) not null
);

CREATE INDEX idx_descripcion_flight_category ON flight_category(descripcion);
 
 --6. Tabla Plane_Model
create table Plane_Model
(
	id_plane_model int IDENTITY(1,1)  PRIMARY key not null ,
	description VARCHAR(256) not null,
	graphic VARCHAR(256)
)

CREATE INDEX idx_description_plane_model ON Plane_Model(description);
CREATE INDEX idx_graphic_plane_model ON Plane_Model(graphic);


--7. Tabla Flight_Number
create table Flight_Number
(
	id_flight_number int IDENTITY(1,1)  PRIMARY key ,
	id_airport_start int not null,
	id_airport_goal int not null,
	id_plane_model int not null,
	deperture_time time not null,
	description varchar(256),
	type VARCHAR(50),
	airline VARCHAR(100) not null,
	foreign key (id_airport_start) REFERENCES Airport (id_airport) ON UPDATE NO ACTION ON DELETE NO ACTION,
	foreign key (id_airport_goal) REFERENCES Airport (id_airport)  ON UPDATE NO ACTION ON DELETE NO ACTION,
	foreign key (id_plane_model) REFERENCES Plane_Model(id_plane_model) ON UPDATE NO ACTION ON DELETE NO ACTION 
);

CREATE INDEX idx_id_airport_start_flight_number ON Flight_Number(id_airport_start);
CREATE INDEX idx_id_airport_goal_flight_number ON Flight_Number(id_airport_goal);
CREATE INDEX idx_id_plane_model_flight_number ON Flight_Number(id_plane_model);
CREATE INDEX idx_deperture_time_flight_number ON Flight_Number(deperture_time);



--8. Tabla Airplane
create table Airplane(
	registration_number integer PRIMARY key not null,
	id_plane_model int not null,
	begin_operacion date, 
	status varchar(50),
	foreign key (id_plane_model) REFERENCES Plane_Model(id_plane_model) on UPDATE CASCADE on DELETE CASCADE
);

CREATE INDEX idx_id_plane_model_airplane ON Airplane(id_plane_model);
CREATE INDEX idx_status_airplane ON Airplane(status);



--9. Tabla seat
create table seat
(
	id_seat int IDENTITY(1,1) primary key not null,
	id_plane_model int not null,
	size int not null,
	location char(50) not NULL,
	foreign key (id_plane_model) REFERENCES Plane_Model(id_plane_model) on update cascade on delete cascade
	
);

CREATE INDEX idx_id_plane_model_seat ON seat(id_plane_model);
CREATE INDEX idx_location_seat ON seat(location);



--10. Tabla Flight
create table Flight
(
	id_flight int IDENTITY(1,1)  primary key ,
	id_flight_category int,
	boarding_time TIME not null,
	flight_date date not null,
	gate VARCHAR(50) null,
	check_in_counter varchar(256) not null,
	foreign key (id_flight_category) REFERENCES flight_category(id_category) on update cascade on delete cascade
);

CREATE INDEX idx_id_flight_category_flight ON Flight(id_flight_category);
CREATE INDEX idx_boarding_time_flight ON Flight(boarding_time);
CREATE INDEX idx_flight_date_flight ON Flight(flight_date);



--11. Tabla Frequent_Flyer_card
create table Frequent_Flyer_card
(
	id_ffc int IDENTITY(1,1)  primary key,
	ffc_numbre integer not null,
	miles integer not null,
	meal_code varchar(50) 
);

CREATE INDEX idx_ffc_numbre_ffc ON Frequent_Flyer_card(ffc_numbre);
CREATE INDEX idx_miles_ffc ON Frequent_Flyer_card(miles);


--12. Tabla Customer
create table Customer
(
	id_customer int IDENTITY(1,1)  primary key,
	id_ffc int not null,
	date_bith date not null,
	id_document int not null,
	name varchar(256) not null,
	foreign key (id_ffc) REFERENCES Frequent_Flyer_card(id_ffc),
	foreign key (id_document) REFERENCES document(id_document) on update cascade on delete cascade
);


CREATE INDEX idx_id_ffc_customer ON Customer(id_ffc);
CREATE INDEX idx_id_document_customer ON Customer(id_document);


--13. Tabla ticket
create table ticket
(
	id_ticket int IDENTITY(1,1)  PRIMARY KEY,
	id_customer int not null,
	ticketing_code varchar(256) not null,
	number integer not null,
	foreign key (id_customer) REFERENCES Customer(id_customer) on update cascade on delete cascade
);

CREATE INDEX idx_id_customer_ticket ON ticket(id_customer);
CREATE INDEX idx_ticketing_code_ticket ON ticket(ticketing_code);


--14. Tabla Available_Seat
create table Available_Seat
(
	id_available_seat int IDENTITY(1,1)  primary key not null,
	id_seat int not null,
	id_flight int not null,
	foreign key (id_flight) REFERENCES flight(id_flight) on update no action on delete no action,
	foreign key (id_seat) REFERENCES Seat(id_seat) on update cascade on delete cascade
);

CREATE INDEX idx_id_seat_available_seat ON Available_Seat(id_seat);
CREATE INDEX idx_id_flight_available_seat ON Available_Seat(id_flight);


--15. Tabla Coupon
create table 	Coupon
(
	id_coupon int IDENTITY(1,1)  PRIMARY key,
	id_ticket int not null,
	id_available_seat int,
	id_flight int not NULL,
	date_redemtion date not null,
	class varchar(50) not null,
	stanby char not null,
	meal_code varchar(50),
	foreign key (id_ticket) REFERENCES ticket(id_ticket) on update cascade on delete cascade,
	foreign key (id_flight) REFERENCES flight(id_flight) on update cascade on delete no action,
	foreign key (id_available_seat) REFERENCES Available_Seat(id_available_seat) on update cascade on delete no action
);
--
CREATE INDEX idx_id_ticket_coupon ON Coupon(id_ticket);
CREATE INDEX idx_id_available_seat_coupon ON Coupon(id_available_seat);
CREATE INDEX idx_id_flight_coupon ON Coupon(id_flight);
CREATE INDEX idx_date_redemtion_coupon ON Coupon(date_redemtion);



--16. Tabla Pieces_Luggage
create table Pieces_Luggage
(
	id_pLuggage int IDENTITY(1,1)  primary key,
	id_coupon int not null,
	number integer not null,
	weight decimal(12,2) not null,
	foreign key (id_coupon) REFERENCES coupon(id_coupon) on update cascade on delete no action
);

CREATE INDEX idx_id_coupon_pieces_luggage ON Pieces_Luggage(id_coupon);
CREATE INDEX idx_number_pieces_luggage ON Pieces_Luggage(number);


INSERT INTO pais (nombre) VALUES ('Argentina');
INSERT INTO pais (nombre) VALUES ('Brasil');
INSERT INTO pais (nombre) VALUES ('Chile');
INSERT INTO pais (nombre) VALUES ('Colombia');
INSERT INTO pais (nombre) VALUES ('Perú');
INSERT INTO pais (nombre) VALUES ('México');
INSERT INTO pais (nombre) VALUES ('Uruguay');
INSERT INTO pais (nombre) VALUES ('Paraguay');
INSERT INTO pais (nombre) VALUES ('Bolivia');
INSERT INTO pais (nombre) VALUES ('Ecuador');
select * from pais; 

INSERT INTO ciudad (id_pais, nombre) VALUES (1, 'Santa Cruz De La Sierra');  -- Bolivia
INSERT INTO ciudad (id_pais, nombre) VALUES (1, 'Córdoba');        -- Argentina
INSERT INTO ciudad (id_pais, nombre) VALUES (2, 'São Paulo');      -- Brasil
INSERT INTO ciudad (id_pais, nombre) VALUES (2, 'Río de Janeiro'); -- Brasil
INSERT INTO ciudad (id_pais, nombre) VALUES (3, 'Santiago');       -- Chile
INSERT INTO ciudad (id_pais, nombre) VALUES (3, 'Valparaíso');     -- Chile
INSERT INTO ciudad (id_pais, nombre) VALUES (4, 'Bogotá');         -- Colombia
INSERT INTO ciudad (id_pais, nombre) VALUES (4, 'Medellín');       -- Colombia
INSERT INTO ciudad (id_pais, nombre) VALUES (5, 'Lima');           -- Perú
INSERT INTO ciudad (id_pais, nombre) VALUES (5, 'Arequipa');       -- Perú
select * from ciudad; 

INSERT INTO Airport (id_ciudad, name) VALUES (1, 'Aeropuerto Internacional Ministro Pistarini'); -- Buenos Aires, Argentina
INSERT INTO Airport (id_ciudad, name) VALUES (1, 'Aeropuerto Internacional de Córdoba');           -- Córdoba, Argentina
INSERT INTO Airport (id_ciudad, name) VALUES (2, 'Aeroporto Internacional de São Paulo/Guarulhos'); -- São Paulo, Brasil
INSERT INTO Airport (id_ciudad, name) VALUES (2, 'Aeroporto Santos Dumont');                        -- Río de Janeiro, Brasil
INSERT INTO Airport (id_ciudad, name) VALUES (3, 'Aeropuerto Internacional Arturo Merino Benítez'); -- Santiago, Chile
INSERT INTO Airport (id_ciudad, name) VALUES (3, 'Aeropuerto de Valparaíso');                       -- Valparaíso, Chile
INSERT INTO Airport (id_ciudad, name) VALUES (4, 'Aeropuerto Internacional El Dorado');            -- Bogotá, Colombia
INSERT INTO Airport (id_ciudad, name) VALUES (4, 'Aeropuerto Internacional José María Córdova');    -- Medellín, Colombia
INSERT INTO Airport (id_ciudad, name) VALUES (5, 'Aeropuerto Internacional Jorge Chávez');          -- Lima, Perú
INSERT INTO Airport (id_ciudad, name) VALUES (5, 'Aeropuerto Rodríguez Ballón'); 
select * from Airport; 

INSERT INTO document (descripcion) VALUES ('Documento Personal');
INSERT INTO document (descripcion) VALUES ('Pasaporte');
INSERT INTO document (descripcion) VALUES ('Documento Personal');
INSERT INTO document (descripcion) VALUES ('Pasaporte');
INSERT INTO document (descripcion) VALUES ('Documento Personal');
INSERT INTO document (descripcion) VALUES ('Pasaporte');
INSERT INTO document (descripcion) VALUES ('Documento Personal');
INSERT INTO document (descripcion) VALUES ('Pasaporte');
INSERT INTO document (descripcion) VALUES ('Documento Personal');
INSERT INTO document (descripcion) VALUES ('Pasaporte');
select * from document; 

INSERT INTO flight_category (descripcion) VALUES ('Económica');
INSERT INTO flight_category (descripcion) VALUES ('Ejecutiva');
INSERT INTO flight_category (descripcion) VALUES ('Primera Clase');
INSERT INTO flight_category (descripcion) VALUES ('Business Class');
INSERT INTO flight_category (descripcion) VALUES ('Clase Turista');
INSERT INTO flight_category (descripcion) VALUES ('Clase Premium');
INSERT INTO flight_category (descripcion) VALUES ('Clase Business Premium');
INSERT INTO flight_category (descripcion) VALUES ('Clase Ejecutiva Internacional');
INSERT INTO flight_category (descripcion) VALUES ('Clase Premium Economy');
INSERT INTO flight_category (descripcion) VALUES ('Clase Básica');
select * from flight_category;

INSERT INTO Plane_Model (description, graphic) VALUES ('Boeing 737', 'http://example.com/boeing737.png');
INSERT INTO Plane_Model (description, graphic) VALUES ('Airbus A320', 'http://example.com/airbusa320.png');
INSERT INTO Plane_Model (description, graphic) VALUES ('Boeing 747', 'http://example.com/boeing747.png');
INSERT INTO Plane_Model (description, graphic) VALUES ('Airbus A380', 'http://example.com/airbusa380.png');
INSERT INTO Plane_Model (description, graphic) VALUES ('Boeing 787', 'http://example.com/boeing787.png');
INSERT INTO Plane_Model (description, graphic) VALUES ('Airbus A330', 'http://example.com/airbusa330.png');
INSERT INTO Plane_Model (description, graphic) VALUES ('Boeing 767', 'http://example.com/boeing767.png');
INSERT INTO Plane_Model (description, graphic) VALUES ('Airbus A321', 'http://example.com/airbusa321.png');
INSERT INTO Plane_Model (description, graphic) VALUES ('Boeing 757', 'http://example.com/boeing757.png');
INSERT INTO Plane_Model (description, graphic) VALUES ('Airbus A319', 'http://example.com/airbusa319.png');
select * from Plane_Model; 

INSERT INTO Flight_Number (id_airport_start, id_airport_goal, id_plane_model, deperture_time, description, type, airline)
VALUES (1, 3, 1, '14:30:00', 'Vuelo directo a Santiago', 'Internacional', 'Aerolíneas Argentinas');

INSERT INTO Flight_Number (id_airport_start, id_airport_goal, id_plane_model, deperture_time, description, type, airline)
VALUES (2, 4, 2, '09:15:00', 'Vuelo con escala en Bogotá', 'Regional', 'LATAM Airlines');

INSERT INTO Flight_Number (id_airport_start, id_airport_goal, id_plane_model, deperture_time, description, type, airline)
VALUES (3, 5, 3, '17:45:00', 'Vuelo nocturno a Lima', 'Internacional', 'Chileair');

INSERT INTO Flight_Number (id_airport_start, id_airport_goal, id_plane_model, deperture_time, description, type, airline)
VALUES (4, 1, 4, '07:00:00', 'Vuelo temprano de Bogotá a Buenos Aires', 'Internacional', 'Avianca');

INSERT INTO Flight_Number (id_airport_start, id_airport_goal, id_plane_model, deperture_time, description, type, airline)
VALUES (5, 2, 5, '20:00:00', 'Vuelo de noche a São Paulo', 'Regional', 'Peruvian Airlines');

INSERT INTO Flight_Number (id_airport_start, id_airport_goal, id_plane_model, deperture_time, description, type, airline)
VALUES (1, 2, 6, '12:30:00', 'Vuelo directo a São Paulo', 'Internacional', 'Gol Linhas Aéreas');

INSERT INTO Flight_Number (id_airport_start, id_airport_goal, id_plane_model, deperture_time, description, type, airline)
VALUES (2, 3, 7, '16:00:00', 'Vuelo con escala en Buenos Aires', 'Regional', 'Sky Airline');

INSERT INTO Flight_Number (id_airport_start, id_airport_goal, id_plane_model, deperture_time, description, type, airline)
VALUES (3, 4, 8, '10:30:00', 'Vuelo a Bogotá con conexión', 'Internacional', 'AeroSur');

INSERT INTO Flight_Number (id_airport_start, id_airport_goal, id_plane_model, deperture_time, description, type, airline)
VALUES (4, 5, 9, '22:15:00', 'Vuelo de medianoche a Lima', 'Regional', 'JetSMART');

INSERT INTO Flight_Number (id_airport_start, id_airport_goal, id_plane_model, deperture_time, description, type, airline)
VALUES (5, 1, 10, '06:00:00', 'Vuelo matutino a Buenos Aires', 'Internacional', 'TAM Airlines');
select * from Flight_Number; 

INSERT INTO Airplane (registration_number, id_plane_model, begin_operacion, status)
VALUES (1001, 1, '2015-05-01', 'En operación'); -- Boeing 737

INSERT INTO Airplane (registration_number, id_plane_model, begin_operacion, status)
VALUES (1002, 2, '2016-03-15', 'En operación'); -- Airbus A320

INSERT INTO Airplane (registration_number, id_plane_model, begin_operacion, status)
VALUES (1003, 3, '2017-07-20', 'En mantenimiento'); -- Boeing 747

INSERT INTO Airplane (registration_number, id_plane_model, begin_operacion, status)
VALUES (1004, 4, '2018-09-10', 'En operación'); -- Airbus A380

INSERT INTO Airplane (registration_number, id_plane_model, begin_operacion, status)
VALUES (1005, 5, '2019-01-25', 'En operación'); -- Boeing 787

INSERT INTO Airplane (registration_number, id_plane_model, begin_operacion, status)
VALUES (1006, 6, '2020-02-14', 'En reparación'); -- Airbus A330

INSERT INTO Airplane (registration_number, id_plane_model, begin_operacion, status)
VALUES (1007, 7, '2021-05-30', 'En operación'); -- Boeing 767

INSERT INTO Airplane (registration_number, id_plane_model, begin_operacion, status)
VALUES (1008, 8, '2021-11-05', 'En operación'); -- Airbus A321

INSERT INTO Airplane (registration_number, id_plane_model, begin_operacion, status)
VALUES (1009, 9, '2022-03-22', 'En revisión'); -- Boeing 757

INSERT INTO Airplane (registration_number, id_plane_model, begin_operacion, status)
VALUES (1010, 10, '2022-07-15', 'En operación'); -- Airbus A319
select * from Airplane; 

INSERT INTO seat (id_plane_model, size, location) VALUES (1, 1, 'A1'); -- Boeing 737
INSERT INTO seat (id_plane_model, size, location) VALUES (1, 1, 'A2'); -- Boeing 737
INSERT INTO seat (id_plane_model, size, location) VALUES (1, 1, 'B1'); -- Boeing 737
INSERT INTO seat (id_plane_model, size, location) VALUES (2, 2, 'C1'); -- Airbus A320
INSERT INTO seat (id_plane_model, size, location) VALUES (2, 2, 'C2'); -- Airbus A320
INSERT INTO seat (id_plane_model, size, location) VALUES (3, 3, 'D1'); -- Boeing 747
INSERT INTO seat (id_plane_model, size, location) VALUES (3, 3, 'D2'); -- Boeing 747
INSERT INTO seat (id_plane_model, size, location) VALUES (4, 4, 'E1'); -- Airbus A380
INSERT INTO seat (id_plane_model, size, location) VALUES (4, 4, 'E2'); -- Airbus A380
INSERT INTO seat (id_plane_model, size, location) VALUES (5, 2, 'F1'); -- Boeing 787
select * from seat; 

INSERT INTO Flight (id_flight_category, boarding_time, flight_date, gate, check_in_counter)
VALUES (1, '14:00:00', '2024-09-01', 'Gate 5', 'Counter 1'); -- Categoría 1

INSERT INTO Flight (id_flight_category, boarding_time, flight_date, gate, check_in_counter)
VALUES (2, '16:30:00', '2024-09-01', 'Gate 7', 'Counter 2'); -- Categoría 2

INSERT INTO Flight (id_flight_category, boarding_time, flight_date, gate, check_in_counter)
VALUES (3, '09:15:00', '2024-09-02', 'Gate 2', 'Counter 3'); -- Categoría 3

INSERT INTO Flight (id_flight_category, boarding_time, flight_date, gate, check_in_counter)
VALUES (4, '11:00:00', '2024-09-02', 'Gate 8', 'Counter 4'); -- Categoría 4

INSERT INTO Flight (id_flight_category, boarding_time, flight_date, gate, check_in_counter)
VALUES (5, '12:45:00', '2024-09-03', 'Gate 3', 'Counter 5'); -- Categoría 5

INSERT INTO Flight (id_flight_category, boarding_time, flight_date, gate, check_in_counter)
VALUES (6, '13:30:00', '2024-09-03', 'Gate 6', 'Counter 6'); -- Categoría 6

INSERT INTO Flight (id_flight_category, boarding_time, flight_date, gate, check_in_counter)
VALUES (7, '15:00:00', '2024-09-04', 'Gate 9', 'Counter 7'); -- Categoría 7

INSERT INTO Flight (id_flight_category, boarding_time, flight_date, gate, check_in_counter)
VALUES (8, '10:00:00', '2024-09-04', 'Gate 4', 'Counter 8'); -- Categoría 8

INSERT INTO Flight (id_flight_category, boarding_time, flight_date, gate, check_in_counter)
VALUES (9, '17:45:00', '2024-09-05', 'Gate 1', 'Counter 9'); -- Categoría 9

INSERT INTO Flight (id_flight_category, boarding_time, flight_date, gate, check_in_counter)
VALUES (10, '18:30:00', '2024-09-05', 'Gate 10', 'Counter 10'); -- Categoría 10
select * from Flight; 

INSERT INTO Frequent_Flyer_card (ffc_numbre, miles, meal_code) VALUES (1001, 5000, 'Vegan');
INSERT INTO Frequent_Flyer_card (ffc_numbre, miles, meal_code) VALUES (1002, 15000, 'Vegetarian');
INSERT INTO Frequent_Flyer_card (ffc_numbre, miles, meal_code) VALUES (1003, 25000, 'Non-Vegetarian');
INSERT INTO Frequent_Flyer_card (ffc_numbre, miles, meal_code) VALUES (1004, 3000, 'Halal');
INSERT INTO Frequent_Flyer_card (ffc_numbre, miles, meal_code) VALUES (1005, 8000, 'Kosher');
INSERT INTO Frequent_Flyer_card (ffc_numbre, miles, meal_code) VALUES (1006, 12000, 'Gluten-Free');
INSERT INTO Frequent_Flyer_card (ffc_numbre, miles, meal_code) VALUES (1007, 18000, NULL); -- Sin código de comida
INSERT INTO Frequent_Flyer_card (ffc_numbre, miles, meal_code) VALUES (1008, 22000, 'Diabetic');
INSERT INTO Frequent_Flyer_card (ffc_numbre, miles, meal_code) VALUES (1009, 35000, 'Pescatarian');
INSERT INTO Frequent_Flyer_card (ffc_numbre, miles, meal_code) VALUES (1010, 4000, 'Lactose-Free');
select * from Frequent_Flyer_card;

INSERT INTO Customer (id_ffc, date_bith, id_document, name) VALUES (1, '1980-01-15', 1, 'Juan Pérez');
INSERT INTO Customer (id_ffc, date_bith, id_document, name) VALUES (2, '1985-05-25', 2, 'María González');
INSERT INTO Customer (id_ffc, date_bith, id_document, name) VALUES (3, '1990-10-10', 1, 'Carlos Rodríguez');
INSERT INTO Customer (id_ffc, date_bith, id_document, name) VALUES (4, '1975-07-30', 2, 'Ana López');
INSERT INTO Customer (id_ffc, date_bith, id_document, name) VALUES (5, '1988-03-22', 1, 'Luis Martínez');
INSERT INTO Customer (id_ffc, date_bith, id_document, name) VALUES (6, '1995-12-01', 2, 'Laura Fernández');
INSERT INTO Customer (id_ffc, date_bith, id_document, name) VALUES (7, '2000-06-14', 1, 'Pedro Sánchez');
INSERT INTO Customer (id_ffc, date_bith, id_document, name) VALUES (8, '1982-09-05', 2, 'Elena Castro');
INSERT INTO Customer (id_ffc, date_bith, id_document, name) VALUES (9, '1993-11-23', 1, 'Ricardo Moreno');
INSERT INTO Customer (id_ffc, date_bith, id_document, name) VALUES (10, '1987-04-19', 2, 'Sofía Vargas');
select * from Customer;

INSERT INTO ticket (id_customer, ticketing_code, number) VALUES (1, 'TIC123456789', 101);
INSERT INTO ticket (id_customer, ticketing_code, number) VALUES (2, 'TIC123456790', 102);
INSERT INTO ticket (id_customer, ticketing_code, number) VALUES (3, 'TIC123456791', 103);
INSERT INTO ticket (id_customer, ticketing_code, number) VALUES (4, 'TIC123456792', 104);
INSERT INTO ticket (id_customer, ticketing_code, number) VALUES (5, 'TIC123456793', 105);
INSERT INTO ticket (id_customer, ticketing_code, number) VALUES (6, 'TIC123456794', 106);
INSERT INTO ticket (id_customer, ticketing_code, number) VALUES (7, 'TIC123456795', 107);
INSERT INTO ticket (id_customer, ticketing_code, number) VALUES (8, 'TIC123456796', 108);
INSERT INTO ticket (id_customer, ticketing_code, number) VALUES (9, 'TIC123456797', 109);
INSERT INTO ticket (id_customer, ticketing_code, number) VALUES (10, 'TIC123456798', 110);
select * from ticket;

INSERT INTO Available_Seat (id_seat, id_flight) VALUES (1, 1);
INSERT INTO Available_Seat (id_seat, id_flight) VALUES (2, 1);
INSERT INTO Available_Seat (id_seat, id_flight) VALUES (3, 1);
INSERT INTO Available_Seat (id_seat, id_flight) VALUES (4, 2);
INSERT INTO Available_Seat (id_seat, id_flight) VALUES (5, 2);
INSERT INTO Available_Seat (id_seat, id_flight) VALUES (6, 2);
INSERT INTO Available_Seat (id_seat, id_flight) VALUES (7, 3);
INSERT INTO Available_Seat (id_seat, id_flight) VALUES (8, 3);
INSERT INTO Available_Seat (id_seat, id_flight) VALUES (9, 3);
INSERT INTO Available_Seat (id_seat, id_flight) VALUES (10, 4);
select * from Available_Seat;

INSERT INTO Coupon (id_ticket, id_available_seat, id_flight, date_redemtion, class, stanby, meal_code) VALUES (1, 1, 1, '2024-08-28', 'Economy', 'N', 'Meal001');
INSERT INTO Coupon (id_ticket, id_available_seat, id_flight, date_redemtion, class, stanby, meal_code) VALUES (2, 2, 1, '2024-08-28', 'Business', 'Y', 'Meal002');
INSERT INTO Coupon (id_ticket, id_available_seat, id_flight, date_redemtion, class, stanby, meal_code) VALUES (3, 3, 2, '2024-08-29', 'Economy', 'N', 'Meal003');
INSERT INTO Coupon (id_ticket, id_available_seat, id_flight, date_redemtion, class, stanby, meal_code) VALUES (4, 4, 2, '2024-08-30', 'First', 'Y', 'Meal004');
INSERT INTO Coupon (id_ticket, id_available_seat, id_flight, date_redemtion, class, stanby, meal_code) VALUES (5, 5, 3, '2024-08-31', 'Economy', 'N', 'Meal005');
INSERT INTO Coupon (id_ticket, id_available_seat, id_flight, date_redemtion, class, stanby, meal_code) VALUES (6, 6, 3, '2024-09-01', 'Business', 'Y', 'Meal006');
INSERT INTO Coupon (id_ticket, id_available_seat, id_flight, date_redemtion, class, stanby, meal_code) VALUES (7, 7, 4, '2024-09-02', 'Economy', 'N', 'Meal007');
INSERT INTO Coupon (id_ticket, id_available_seat, id_flight, date_redemtion, class, stanby, meal_code) VALUES (8, 8, 4, '2024-09-03', 'Business', 'Y', 'Meal008');
INSERT INTO Coupon (id_ticket, id_available_seat, id_flight, date_redemtion, class, stanby, meal_code) VALUES (9, 9, 5, '2024-09-04', 'First', 'N', 'Meal009');
INSERT INTO Coupon (id_ticket, id_available_seat, id_flight, date_redemtion, class, stanby, meal_code) VALUES (10, 10, 5, '2024-09-05', 'Economy', 'Y', 'Meal010');
select * from Coupon;

INSERT INTO Pieces_Luggage (id_coupon, number, weight) VALUES (1, 1, 23.45);
INSERT INTO Pieces_Luggage (id_coupon, number, weight) VALUES (2, 2, 15.75);
INSERT INTO Pieces_Luggage (id_coupon, number, weight) VALUES (3, 3, 30.10);
INSERT INTO Pieces_Luggage (id_coupon, number, weight) VALUES (4, 4, 25.50);
INSERT INTO Pieces_Luggage (id_coupon, number, weight) VALUES (5, 5, 18.20);
INSERT INTO Pieces_Luggage (id_coupon, number, weight) VALUES (6, 6, 22.35);
INSERT INTO Pieces_Luggage (id_coupon, number, weight) VALUES (7, 7, 27.90);
INSERT INTO Pieces_Luggage (id_coupon, number, weight) VALUES (8, 8, 16.65);
INSERT INTO Pieces_Luggage (id_coupon, number, weight) VALUES (9, 9, 29.55);
INSERT INTO Pieces_Luggage (id_coupon, number, weight) VALUES (10, 10, 20.00);
select * from Pieces_Luggage;