-- Create the HotelChain Table
CREATE TABLE HotelChain (
    name VARCHAR(255) PRIMARY KEY,
    address TEXT NOT NULL,
    hotel_num INTEGER NOT NULL CHECK (hotel_num > 0),
    email_adrs VARCHAR(255) NOT NULL,
    phone_num VARCHAR(20) NOT NULL
);

-- Create the Hotel Table
CREATE TABLE Hotel (
    hotel_id SERIAL PRIMARY KEY,
    chain_id VARCHAR(255) REFERENCES HotelChain(name),
    name VARCHAR(255) NOT NULL,
    hotel_address TEXT NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_num VARCHAR(20) NOT NULL,
    star_category INTEGER NOT NULL CHECK (star_category BETWEEN 1 AND 5),
    room_amnt INTEGER NOT NULL CHECK (room_amnt >= 0)
);

-- Create the rooms Table
CREATE TABLE Rooms (
    room_num SERIAL PRIMARY KEY,
    hotel_id INTEGER REFERENCES Hotel(hotel_id),
    price NUMERIC(10, 2) NOT NULL CHECK (price > 0),
    amenities TEXT NOT NULL,
    room_capacity VARCHAR(50) NOT NULL,
    view_type VARCHAR(50) CHECK (view_type IN ('sea', 'mountain', 'none')),
    ext_poss BOOLEAN NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('available', 'booked', 'damaged'))
);

-- Create the customer Table
CREATE TABLE Customer (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    sgn VARCHAR(50) NOT NULL,
    rgstr_date DATE NOT NULL
);

-- Create the  employee Table
CREATE TABLE Employee (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    sin VARCHAR(50) NOT NULL UNIQUE,
    role VARCHAR(50) NOT NULL,
    hotel_id INTEGER REFERENCES Hotel(hotel_id),
    is_manager BOOLEAN NOT NULL
);

-- Create the Booking Table
CREATE TABLE Booking (
    booking_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES Customer(customer_id),
    room_num INTEGER REFERENCES Rooms(room_num),
    booking_date DATE NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    CONSTRAINT chk_dates CHECK (check_in_date <= check_out_date)
);

-- Creat the  Renting Table
CREATE TABLE Renting (
    renting_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES Customer(customer_id),
    room_num INTEGER REFERENCES Rooms(room_num),
    renting_date DATE NOT NULL
);

-- Can be used for any additional constraints and indices as needed
ALTER TABLE Customer ADD CONSTRAINT unique_email UNIQUE(email);
ALTER TABLE Employee ADD CONSTRAINT unique_email UNIQUE(email);
ALTER TABLE HotelChain ADD CONSTRAINT unique_email_adrs UNIQUE(email_adrs);
ALTER TABLE Hotel ADD CONSTRAINT unique_email UNIQUE(email);


-- Trigger to Update Room Status on Booking 
CREATE OR REPLACE FUNCTION trg_update_room_status_on_booking()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Rooms
    SET status = 'booked'
    WHERE room_num = NEW.room_num;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_booking_insert
AFTER INSERT ON Booking
FOR EACH ROW
EXECUTE FUNCTION trg_update_room_status_on_booking();

--Trigger to Prevent Deleting a Hotel with Active Bookings
CREATE OR REPLACE FUNCTION trg_prevent_hotel_delete()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Booking WHERE room_num IN (SELECT room_num FROM Rooms WHERE hotel_id = OLD.hotel_id)) THEN
        RAISE EXCEPTION 'Cannot delete hotel with active bookings';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_hotel_delete
BEFORE DELETE ON Hotel
FOR EACH ROW
EXECUTE FUNCTION trg_prevent_hotel_delete();

-- Trigger to Update Room Status on Check-in
CREATE OR REPLACE FUNCTION trg_update_room_status_on_renting()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Rooms
    SET status = 'occupied'
    WHERE room_num = NEW.room_num;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_renting_insert
AFTER INSERT ON Renting
FOR EACH ROW
EXECUTE FUNCTION trg_update_room_status_on_renting();

-- Index on Primary Keys
CREATE INDEX idx_hotelchain_name ON HotelChain (name);
CREATE INDEX idx_hotel_hotel_id ON Hotel (hotel_id);
CREATE INDEX idx_rooms_room_num ON Rooms (room_num);
CREATE INDEX idx_customer_customer_id ON Customer (customer_id);
CREATE INDEX idx_employee_employee_id ON Employee (employee_id);
CREATE INDEX idx_booking_booking_id ON Booking (booking_id);
CREATE INDEX idx_renting_renting_id ON Renting (renting_id);

-- Index on Foreign Keys
CREATE INDEX idx_hotel_chain_id ON Hotel (chain_id);
CREATE INDEX idx_rooms_hotel_id ON Rooms (hotel_id);
CREATE INDEX idx_booking_customer_id ON Booking (customer_id);
CREATE INDEX idx_booking_room_num ON Booking (room_num);
CREATE INDEX idx_renting_customer_id ON Renting (customer_id);
CREATE INDEX idx_renting_room_num ON Renting (room_num);
CREATE INDEX idx_employee_hotel_id ON Employee (hotel_id);

-- Composite Indexes for Common Queries
CREATE INDEX idx_booking_dates ON Booking (check_in_date, check_out_date);
CREATE INDEX idx_rooms_status_capacity ON Rooms (status, room_capacity);

-- Indexes on Fields Used in WHERE Clauses
CREATE INDEX idx_rooms_price ON Rooms (price);
CREATE INDEX idx_rooms_view_type ON Rooms (view_type);
CREATE INDEX idx_customer_name ON Customer (name);
CREATE INDEX idx_employee_role ON Employee (role);

-- Index on Date Fields
CREATE INDEX idx_booking_check_in_date ON Booking (check_in_date);
CREATE INDEX idx_booking_check_out_date ON Booking (check_out_date);
CREATE INDEX idx_renting_renting_date ON Renting (renting_date);
