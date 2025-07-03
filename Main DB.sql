-- Club Table
CREATE TABLE Club (
    VenueId SERIAL PRIMARY KEY, -- Unique identifier for the venue
    VenueName VARCHAR(50) NOT NULL UNIQUE, -- Name of the venue
    Capacity INT NOT NULL CHECK (Capacity > 0) -- Maximum capacity of the venue
);

-- Artist Table
CREATE TABLE Artist (
    ArtistId SERIAL PRIMARY KEY, -- Unique identifier for the artist
    ArtistName VARCHAR(50) NOT NULL UNIQUE, -- Name of the artist
    Nationality VARCHAR(50) NOT NULL, -- Nationality of the artist
    ArtistPhoneNumber VARCHAR(20) NOT NULL -- Phone number of the artist
);

-- Event Table
CREATE TABLE Events (
    EventId SERIAL PRIMARY KEY, -- Unique identifier for the event
    EventName VARCHAR(50) NOT NULL, -- Name of the event
    SeatNumber INT NOT NULL CHECK (SeatNumber > 0), -- Number of seats available for the event
    TicketPrice DECIMAL(10, 2) NOT NULL CHECK (TicketPrice > 0), -- Price of the ticket for the event
    ArtistId INT NOT NULL, -- Foreign key referencing the Artist table
    VenueId INT NOT NULL, -- Foreign key referencing the Club table
    EventStatus VARCHAR(50) NOT NULL CHECK (EventStatus IN ('cancelled', 'passed', 'active')), -- Status of the event
    EventDate DATE NOT NULL, -- Date of the event
    CONSTRAINT FK_Event_ArtistId FOREIGN KEY (ArtistId) REFERENCES Artist(ArtistId),
    CONSTRAINT FK_Event_VenueId FOREIGN KEY (VenueId) REFERENCES Club(VenueId),
    CONSTRAINT UC_EventName UNIQUE (EventName)
);

-- Booking Table
CREATE TABLE Booking (
    BookingId SERIAL PRIMARY KEY, -- Unique identifier for the booking
    TicketNumber INT NOT NULL, -- Number of tickets booked
    EventId INT NOT NULL, -- Foreign key referencing the Event table
    AmountToBePaid DECIMAL(10, 2) NOT NULL, -- Amount to be paid for the booking
    BookingStatus VARCHAR(50) NOT NULL CHECK (BookingStatus IN ('cancelled', 'active', 'sold')), -- Status of the booking
    BookingDate DATE NOT NULL, -- Date of the booking
    RefundAmount DECIMAL(10, 2), -- Amount refunded for cancelled booking
    RefundDate DATE, -- Date of the refund
    CONSTRAINT FK_Booking_EventId FOREIGN KEY (EventId) REFERENCES Events(EventId),
    CONSTRAINT CHK_Booking_TicketNumber CHECK (TicketNumber > 0),
    CONSTRAINT CHK_RefundAmount CHECK (RefundAmount IS NULL OR RefundAmount >= 0),
    CONSTRAINT CHK_RefundDate CHECK (RefundDate IS NULL OR RefundDate >= BookingDate)
);

-- Payment Table
-- Payment Table
CREATE TABLE Payment (
    PaymentId SERIAL PRIMARY KEY, -- Unique identifier for the payment
    BookingId INT NOT NULL, -- Foreign key referencing the Booking table
    AccountId INT NOT NULL, -- Foreign key referencing the Account table
    PaymentAmount DECIMAL(10, 2) NOT NULL, -- Amount paid
    PaymentDate DATE NOT NULL, -- Date of the payment
    PaymentMethod VARCHAR(50) NOT NULL, -- Payment method used (e.g., credit card, PayPal)
    CONSTRAINT FK_Payment_BookingId FOREIGN KEY (BookingId) REFERENCES Booking(BookingId),
    CONSTRAINT FK_Payment_AccountId FOREIGN KEY (AccountId) REFERENCES Account(AccountId)
);
drop table Payment;

-- Account Table
CREATE TABLE Account (
    AccountId Serial PRIMARY KEY, -- Unique identifier for the account
    AccountName VARCHAR(50) , -- Name of the account holder
    Email VARCHAR(100)  -- Email address of the account holder
);

DROP TABLE Account CASCADE;


INSERT INTO Artist (ArtistName, Nationality, ArtistPhoneNumber) VALUES
('Abdul Hanan', 'Pakistan', '123-456-7890'),
('QB', 'Pakistan', '987-654-3210'),
('Bayaan', 'Pakistan', '456-789-0123');

INSERT INTO Club (VenueName, Capacity) VALUES
('Faculty Club', 200),
('Sprts Indoor', 150),
('Football Ground', 300);

INSERT INTO Events (EventName, SeatNumber, TicketPrice, ArtistId, VenueId, EventStatus, EventDate) VALUES
('AIAA', 150, 1500.00, 1, 1, 'active', '2024-05-10'),
('SOPHEP', 100, 2000.00, 2, 2, 'active', '2024-06-15'),
('EAT FEST', 300, 1800.00, 3, 3, 'active', '2024-07-20');

SELECT b.BookingId, b.TicketNumber, b.AmountToBePaid, b.BookingStatus, b.BookingDate, p.PaymentAmount, p.PaymentDate, p.PaymentMethod, e.EventName, e.EventDate
FROM Booking b
INNER JOIN Events e ON b.EventId = e.EventId
LEFT JOIN Payment p ON b.BookingId = p.BookingId;



-- Drop the existing foreign key constraint
ALTER TABLE Payment
DROP CONSTRAINT fk_payment_bookingid;

-- Add the new foreign key constraint with ON DELETE CASCADE
ALTER TABLE Payment
ADD CONSTRAINT fk_payment_bookingid
FOREIGN KEY (BookingId) REFERENCES Booking (BookingId) ON DELETE CASCADE;


select * from Club;
select * from Artist;
select * from Events;
select * from Booking;
select * from Payment;
select * from account;