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