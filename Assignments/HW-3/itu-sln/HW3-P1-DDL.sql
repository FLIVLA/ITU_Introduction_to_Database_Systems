--  Homework 3 - Solution to Part 1
--  Copyright (C) 2023 Jorge Quiane
--  based on material from Björn Þór Jónsson and Eleni Tzirita Zacharatou

-- 1. People

CREATE TABLE People (
    ID INT,
    Name VARCHAR NOT NULL,
    Address VARCHAR NOT NULL,
    Phone INT NOT NULL,
    DOB DATE NOT NULL,
    DOD DATE NULL,
    PRIMARY KEY (ID)
);


-- 10A. Opponents 

CREATE TABLE Opponent (
    ID INT,
    PRIMARY KEY (ID)
);

-- 2. Enemies and Members

-- Does not capture covering constraint

CREATE TABLE Member (
    ID INT REFERENCES People,
    Start_date DATE NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE Enemy (
    ID INT REFERENCES People,
    Reason VARCHAR NOT NULL,
    PRIMARY KEY (ID),

 	-- 10B. Enemy is an opponent
	OpponentID INT NOT NULL REFERENCES Opponent(ID)
);

-- 3. Assets of Members

CREATE TABLE Asset (
    ID INT REFERENCES Member,
    Name VARCHAR NOT NULL,
    Detail VARCHAR NOT NULL,
    Uses VARCHAR NOT NULL,
    PRIMARY KEY (ID, Name)
);

-- 4. Linkings / 5. Monitors

CREATE TABLE Linking (
    ID INT,
    Name VARCHAR(50) NOT NULL,
    Type CHAR(1) NOT NULL,
    Description VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);

-- Does not capture participation requirements

CREATE TABLE Participate (
    LinkingID INT REFERENCES Linking(ID),
    PeopleID INT REFERENCES People(ID),
    PRIMARY KEY (LinkingID, PeopleID),

	-- 5. Monitors
    MonitorID INT NOT NULL REFERENCES Member(ID)
);

-- 6. Roles

CREATE TABLE Role (
    ID INT, 
    Title VARCHAR NOT NULL,
    Salary INTEGER NOT NULL,
    PRIMARY KEY (ID),
    UNIQUE (Title)
);

CREATE TABLE Serve_in (
    RoleID INT REFERENCES Role (ID),
    MemberID INT REFERENCES Member (ID),
    Start_date DATE NOT NULL,
    End_date DATE NOT NULL,
    PRIMARY KEY (RoleID, MemberID)
);

-- 7. Parties
-- 10C. Party is an opponent

CREATE TABLE Party (
    ID INT,
    Name VARCHAR NOT NULL,
    Country VARCHAR NOT NULL,
    PRIMARY KEY (ID),
    UNIQUE (Name, Country),

	-- 10B. Party is an opponent
    OpponentID INT NOT NULL REFERENCES Opponent(ID)
);

CREATE TABLE Monitor (
    PartyID INT REFERENCES Party(ID),
    MonitorID INT NOT NULL REFERENCES Member(ID),
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (PartyID, start_date)
);

-- 8. Sponsors

CREATE TABLE Sponsor (
    ID INT,
    Name VARCHAR NOT NULL,
    Address VARCHAR NOT NULL,
    Industry VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE Grants (
    -- These columns for the sponsorships
    SponsorID INT REFERENCES Sponsor (ID),
    MemberID INT REFERENCES Member (ID),
    Date DATE,
    Amount INT NOT NULL,
    Payback VARCHAR NOT NULL,
    PRIMARY KEY (SponsorID, MemberID, Date)
);

-- 9. Sponsorships reviews

-- This can also be done with option 2, with a new ID in Grants, which would simplify the Reviews table
CREATE TABLE Reviews (
    SponsorID INT,
    MemberID INT,
    GrantDate DATE,
    ReviewerID INT NOT NULL REFERENCES Member(ID),
    ReviewDate DATE NOT NULL,
    Grade INT NULL,
    PRIMARY KEY (SponsorID, MemberID, GrantDate),
    FOREIGN KEY (SponsorID, MemberID, GrantDate) REFERENCES Grants(SponsorID, MemberID, Date),
    CHECK ((Grade >= 1) AND (Grade <=10))
);

-- 10D. Opposes relationship

CREATE TABLE Opposes (
    MemberID INT REFERENCES Member(ID),
    OpponentID INT REFERENCES Opponent(ID),
    Start_Date DATE NOT NULL,
    End_Date DATE NULL,
    PRIMARY KEY (MemberID, OpponentID)
);