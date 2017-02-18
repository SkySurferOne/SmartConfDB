-- ==========================================================================================
-- Authors: Damian Hanusiak, Gabriela Kowalik
-- Desciption: Script creates database with name hanusiak_a and adds tables for 
--       SmartConf project (conference management).
--       Code contains procedures, functions and triggers as well.
-- ==========================================================================================
 
-- DROP DATABASE hanusiak_a -- Do not use on IISG!

-- Database creating
USE master;
IF DB_ID('hanusiak_a') IS NULL
BEGIN
	CREATE DATABASE hanusiak_a;
	PRINT 'DB "hanusiak_a" has been created.';
END
ELSE 
BEGIN
	PRINT 'DB "hanusiak_a" already exist';
END
USE hanusiak_a;

-- Tables deletion
IF OBJECT_ID('WorkshopParticipant', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKWorkshopPaPerPa', 'C') IS NOT NULL ALTER TABLE WorkshopParticipant DROP CONSTRAINT FKWorkshopPaPerPa;
	IF OBJECT_ID('FKWorkshopPaPerPaWo', 'C') IS NOT NULL ALTER TABLE WorkshopParticipant DROP CONSTRAINT FKWorkshopPaPerPaWo;
	IF OBJECT_ID('FKWorkshopPaPerPaConfD', 'C') IS NOT NULL ALTER TABLE WorkshopParticipant DROP CONSTRAINT FKWorkshopPaPerPaConfD;
	DROP TABLE WorkshopParticipant;
END;

IF OBJECT_ID('ConferenceDayParticipant', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKConferenceDPPerConferenceDay', 'C') IS NOT NULL ALTER TABLE ConferenceDayParticipant DROP CONSTRAINT FKConferenceDPPerConferenceDay;
	IF OBJECT_ID('FKConferenceDPPerOrder', 'C') IS NOT NULL ALTER TABLE ConferenceDayParticipant DROP CONSTRAINT FKConferenceDPPerOrder;
	IF OBJECT_ID('FKConferenceDPPerParticipant', 'C') IS NOT NULL ALTER TABLE ConferenceDayParticipant DROP CONSTRAINT FKConferenceDPPerParticipant;
	DROP TABLE ConferenceDayParticipant;
END;

IF OBJECT_ID('OrderedWorkshop', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKOrderedWorkshopPerOConfD', 'C') IS NOT NULL ALTER TABLE OrderedWorkshop DROP CONSTRAINT FKOrderedWorkshopPerOConfD;
	IF OBJECT_ID('FKOrderedWorkshopPerWorkshop', 'C') IS NOT NULL ALTER TABLE OrderedWorkshop DROP CONSTRAINT FKOrderedWorkshopPerWorkshop;
	DROP TABLE OrderedWorkshop;
END;

IF OBJECT_ID('Workshop', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKWorkshopPerConfDay', 'C') IS NOT NULL ALTER TABLE Workshop DROP CONSTRAINT FKWorkshopPerConfDay;
	DROP TABLE Workshop;
END;

IF OBJECT_ID('OrderedConfDay', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKOrderedConfDayPerConferenceDay', 'C') IS NOT NULL ALTER TABLE OrderedConfDay DROP CONSTRAINT FKOrderedConfDayPerConferenceDay;
	IF OBJECT_ID('FKOrderedConfDayPerOrder', 'C') IS NOT NULL ALTER TABLE OrderedConfDay DROP CONSTRAINT FKOrderedConfDayPerOrder;
	DROP TABLE OrderedConfDay;
END;

IF OBJECT_ID('Discount', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKDiscountPerConference', 'C') IS NOT NULL ALTER TABLE Discount DROP CONSTRAINT FKDiscountPerConference;
	DROP TABLE Discount;
END;

IF OBJECT_ID('ConferenceDay', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKConferenceDayPerConf', 'C') IS NOT NULL ALTER TABLE ConferenceDay DROP CONSTRAINT FKConferenceDayPerConf; 
	DROP TABLE ConferenceDay;
END;

IF OBJECT_ID('Conference', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKConferencePerCategory', 'C') IS NOT NULL ALTER TABLE Conference DROP CONSTRAINT FKConferencePerCategory; 
	DROP TABLE Conference;
END;

IF OBJECT_ID('Employee', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKEmployeePerCompany', 'C') IS NOT NULL ALTER TABLE Employee DROP CONSTRAINT FKEmployeePerCompany;
	IF OBJECT_ID('FKEmployeePerParticipant', 'C') IS NOT NULL ALTER TABLE Employee DROP CONSTRAINT FKEmployeePerParticipant;
	DROP TABLE Employee;
END;

IF OBJECT_ID('Student', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKStudentPerParticipant', 'C') IS NOT NULL ALTER TABLE Student DROP CONSTRAINT FKStudentPerParticipant;
	DROP TABLE Student;
END;

IF OBJECT_ID('Order', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKOrderPerClient', 'C') IS NOT NULL ALTER TABLE [Order] DROP CONSTRAINT FKOrderPerClient;
	DROP TABLE [Order];
END;

IF OBJECT_ID('Category', 'U') IS NOT NULL 
	DROP TABLE Category;

IF OBJECT_ID('CompanyClients', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKCompanyClientsPerClients', 'C') IS NOT NULL ALTER TABLE CompanyClients DROP CONSTRAINT FKCompanyClientsPerClients;
	IF OBJECT_ID('FKCompanyClientsPerCompany', 'C') IS NOT NULL ALTER TABLE CompanyClients DROP CONSTRAINT FKCompanyClientsPerCompany;
	DROP TABLE CompanyClients;
END;

IF OBJECT_ID('PrivateClients', 'U') IS NOT NULL 
BEGIN
	IF OBJECT_ID('FKPrivateClientsPerClients', 'C') IS NOT NULL ALTER TABLE PrivateClients DROP CONSTRAINT FKPrivateClientsPerClients;
	IF OBJECT_ID('FKPrivateClientsPerParticipant', 'C') IS NOT NULL ALTER TABLE PrivateClients DROP CONSTRAINT FKPrivateClientsPerParticipant;
	DROP TABLE PrivateClients;
END;

IF OBJECT_ID('Company', 'U') IS NOT NULL
	DROP TABLE Company;
	
IF OBJECT_ID('Participant', 'U') IS NOT NULL 
	DROP TABLE Participant;
	
IF OBJECT_ID('Clients', 'U') IS NOT NULL 
	DROP TABLE Clients;

-- Table creating
CREATE TABLE Category (
  CategoryID  int IDENTITY(1, 1) NOT NULL, 
  Name        nvarchar(50) NOT NULL UNIQUE, 
  Description nvarchar(255) NULL, 
  PRIMARY KEY (CategoryID)
);

CREATE TABLE Conference (
  ConferenceID  int IDENTITY(1, 1) NOT NULL, 
  CategoryID    int NOT NULL, 
  Name          nvarchar(50) NOT NULL, 
  Description   nvarchar(255) NULL,
  StartDateTime datetime NOT NULL, 
  Address       nvarchar(50) NOT NULL,
  City          nvarchar(50) NOT NULL,
  Country       nvarchar(50) NOT NULL,
  PRIMARY KEY (ConferenceID),
  CONSTRAINT FKConferencePerCategory FOREIGN KEY (CategoryID) REFERENCES Category (CategoryID),
  CONSTRAINT CheckStartDateTime CHECK (StartDateTime >= GETDATE())
);

CREATE TABLE Discount (
  DiscountID      int IDENTITY(1, 1) NOT NULL, 
  ConferenceID    int NOT NULL, 
  Value           int NOT NULL, 
  DueDate         date NULL, 
  StudentDiscount bit NOT NULL DEFAULT 0, 
  PRIMARY KEY (DiscountID, ConferenceID),
  CONSTRAINT FKDiscountPerConference FOREIGN KEY (ConferenceID) REFERENCES Conference (ConferenceID),
  CONSTRAINT CorrectDiscountValue CHECK (Value >= 0 and Value <= 100)
);
 
CREATE TABLE ConferenceDay (
  ConferenceDayID int IDENTITY(1, 1) NOT NULL, 
  ConferenceID    int NOT NULL, 
  Price           money NOT NULL,
  PlaceLimit	  int NULL,  
  DayNumber       int NOT NULL, 
  PRIMARY KEY (ConferenceDayID),
  CONSTRAINT FKConferenceDayPerConf FOREIGN KEY (ConferenceID) REFERENCES Conference (ConferenceID),
  CONSTRAINT CorrectPrice CHECK (Price >= 0),
  CONSTRAINT CorrectPlaceLimit CHECK (PlaceLimit >= 10),
  CONSTRAINT CorrectDayNumber CHECK (DayNumber >= 1)
);

-- Additional CONSTRAINTs on 'Alters' section  
CREATE TABLE Company (
  CompanyID  int IDENTITY(1, 1) NOT NULL, 
  Name       varchar(50) NOT NULL, 
  NIP        varchar(15) NULL, 
  Address    nvarchar(50) NULL, 
  City       nvarchar(50) NULL, 
  Country    nvarchar(50) NULL, 
  PostalCode char(6) NULL, 
  Email      varchar(50) NOT NULL, 
  Phone      varchar(9) NULL, 
  PRIMARY KEY (CompanyID),
  CONSTRAINT ParticipantCheckPostalCode CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]'),
  CONSTRAINT ParticipantCheckEmail CHECK (Email LIKE '[a-z,0-9,_,-]%@[a-z,0-9,_,-]%.[a-z][a-z]%'),
  CONSTRAINT ParticipantCheckPhone CHECK (Phone LIKE '[5-8][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

CREATE TABLE Participant (
  ParticipantID int IDENTITY(1, 1) NOT NULL, 
  FirstName     nvarchar(50) NOT NULL, 
  LastName      nvarchar(50) NOT NULL, 
  Address		nvarchar(50) NULL, 
  City			nvarchar(50) NULL, 
  Country		nvarchar(50) NULL, 
  PostalCode	char(6) NULL, 
  Email			varchar(50) NOT NULL, 
  Phone			varchar(9) NULL, 
  PRIMARY KEY (ParticipantID),
  CONSTRAINT CheckPostalCode CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]'),
  CONSTRAINT CheckEmail CHECK (Email LIKE '[a-z,0-9,_,-]%@[a-z,0-9,_,-]%.[a-z][a-z]%'),
  CONSTRAINT CheckPhone CHECK (Phone LIKE '[5-8][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

CREATE TABLE Employee (
  CompanyID     int NOT NULL, 
  ParticipantID int NOT NULL, 
  PRIMARY KEY (CompanyID, ParticipantID),
  CONSTRAINT FKEmployeePerCompany FOREIGN KEY (CompanyID) REFERENCES Company (CompanyID),
  CONSTRAINT FKEmployeePerParticipant FOREIGN KEY (ParticipantID) REFERENCES Participant (ParticipantID)
);
  
CREATE TABLE Workshop (
  WorkshopID      int IDENTITY(1, 1) NOT NULL, 
  ConferenceDayID int NOT NULL, 
  PlaceLimit      int NULL, 
  StartTime       time NOT NULL, 
  EndTime         time NULL, 
  Price           money NULL,
  Name            nvarchar(50) NOT NULL,
  Description     varchar(255) NULL,
  PRIMARY KEY (WorkshopID),
  CONSTRAINT FKWorkshopPerConfDay FOREIGN KEY (ConferenceDayID) REFERENCES ConferenceDay (ConferenceDayID),
  CONSTRAINT WorkshopBeginAndEndTime CHECK (StartTime < EndTime)
);
  
CREATE TABLE Student (
  ParticipantID int NOT NULL, 
  CardID        int NOT NULL, 
  PRIMARY KEY (ParticipantID),
  CONSTRAINT FKStudentPerParticipant FOREIGN KEY (ParticipantID) REFERENCES Participant (ParticipantID)
);
 
CREATE TABLE WorkshopParticipant (
  ParticipantID   int NOT NULL, 
  WorkshopID      int NOT NULL, 
  ConferenceDayID int NOT NULL, 
  OrderID         int NOT NULL, 
  PRIMARY KEY (ParticipantID, WorkshopID, ConferenceDayID),
  CONSTRAINT FKWorkshopPaPerPa FOREIGN KEY (ParticipantID) REFERENCES Participant (ParticipantID),
  CONSTRAINT FKWorkshopPaPerWo FOREIGN KEY (WorkshopID) REFERENCES Workshop (WorkshopID),
  CONSTRAINT FKWorkshopPaPerConfD FOREIGN KEY (ConferenceDayID) REFERENCES ConferenceDay (ConferenceDayID)
);

CREATE TABLE Clients (
  ClientID int IDENTITY(1, 1) NOT NULL, 
  PRIMARY KEY (ClientID)
);

-- Additional CONSTRAINTs on 'Alters' section
CREATE TABLE [Order] (
  OrderID     int IDENTITY(1, 1) NOT NULL, 
  ClientID    int NOT NULL, 
  OrderDate   date NOT NULL, 
  PaymentDate date NULL, 
  Canceled    bit NOT NULL DEFAULT 0,
  PRIMARY KEY (OrderID),
  CONSTRAINT FKOrderPerClient FOREIGN KEY (ClientID) REFERENCES Clients (ClientID)
);

CREATE TABLE OrderedConfDay (
  OrderedConfDayID int IDENTITY(1, 1) NOT NULL, 
  OrderID          int NOT NULL, 
  ConferenceDayID  int NOT NULL, 
  BookedSeats	   int NOT NULL DEFAULT 1, -- it can be 1 or more, in terms of priv. cli. it's always 1
  PricePerSeat     int NOT NULL,
  Discount		   float NULL
  PRIMARY KEY (OrderedConfDayID),
  CONSTRAINT FKOrderedConfDayPerOrder FOREIGN KEY (OrderID) REFERENCES [Order] (OrderID),
  CONSTRAINT FKOrderedConfDayPerConferenceDay FOREIGN KEY (ConferenceDayID) REFERENCES ConferenceDay (ConferenceDayID)
);
  
CREATE TABLE ConferenceDayParticipant (
  ParticipantID   int NOT NULL, 
  ConferenceDayID int NOT NULL, 
  OrderID         int NOT NULL, 
  PRIMARY KEY (ParticipantID, ConferenceDayID),
  CONSTRAINT FKConferenceDPPerConferenceDay FOREIGN KEY (ConferenceDayID) REFERENCES ConferenceDay (ConferenceDayID),
  CONSTRAINT FKConferenceDPPerParticipant FOREIGN KEY (ParticipantID) REFERENCES Participant (ParticipantID),
  CONSTRAINT FKConferenceDPPerOrder FOREIGN KEY (OrderID) REFERENCES [Order] (OrderID)
);
  
CREATE TABLE CompanyClients (
  CompanyID int NOT NULL, 
  ClientID  int NOT NULL, 
  PRIMARY KEY (CompanyID, ClientID),
  CONSTRAINT FKCompanyClientsPerCompany FOREIGN KEY (CompanyID) REFERENCES Company (CompanyID),
  CONSTRAINT FKCompanyClientsPerClients FOREIGN KEY (ClientID) REFERENCES Clients (ClientID)
);
 
CREATE TABLE PrivateClients (
  ParticipantID int NOT NULL, 
  ClientID      int NOT NULL, 
  PRIMARY KEY (ParticipantID, ClientID),
  CONSTRAINT FKPrivateClientsPerParticipant FOREIGN KEY (ParticipantID) REFERENCES Participant (ParticipantID),
  CONSTRAINT FKPrivateClientsPerClients FOREIGN KEY (ClientID) REFERENCES Clients (ClientID)
);
 
CREATE TABLE OrderedWorkshop (
  OrderedWorkshopID int IDENTITY(1, 1) NOT NULL, 
  OrderedConfDayID  int NOT NULL,
  WorkshopID        int NOT NULL, 
  BookedSeats		int NOT NULL DEFAULT 1, -- it can be 1 or more, in terms of priv. cli. it's always 1
  PricePerSeat      int NOT NULL, 
  PRIMARY KEY (OrderedWorkshopID),
  CONSTRAINT FKOrderedWorkshopPerOConfD FOREIGN KEY (OrderedConfDayID) REFERENCES OrderedConfDay (OrderedConfDayID),
  CONSTRAINT FKOrderedWorkshopPerWorkshop FOREIGN KEY (WorkshopID) REFERENCES Workshop (WorkshopID)
);

-- indexes
IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('Participant') AND NAME ='Ind_Participant_FirstName_LastName')
    DROP INDEX Ind_Participant_FirstName_LastName ON Participant;
IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('Company') AND NAME ='Ind_Company_Name')
    DROP INDEX Ind_Company_Name ON Company;
IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('Conference') AND NAME ='Ind_Conference_Name')
    DROP INDEX Ind_Conference_Name ON Conference;

CREATE INDEX Ind_Participant_FirstName_LastName
ON Participant
(
	FirstName,
	LastName
); 

CREATE INDEX Ind_Company_Name
ON Company
(
	Name
); 

CREATE INDEX Ind_Conference_Name
ON Conference
(
	Name
);

-- DROP FUNCTIONS
IF OBJECT_ID(N'CHECK_IF_ORDER_SHOULD_BE_CANCELED', N'FN') IS NOT NULL
    DROP FUNCTION CHECK_IF_ORDER_SHOULD_BE_CANCELED
GO
IF OBJECT_ID(N'CHECK_PAYMENTDATE', N'FN') IS NOT NULL
    DROP FUNCTION CHECK_PAYMENTDATE
GO
IF OBJECT_ID(N'COUNT_DISCOUNT', N'FN') IS NOT NULL
    DROP FUNCTION COUNT_DISCOUNT
GO
IF OBJECT_ID(N'CHECK_STUDENT_STATUS', N'FN') IS NOT NULL
    DROP FUNCTION CHECK_STUDENT_STATUS
GO
IF OBJECT_ID(N'GET_ORDER_PRICE', N'FN') IS NOT NULL
    DROP FUNCTION GET_ORDER_PRICE
GO
IF OBJECT_ID(N'GET_AVAILABLE_SEATS_ON_CONFDAY', N'FN') IS NOT NULL
    DROP FUNCTION GET_AVAILABLE_SEATS_ON_CONFDAY
GO
IF OBJECT_ID(N'GET_AVAILABLE_SEATS_ON_WORKSHOP', N'FN') IS NOT NULL
    DROP FUNCTION GET_AVAILABLE_SEATS_ON_WORKSHOP
GO
IF OBJECT_ID(N'GET_PAID_CONFERENCE_DAY_PLACES', N'FN') IS NOT NULL
    DROP FUNCTION GET_PAID_CONFERENCE_DAY_PLACES
GO
IF OBJECT_ID(N'GET_PAID_WORKSHOP_PLACES', N'FN') IS NOT NULL
    DROP FUNCTION GET_PAID_WORKSHOP_PLACES
GO
IF OBJECT_ID(N'IS_VALID_NIP', N'FN') IS NOT NULL
    DROP FUNCTION IS_VALID_NIP
GO
IF OBJECT_ID(N'WORKSHOPS_IN_THE_SAME_TIME', N'FN') IS NOT NULL
    DROP FUNCTION WORKSHOPS_IN_THE_SAME_TIME
GO
-- Functions 
-- ==========================================================================================
-- Author: Damian Hanusiak
-- Description: Returns 0 when @PaymentDate is filled and is before @OrderDate. 
-- Otherwise returns 1.
-- ==========================================================================================
CREATE FUNCTION CHECK_PAYMENTDATE (@PaymentDate date, @OrderDate date)
RETURNS bit
BEGIN
	DECLARE @toRet int = 1;
	IF(@PaymentDate IS NOT NULL AND @OrderDate > @PaymentDate)
		SET @toRet = 0;

	RETURN @toRet;
END
GO
-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: Returns 1 when workshops are at the same time, otherwise returns 0.
-- ==========================================================================================
CREATE FUNCTION WORKSHOPS_IN_THE_SAME_TIME (@WorkshopID_1 int, @WorkshopID_2 int)
RETURNS bit
BEGIN
	DECLARE @ConferenceDayID_1 int = (SELECT ConferenceDayID FROM Workshop WHERE WorkshopID = @WorkshopID_1)
	DECLARE @ConferenceDayID_2 int = (SELECT ConferenceDayID FROM Workshop WHERE WorkshopID = @WorkshopID_2)

	IF @ConferenceDayID_1 != @ConferenceDayID_2
		RETURN 0
	
	DECLARE @StartTime_1 time = (SELECT StartTime FROM Workshop WHERE WorkshopID = @WorkshopID_1)
	DECLARE @StartTime_2 time = (SELECT StartTime FROM Workshop WHERE WorkshopID = @WorkshopID_2)
	DECLARE @EndTime_1 time = (SELECT EndTime FROM Workshop WHERE WorkshopID = @WorkshopID_1)
	DECLARE @EndTime_2 time = (SELECT EndTime FROM Workshop WHERE WorkshopID = @WorkshopID_2)

	IF ((@StartTime_1 < @StartTime_2 AND @EndTime_1 >= @StartTime_2) OR
		(@StartTime_2 < @StartTime_1 AND @EndTime_2 >= @StartTime_1))
	RETURN 1

	RETURN 0
	
END
GO
-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: Returns 1 when order should be canceled, otherwise returns 0.
-- ==========================================================================================

CREATE FUNCTION CHECK_IF_ORDER_SHOULD_BE_CANCELED (@OrderID int)
RETURNS bit
AS
BEGIN
	DECLARE @OrderDate datetime = (SELECT OrderDate FROM [Order] WHERE OrderID = @OrderID)
	DECLARE @CurrentDate datetime = GETDATE()
	IF DATEADD(WEEK, 1, @OrderDate) < @CurrentDate RETURN 1
	RETURN 0
END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: Returns 1 when client has student status, otherwise returns 0.
-- ==========================================================================================
CREATE FUNCTION COUNT_DISCOUNT (@OrderDate datetime, @ConferenceDayID datetime, @Student bit)
RETURNS int
AS
BEGIN
	DECLARE @Discount AS int
	SET @Discount = (
		SELECT TOP 1 Value from Discount
		JOIN Conference ON Conference.ConferenceID = Discount.ConferenceID
		JOIN ConferenceDay ON ConferenceDay.ConferenceID = Conference.ConferenceID
		WHERE Discount.StudentDiscount in (0, @Student) and ConferenceDayID = @ConferenceDayID
		and (Discount.DueDate >= @OrderDate or (Discount.DueDate is null and Discount.StudentDiscount = 1))
		ORDER BY Value DESC 
	)
	RETURN isNull(@Discount, 0);
END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: Returns 1 when client has student status, otherwise returns 0.
-- ==========================================================================================
CREATE FUNCTION CHECK_STUDENT_STATUS (@ClientID int)
RETURNS bit
AS
BEGIN
	DECLARE @StudentCard AS int
	SET @StudentCard = (
		SELECT CardID FROM Clients
		JOIN PrivateClients ON PrivateClients.ClientID = Clients.ClientID
		JOIN Participant ON Participant.ParticipantID = PrivateClients.ParticipantID
		JOIN Student ON Student.ParticipantID = Participant.ParticipantID
		WHERE Clients.ClientID = @ClientID
		)
	IF @StudentCard IS NOT NULL RETURN 1
	RETURN 0
END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik, Damian Hanusiak
-- Description: Returns complete order price 
-- ==========================================================================================
CREATE FUNCTION GET_ORDER_PRICE (@OrderID int)
RETURNS float
AS
BEGIN
	DECLARE @Value float = (
						SELECT SUM(new.BookedSeats * new.PricePerSeat) FROM (
							SELECT BookedSeats, PricePerSeat * (1-(Discount/100)) AS 'PricePerSeat'
							FROM OrderedConfDay
 							WHERE OrderID = @OrderID

							UNION

							SELECT OW.BookedSeats, OW.PricePerSeat
							FROM OrderedWorkshop AS OW
							JOIN OrderedConfDay AS OCD
							ON OW.OrderedConfDayID = OCD.OrderedConfDayID
							WHERE OrderID = @OrderID)
						AS new
					);

	RETURN @Value;
END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik	
-- Description: Returns number of paid seats on conference day.
-- ==========================================================================================
CREATE FUNCTION GET_PAID_CONFERENCE_DAY_PLACES (@ConferenceDayID int)
RETURNS int
AS
BEGIN
	DECLARE @PaidPlaces int = (
								SELECT SUM(BookedSeats) FROM [Order]
								JOIN OrderedConfDay ON [Order].OrderID = OrderedConfDay.OrderID
								WHERE ConferenceDayID = @ConferenceDayID
								AND PaymentDate IS NOT NULL AND Canceled = 0
							)
	RETURN @PaidPlaces
END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik	
-- Description: Returns number of paid seats on workshop.
-- ==========================================================================================
CREATE FUNCTION GET_PAID_WORKSHOP_PLACES (@WorkshopID int)
RETURNS int
AS
BEGIN
	DECLARE @PaidPlaces int = (
								SELECT SUM(OrderedWorkshop.BookedSeats) FROM [Order]
								JOIN OrderedConfDay ON [Order].OrderID = OrderedConfDay.OrderID
								JOIN OrderedWorkshop ON OrderedConfDay.OrderedConfDayID = OrderedWorkshop.OrderedConfDayID
								WHERE WorkshopID = @WorkshopID
								AND PaymentDate IS NOT NULL AND Canceled = 0
							)
	RETURN @PaidPlaces
END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik	
-- Description: Returns avaliable seats on conference day.
-- ==========================================================================================
CREATE FUNCTION GET_AVAILABLE_SEATS_ON_CONFDAY (@ConferenceDayID int)
RETURNS int
AS
BEGIN
	DECLARE @BookedPlaces int = (	
									SELECT SUM(BookedSeats) 
									FROM OrderedConfDay AS OCD
									JOIN [Order] AS O
									ON OCD.OrderID = O.OrderID  
									WHERE ConferenceDayID = @ConferenceDayID AND O.Canceled = 0
								);

	DECLARE @AllPlaces int =	(
									SELECT PlaceLimit
									FROM ConferenceDay
									WHERE ConferenceDayID = @ConferenceDayID
								);

	DECLARE @AvailablePlaces int = @AllPlaces - isNull(@BookedPlaces, 0);
	RETURN @AvailablePlaces;
END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik	
-- Description: Returns avaliable seats on workshop.
-- ==========================================================================================
CREATE FUNCTION GET_AVAILABLE_SEATS_ON_WORKSHOP (@WorkshopID int)
RETURNS int
AS
BEGIN
	DECLARE @BookedPlaces int = (	
									SELECT SUM(OW.BookedSeats) 
									FROM OrderedWorkshop AS OW
									JOIN OrderedConfDay AS OCD
									ON OW.OrderedConfDayID = OCD.OrderedConfDayID
									JOIN [Order] AS O
									ON OCD.OrderID = O.OrderID  
									WHERE WorkshopID = @WorkshopID AND O.Canceled = 0
								);

	DECLARE @AllPlaces int =	(
									SELECT PlaceLimit
									FROM Workshop
									WHERE WorkshopID = @WorkshopID
								);

	DECLARE @AvailablePlaces int = @AllPlaces - @BookedPlaces;
	RETURN @AvailablePlaces
END
GO

-- ==========================================================================================
-- Author: Damian Hanusiak
-- Description: Validate NIP number 
-- Example of valid NIP: 106-00-00-062
-- Example of invalid NIP: 123-456-78-90
-- ==========================================================================================
CREATE FUNCTION IS_VALID_NIP (@nip varchar(15))
RETURNS bit
AS
BEGIN

	SELECT @nip = REPLACE(@nip,'-','')

	IF ISNUMERIC(@nip) = 0
		RETURN 0

	DECLARE
		@weights AS TABLE
		(
			Position tinyint IDENTITY(1,1) NOT NULL,
			Weight tinyint NOT NULL
		)
	INSERT INTO @weights VALUES (6), (5), (7), (2), (3), (4), (5), (6), (7)

	IF SUBSTRING(@nip, 10, 1) = (SELECT SUM(CONVERT(TINYINT, SUBSTRING(@nip, Position, 1)) * Weight) % 11 FROM @weights)
		RETURN 1

	RETURN 0

END
GO

-- Alters 
ALTER TABLE Company ADD CONSTRAINT CheckNip CHECK (dbo.IS_VALID_NIP (NIP) = 1);
ALTER TABLE [Order] ADD CONSTRAINT CheckOrderDateAndPaymentDate CHECK (dbo.CHECK_PAYMENTDATE(PaymentDate, OrderDate) = 1);

-- Drop views
IF OBJECT_ID('Reservation', 'V') IS NOT NULL 
	DROP VIEW Reservation
GO
IF OBJECT_ID('ClientOrder', 'V') IS NOT NULL 
	DROP VIEW ClientOrder
GO
IF OBJECT_ID('PrivateClientsView', 'V') IS NOT NULL 
	DROP VIEW PrivateClientsView
GO
IF OBJECT_ID('CompanyClientsView', 'V') IS NOT NULL 
	DROP VIEW CompanyClientsView
GO	
-- Views


-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: get list of private clients
-- ==========================================================================================
CREATE VIEW PrivateClientsView AS
	SELECT ClientID, FirstName + ' ' + LastName AS 'Name',
	Address + ' ' + PostalCode + ' ' + City + ', ' + Country as 'Full address',
	Phone FROM Participant
	JOIN PrivateClients ON PrivateClients.ParticipantID = Participant.ParticipantID
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: get list of company clients
-- ==========================================================================================
CREATE VIEW CompanyClientsView AS
	
	SELECT ClientID, Name AS 'Company Name',
	Address + ' ' + PostalCode + ' ' + City + ', ' + Country as 'Full address',
	Phone FROM Company
	JOIN CompanyClients ON Company.CompanyID = CompanyClients.ClientID
GO
-- ==========================================================================================
-- Author: Damian Hanusiak	
-- Description:	Reservations
-- ==========================================================================================
CREATE VIEW Reservation AS
SELECT
	CLI.ClientID,
	BookedSeats,
	Canceled,
	PaymentDate,
	ConferenceDayID,
	NULL AS 'WorkshopID'
FROM
	Clients AS CLI 
	JOIN [Order] AS O 
	ON CLI.ClientID = O.ClientID 
	JOIN OrderedConfDay AS OCD 
	ON O.OrderID = OCD.OrderID
UNION
SELECT
	CLI.ClientID,
	OW.BookedSeats,
	Canceled,
	PaymentDate,
	NULL AS 'ConferenceDayID',
	WorkshopID
FROM 
	Clients AS CLI 
	JOIN [Order] AS O
	ON CLI.ClientID = O.ClientID
	JOIN OrderedConfDay AS OCD
	ON O.OrderID = OCD.OrderID 
	JOIN OrderedWorkshop AS OW 
	ON OCD.OrderedConfDayID = OW.OrderedConfDayID
GO

-- ==========================================================================================
-- Author: Damian Hanusiak	
-- Description:	Client order
-- ==========================================================================================
CREATE VIEW ClientOrder AS
SELECT R.ClientID, R.ConferenceDayID, R.WorkshopID, R.BookedSeats,
	 (SELECT TOP 1 PricePerSeat FROM OrderedConfDay 
	  WHERE ConferenceDayID = R.ConferenceDayID) AS PricePerSeats
FROM Reservation AS R
WHERE R.ConferenceDayID IS NOT NULL
UNION
SELECT R.ClientID, R.ConferenceDayID, R.WorkshopID, R.BookedSeats,
	 (SELECT TOP 1 PricePerSeat FROM OrderedWorkshop
	  WHERE WorkshopID = R.WorkshopID) AS PricePerSeats
FROM Reservation AS R
WHERE R.WorkshopID IS NOT NULL
GO
-- DROP PROCEDURES
IF OBJECT_ID('ADD_CATEGORY', 'P') IS NOT NULL 
	DROP PROC ADD_CATEGORY;
GO
IF OBJECT_ID('ADD_CONFERENCE', 'P') IS NOT NULL 
	DROP PROC ADD_CONFERENCE;
GO
IF OBJECT_ID('ADD_CONFERENCE_2', 'P') IS NOT NULL 
	DROP PROC ADD_CONFERENCE_2;
GO
IF OBJECT_ID('ADD_PRIVATE_PARTICIPANT', 'P') IS NOT NULL 
	DROP PROC ADD_PRIVATE_PARTICIPANT
GO
IF OBJECT_ID('SET_STUDENT_STATUS', 'P') IS NOT NULL 
	DROP PROC SET_STUDENT_STATUS
GO
IF OBJECT_ID('ADD_DISCOUNT', 'P') IS NOT NULL 
	DROP PROC ADD_DISCOUNT
GO
IF OBJECT_ID('ADD_CONFERENCE_DAY', 'P') IS NOT NULL 
	DROP PROC ADD_CONFERENCE_DAY
GO
IF OBJECT_ID('ADD_WORKSHOP', 'P') IS NOT NULL 
	DROP PROC ADD_WORKSHOP
GO
IF OBJECT_ID('ADD_COMPANY_CLIENT', 'P') IS NOT NULL 
	DROP PROC ADD_COMPANY_CLIENT
GO
IF OBJECT_ID('ADD_EMPLOYEE', 'P') IS NOT NULL 
	DROP PROC ADD_EMPLOYEE
GO
IF OBJECT_ID('ADD_ORDER', 'P') IS NOT NULL 
	DROP PROC ADD_ORDER
GO
IF OBJECT_ID('UPDATE_PAYMENT_TIME', 'P') IS NOT NULL 
	DROP PROC UPDATE_PAYMENT_TIME
GO
IF OBJECT_ID('CANCEL_ORDER', 'P') IS NOT NULL 
	DROP PROC CANCEL_ORDER
GO
IF OBJECT_ID('UPDATE_ORDERS_STATUS', 'P') IS NOT NULL 
	DROP PROC UPDATE_ORDERS_STATUS
GO
IF OBJECT_ID('ADD_ORDERED_CONFERENCE_DAY', 'P') IS NOT NULL 
	DROP PROC ADD_ORDERED_CONFERENCE_DAY
GO
IF OBJECT_ID('ADD_ORDERED_WORKSHOP', 'P') IS NOT NULL 
	DROP PROC ADD_ORDERED_WORKSHOP
GO
IF OBJECT_ID('ADD_PARTICIPANT_TO_CONFERENCE_DAY', 'P') IS NOT NULL 
	DROP PROC ADD_PARTICIPANT_TO_CONFERENCE_DAY
GO
IF OBJECT_ID('ADD_PARTICIPANT_TO_WORKSHOP', 'P') IS NOT NULL 
	DROP PROC ADD_PARTICIPANT_TO_WORKSHOP
GO
IF OBJECT_ID('GET_WORKSHOP_PARTICIPANTS', 'P') IS NOT NULL 
	DROP PROC GET_WORKSHOP_PARTICIPANTS
GO
IF OBJECT_ID('GET_CONFERENCE_DAY_PARTICIPANTS', 'P') IS NOT NULL 
	DROP PROC GET_CONFERENCE_DAY_PARTICIPANTS
GO

-- Procedures
-- ==========================================================================================
-- Author: Damian Hanusiak	
-- Description:	Adds new category
-- Example execution: 
--	EXECUTE ADD_CATEGORY 'IT', 'information technology';
-- ==========================================================================================
CREATE PROCEDURE ADD_CATEGORY
	@Name nvarchar(50),
	@Description nvarchar(255)
	AS 
	BEGIN 
		SET NOCOUNT ON;
		INSERT INTO Category
		(Name, Description)
		VALUES (@Name, @Description);
	END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: inserts new company client
-- Example execution:
-- EXECUTE ADD_COMPANY_CLIENT 'Brand Rożek', '106-00-00-062', 'Rojalna 21',
-- 'Kraków', 'Polska', '32-080', 'a@a.pl', 623456789;
-- ==========================================================================================
CREATE PROCEDURE ADD_COMPANY_CLIENT
  @Name varchar(50),
  @NIP varchar(15), 
  @Address nvarchar(50),
  @City nvarchar(50), 
  @Country nvarchar(50), 
  @PostalCode char(6), 
  @Email varchar(50), 
  @Phone varchar(9)
  AS
  	DECLARE @ClientID int
  	DECLARE @CompanyID int
  	BEGIN
  		SET NOCOUNT ON
  		INSERT INTO Company (Name, NIP, Address, City, Country, PostalCode, Email, Phone)
  		VALUES (@Name, @NIP, @Address, @City, @Country, @PostalCode, @Email, @Phone)

  		INSERT INTO Clients DEFAULT VALUES

  		SELECT @ClientID = (SELECT TOP 1 ClientID FROM Clients ORDER BY ClientID DESC) 
  		SELECT @CompanyID = (SELECT TOP 1 CompanyID FROM Company ORDER BY CompanyID DESC) 
  		INSERT INTO CompanyClients(CompanyID, ClientID) VALUES (@CompanyID, @ClientID)

  	END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: Inserts new employee
-- Example execution:
-- EXECUTE ADD_EMPLOYEE 1, 'Misia', 'Pysia', 'Piekielna 666', 'Piekło', 'Polska',
-- '82-400', 'misia@gmail.com', '666666666'
-- ==========================================================================================
CREATE PROCEDURE ADD_EMPLOYEE
	@CompanyID int,
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@Address nvarchar(50),
	@City nvarchar(50),
	@Country nvarchar(50),
	@PostalCode	char(6), 
	@Email varchar(50),
	@Phone varchar(9)
	AS
		DECLARE @ParticipantID int
		BEGIN
			SET NOCOUNT ON
			INSERT INTO Participant (FirstName, LastName, Address, City, Country, PostalCode, Email, Phone)
			VALUES (@FirstName, @LastName, @Address, @City, @Country, @PostalCode, @Email, @Phone)
			SELECT @ParticipantID = (SELECT TOP 1 ParticipantID FROM Participant ORDER BY ParticipantID DESC) 
			INSERT INTO Employee (CompanyID, ParticipantID) VALUES (@CompanyID, @ParticipantID) 
		END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: Inserts new participant
-- Example execution:
-- EXECUTE ADD_PRIVATE_PARTICIPANT 'Jan', 'Kowalski', 'Piekielna 666', 'Piekło', 'Polska',
-- '82-400', 'jankowalskinie@gmail.com', '666666666'
-- ==========================================================================================
CREATE PROCEDURE ADD_PRIVATE_PARTICIPANT
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@Address nvarchar(50),
	@City nvarchar(50),
	@Country nvarchar(50),
	@PostalCode	char(6), 
	@Email varchar(50),
	@Phone varchar(9)
	AS
		DECLARE @ClientID int
		DECLARE @ParticipantID int
		BEGIN
			SET NOCOUNT ON
			INSERT INTO Participant
			(FirstName, LastName, Address, City, Country, PostalCode, Email, Phone)
			VALUES (@FirstName, @LastName, @Address, @City, @Country, @PostalCode, @Email, @Phone)
			INSERT INTO Clients DEFAULT VALUES
			SELECT @ClientID = (SELECT TOP 1 ClientID FROM Clients ORDER BY ClientID DESC) 
			SELECT @ParticipantID = (SELECT TOP 1 ParticipantID FROM Participant ORDER BY ParticipantID DESC) 
			INSERT INTO PrivateClients (ParticipantID, ClientID) VALUES (@ParticipantID, @ClientID)
		END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: Set participant as a student
-- Example execution:
-- EXECUTE SET_STUDENT_STATUS 2, 1111
-- ==========================================================================================
CREATE PROCEDURE SET_STUDENT_STATUS
	@ParticipantID int,
	@StudentCard int
	AS
	BEGIN
		INSERT INTO Student (ParticipantID, CardID)
		VALUES (@ParticipantID, @StudentCard)
	END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: Inserts new type of discount
-- Example execution:
-- EXECUTE ADD_DISCOUNT 1, 10, '20170618 10:50:09 AM', 1
-- ==========================================================================================
CREATE PROCEDURE ADD_DISCOUNT
	@ConferenceID int,
	@Value int,
	@DueDate date,
	@StudentDiscount bit
	AS
	BEGIN
		SET NOCOUNT ON
		INSERT INTO Discount
		(ConferenceID, Value, DueDate, StudentDiscount)
		VALUES
		(@ConferenceID, @Value, @DueDate, @StudentDiscount)
	END
GO

-- ==========================================================================================
-- Author: Damian Hanusiak	
-- Description:	Inserts new conference 
-- Example execution: 
-- EXECUTE ADD_CONFERENCE 1, 'TestConference', 'This is test conference', 
--   '20120618 10:34:09 AM', '20120618 10:50:09 AM', 'Długa 3/10', 'Kraków', 'Polska'
-- ==========================================================================================
CREATE PROCEDURE ADD_CONFERENCE
	@CategoryID int,
	@Name nvarchar(50),
	@Description nvarchar(255),
	@StartDateTime datetime,
	@Address nvarchar(50),
	@City nvarchar(50),
	@Country nvarchar(50)
	AS 
	BEGIN
		SET NOCOUNT ON;
		INSERT INTO Conference
		(CategoryID, Name, Description, StartDateTime, Address, City, Country)
		VALUES (@CategoryID, @Name, @Description, @StartDateTime, @Address, @City, @Country);
	END
GO

-- ==========================================================================================
-- Author: Damian Hanusiak	
-- Description:	Inserts new conference. 
--              Adds category to conference by its name not id.
-- Example execution: 
-- EXECUTE ADD_CONFERENCE_2 'IT', 'TestConference', 'This is test conference',
--   '20120618 10:34:09 AM', '20120618 10:50:09 AM', 'Długa 3/10', 'Kraków', 'Polska'
-- ==========================================================================================
CREATE PROCEDURE ADD_CONFERENCE_2
	@CategoryName nvarchar(50),
	@Name nvarchar(50),
	@Description varchar(255),
	@StartDateTime datetime,
	@Address nvarchar(50),
	@City nvarchar(50),
	@Country nvarchar(50)
	AS 
	BEGIN
		SET NOCOUNT ON;
		DECLARE @CategoryID int = (SELECT CategoryID FROM Category WHERE Name = @CategoryName);
		DECLARE @Err_msg varchar(30) = 'Category "'+@CategoryName+'" does not exist';

		IF @CategoryID IS NULL
			THROW 50000, @Err_msg, 1;

		INSERT INTO Conference
		(CategoryID, Name, Description, StartDateTime, Address, City, Country)
		VALUES (@CategoryID, @Name, @Description, @StartDateTime, @Address, @City, @Country);
	END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: inserts new conference day
-- Example execution:
-- EXECUTE ADD_CONFERENCE_DAY 1, 150, 51.99 
-- ==========================================================================================
CREATE PROCEDURE ADD_CONFERENCE_DAY
	@ConferenceID int,
	@PlaceLimit int,
	@Price money
	AS
	BEGIN
		SET NOCOUNT ON
		DECLARE @DayNumber int = isNULL((SELECT TOP 1 CD.DayNumber FROM ConferenceDay AS CD
							   WHERE CD.ConferenceID = @ConferenceID 
							   ORDER BY CD.DayNumber DESC), 0)+1;

		INSERT INTO ConferenceDay (ConferenceID, Price, PlaceLimit, DayNumber)
		VALUES (@ConferenceID, @Price, @PlaceLimit, @DayNumber)
	END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: inserts new workshop
-- Example execution:
-- EXECUTE ADD_WORKSHOP 1, 100, '20120618 11:00:00 AM', '20120618 13:50:00 PM', 5.99,
-- 'SQL - szczęście czy zło wcielone', 
-- 'Na warsztacie dowiemy się dlaczego powstały NOSQL i czy są one lepsze od SQLów'
-- ==========================================================================================
CREATE PROCEDURE ADD_WORKSHOP
  @ConferenceDayID int,
  @PlaceLimit int, 
  @StartTime time,
  @EndTime time, 
  @Price money,
  @Name nvarchar(50),
  @Description varchar(255)
  AS
  BEGIN
	SET NOCOUNT ON;
  	INSERT INTO Workshop
  	(ConferenceDayID, PlaceLimit, StartTime, EndTime, Price,Name, Description)
  	VALUES
  	(@ConferenceDayID, @PlaceLimit, @StartTime, @EndTime, @Price, @Name, @Description)
  END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: inserts new order
-- Example execution:
-- EXECUTE ADD_ORDER 1
-- ==========================================================================================
CREATE PROCEDURE ADD_ORDER
  @ClientID int
  AS
  BEGIN
	SET NOCOUNT ON;

	INSERT INTO [Order] (ClientID, OrderDate) VALUES (@ClientID, GETDATE())
  END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: update order's paytime
-- Example execution:
-- EXECUTE UPDATE_PAYMENT_TIME 1
-- ==========================================================================================
CREATE PROCEDURE UPDATE_PAYMENT_TIME
  @OrderID int
  AS
  BEGIN
	DECLARE @PaymentDate datetime
	SELECT @PaymentDate = GETDATE()
	UPDATE [Order]
  	SET PaymentDate = @PaymentDate
	WHERE OrderID = @OrderID
  END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: cancel (on demand) selected order
-- Example execution:
-- EXECUTE CANCEL_ORDER 1
-- ==========================================================================================
CREATE PROCEDURE CANCEL_ORDER
  @OrderID int
  AS
  BEGIN
	UPDATE [Order]
  	SET Canceled = 1
	WHERE OrderID = @OrderID
  END
GO

CREATE PROCEDURE UPDATE_ORDERS_STATUS
	AS
	BEGIN
		CREATE TABLE #TempTable (OrderID int, OrderDate datetime, PaymentDate datetime)
		INSERT INTO #TempTable
		SELECT OrderID, OrderDate, PaymentDate FROM [Order]
		WHERE PaymentDate is null AND Canceled = 0

		DECLARE @OrderID int

		WHILE (EXISTS (SELECT 1 FROM #TempTable))
		BEGIN
			SELECT TOP 1 @OrderID = OrderID FROM #TempTable
			IF dbo.CHECK_IF_ORDER_SHOULD_BE_CANCELED(@OrderID) = 1
			BEGIN
				EXECUTE CANCEL_ORDER @OrderID
			END
			DELETE FROM #TempTable WHERE OrderID = @OrderID
						
		END
	END
GO
-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: inserts new reservation for conference day
-- Example execution:
-- EXECUTE ADD_ORDERED_CONFERENCE_DAY 1, 1, 20
-- ==========================================================================================
CREATE PROCEDURE ADD_ORDERED_CONFERENCE_DAY
	@OrderID int,
	@ConferenceDayID int,
	@BookedSeats int
	AS
	BEGIN
		SET NOCOUNT ON
		DECLARE @Err_msg varchar(60)
		DECLARE @ClientID int = (SELECT ClientID FROM [Order] WHERE OrderID = @OrderID);
		IF (@ClientID IN (SELECT ClientID FROM PrivateClientsView) AND @BookedSeats != 1)
		BEGIN
			SELECT @Err_msg = 'You cannot book more than one seat.';
			THROW 50000, @Err_msg, 1;
		END
		DECLARE @StudentStatus bit = dbo.CHECK_STUDENT_STATUS(@ClientID);
		DECLARE @OrderDate date = (SELECT OrderDate from [Order] WHERE OrderID = @OrderID);
		DECLARE @PricePerSeat money = (SELECT Price FROM ConferenceDay WHERE ConferenceDayID = @ConferenceDayID);
		DECLARE @Discount int = dbo.COUNT_DISCOUNT(@OrderDate, @ConferenceDayID, @StudentStatus);
		INSERT INTO OrderedConfDay (OrderID, ConferenceDayID, BookedSeats, PricePerSeat, Discount)
		VALUES (@OrderID, @ConferenceDayID, @BookedSeats, @PricePerSeat, @Discount)
	END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: inserts new reservation for workshop
-- Example execution:
-- EXECUTE ADD_ORDERED_WORKSHOP 1,1,20
-- ==========================================================================================
CREATE PROCEDURE ADD_ORDERED_WORKSHOP
	@OrderedConferenceDayID int,
	@WorkshopID int,
	@BookedSeats int
	AS
	BEGIN
		SET NOCOUNT ON
		DECLARE @Err_msg varchar(60)
		DECLARE @BookedSeatsAtConferenceDay int = (SELECT BookedSeats FROM OrderedConfDay WHERE OrderedConfDayID = @OrderedConferenceDayID) 
		IF @BookedSeats > @BookedSeatsAtConferenceDay
		BEGIN
			SELECT @Err_msg = 'You cannot book more seats than at conference day';
			THROW 50000, @Err_msg, 1;
		END
		DECLARE @PricePerSeat money = (SELECT Price FROM Workshop WHERE WorkshopID = @WorkshopID) 
		INSERT INTO OrderedWorkshop(OrderedConfDayID, WorkshopID, BookedSeats, PricePerSeat)
		VALUES (@OrderedConferenceDayID, @WorkshopID, @BookedSeats, @PricePerSeat)
	END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: inserts new participant to conference day
-- Example execution:
-- EXECUTE ADD_PARTICIPANT_TO_CONFERENCE_DAY 1,1,1
-- ==========================================================================================
CREATE PROCEDURE ADD_PARTICIPANT_TO_CONFERENCE_DAY
	@ParticipantID int,
	@ConferenceDayID int,
	@OrderID int
	AS
	BEGIN
		SET NOCOUNT ON
		DECLARE @OrderedID int = (	SELECT ConferenceDayID
									FROM OrderedConfDay
									WHERE OrderID = @OrderID
									AND ConferenceDayID = @ConferenceDayID
								)
		IF (@OrderedID is not null)
		BEGIN
			INSERT INTO ConferenceDayParticipant (ParticipantID, ConferenceDayID, OrderID)
			VALUES (@ParticipantID, @ConferenceDayID, @OrderID)
		END
		ELSE
		BEGIN
			DECLARE @Err_msg varchar(60) = 'You cannot add participant without ordered day.';
			THROW 50000, @Err_msg, 1;
		END


	END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: inserts new participant to workshop
-- Example execution:
-- EXECUTE ADD_PARTICIPANT_TO_WORKSHOP 1,1,1,1
-- ==========================================================================================
CREATE PROCEDURE ADD_PARTICIPANT_TO_WORKSHOP
	@ParticipantID int,
	@WorkshopID int,
	@ConferenceDayID int,
	@OrderID int
	AS
	BEGIN
		SET NOCOUNT ON
		DECLARE @OrderedConfDayID int = (	SELECT OrderedConfDayID
											FROM OrderedConfDay
											WHERE OrderID = @OrderID
											AND ConferenceDayID = @ConferenceDayID
										)
		DECLARE @Err_msg varchar(100)
		IF @OrderedConfDayID is null
		BEGIN
			SELECT @Err_msg = 'You cannot add participant without ordered day.';
			THROW 50000, @Err_msg, 1;
		END
		DECLARE @OrderedWorkshopID int = (	SELECT OrderedWorkshopID
											FROM OrderedWorkshop
											WHERE OrderedConfDayID = @OrderedConfDayID
											AND WorkshopID = @WorkshopID
										)
		IF @OrderedWorkshopID is null
		BEGIN
			SELECT @Err_msg = 'You cannot add participant without ordered workshop.';
			THROW 50000, @Err_msg, 1;
		END
		DECLARE @ConfDayParticipant int = (	SELECT ParticipantID
											FROM ConferenceDayParticipant
											WHERE ParticipantID = @ParticipantID
											AND OrderID = @OrderID
											AND ConferenceDayID = @ConferenceDayID
										)
		IF @ConfDayParticipant is null
		BEGIN
			SELECT @Err_msg = 'You cannot add participant to workshop before adding to conference day.';
			THROW 50000, @Err_msg, 1;
		END			
		INSERT INTO WorkshopParticipant(ParticipantID, WorkshopID, ConferenceDayID, OrderID)
		VALUES (@ParticipantID, @WorkshopID, @ConferenceDayID, @OrderID)
	END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: get list of participants of selected workshop
-- Example execution:
-- EXECUTE GET_WORKSHOP_PARTICIPANTS 1
-- ==========================================================================================
CREATE PROCEDURE GET_WORKSHOP_PARTICIPANTS
	@WorkshopID int
	AS
	BEGIN
		SELECT isNull((SELECT Name from Company 
				JOIN Employee ON Employee.CompanyID = Company.CompanyID
				WHERE Employee.ParticipantID = WorkshopParticipant.ParticipantID), 'Private Client') as 'Company',
		FirstName, LastName FROM WorkshopParticipant
		JOIN Participant ON WorkshopParticipant.ParticipantID = Participant.ParticipantID
		WHERE WorkshopParticipant.WorkshopID = @WorkshopID
	END
GO

-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description: get list of participants of selected conference's day
-- Example execution:
-- EXECUTE GET_CONFERENCE_DAY_PARTICIPANTS 1
-- ==========================================================================================
CREATE PROCEDURE GET_CONFERENCE_DAY_PARTICIPANTS 
	@ConferenceDayID int
	AS
	BEGIN
		SELECT isNull((SELECT Name from Company 
				JOIN Employee ON Employee.CompanyID = Company.CompanyID
				WHERE Employee.ParticipantID = ConferenceDayParticipant.ParticipantID), 'Private Client') as 'Company',
		FirstName, LastName FROM ConferenceDayParticipant
		JOIN Participant ON ConferenceDayParticipant.ParticipantID = Participant.ParticipantID
		WHERE ConferenceDayParticipant.ConferenceDayID = @ConferenceDayID
	END
GO

-- Drop triggers
IF OBJECT_ID('TRG_AFTER_ADD_ORDERED_CONF_DAY', 'TR') IS NOT NULL 
	DROP TRIGGER TRG_AFTER_ADD_ORDERED_CONF_DAY
GO
IF OBJECT_ID('TRG_AFTER_CANCELED_ORDER', 'TR') IS NOT NULL 
	DROP TRIGGER TRG_AFTER_CANCELED_ORDER
GO
IF OBJECT_ID('TRG_AFTER_ADD_ORDERED_WORKSHOP', 'TR') IS NOT NULL 
	DROP TRIGGER TRG_AFTER_ADD_ORDERED_CONF_DAY
GO
IF OBJECT_ID('TRG_AFTER_ADD_CONFERENCE_DAY', 'TR') IS NOT NULL 
	DROP TRIGGER TRG_AFTER_ADD_CONFERENCE_DAY
GO
IF OBJECT_ID('TRG_AFTER_PARTICIPANT_TO_WORKSHOP', 'TR') IS NOT NULL 
	DROP TRIGGER TRG_AFTER_PARTICIPANT_TO_WORKSHOP
GO


-- DML Triggers
-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description:	Validates if participant has only one workshop in one time
-- ==========================================================================================
CREATE TRIGGER TRG_AFTER_PARTICIPANT_TO_WORKSHOP
	ON WorkshopParticipant
	AFTER UPDATE, INSERT
AS
BEGIN
	DECLARE @ParticipantID int = (SELECT ParticipantID FROM inserted)
	DECLARE @NewWorkshopID int = (SELECT WorkshopID FROM inserted)

	CREATE TABLE #PARTICIPANT_WORKSHOPS (WorkshopID int)
	
	INSERT INTO #PARTICIPANT_WORKSHOPS
	SELECT WorkshopID FROM WorkshopParticipant
	WHERE ParticipantID = @ParticipantID AND WorkshopID != @NewWorkshopID

	DECLARE @WorkshopID int
	DECLARE @Err_msg varchar(60) = 'Participant has another workshop in the same time.';

	WHILE (EXISTS (SELECT 1 FROM #PARTICIPANT_WORKSHOPS))
		BEGIN
			SELECT TOP 1 @WorkshopID = WorkshopID FROM #PARTICIPANT_WORKSHOPS 

			IF dbo.WORKSHOPS_IN_THE_SAME_TIME(@WorkshopID, @NewWorkshopID) = 1
			BEGIN
				;THROW 50000, @Err_msg, 1;
				ROLLBACK TRANSACTION;
			END

			DELETE FROM #PARTICIPANT_WORKSHOPS  WHERE WorkshopID = @WorkshopID
						
		END
END
GO
-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description:	Validates new conference day insertion
-- ==========================================================================================
CREATE TRIGGER TRG_AFTER_ADD_CONFERENCE_DAY
	ON ConferenceDay
	AFTER UPDATE, INSERT
AS
BEGIN
	DECLARE @ConferenceID int = (SELECT ConferenceID FROM inserted)
	DECLARE @ConferenceDayID int = (SELECT ConferenceDayID FROM inserted)
	DECLARE @ConferenceDayNumber int = (SELECT DayNumber FROM inserted)
	DECLARE @PreviousConferenceDayNumber int =
			(	isNULL((SELECT TOP 1 DayNumber 
				FROM ConferenceDay
				WHERE ConferenceID = @ConferenceID AND ConferenceDayID != @ConferenceDayID
				ORDER BY DayNumber DESC), 0)
			)

	DECLARE @Err_msg varchar(60) = 'Wrong day number. ';

	IF (@PreviousConferenceDayNumber + 1 != @ConferenceDayNumber)
	BEGIN
		;THROW 50000, @Err_msg, 1;
		ROLLBACK TRANSACTION;
	END

	DECLARE @StartDateTime datetime = (SELECT StartDateTime FROM Conference WHERE ConferenceID = @ConferenceID)
	DECLARE @CurrentDateTime datetime = GETDATE()

	SELECT @Err_msg = 'You cannot add a day during the conferency. '
	IF (@CurrentDateTime - @StartDateTime > 0)
	BEGIN
		;THROW 50000, @Err_msg, 1;
		ROLLBACK TRANSACTION;
	END

END
GO
-- ==========================================================================================
-- Author: Gabriela Kowalik
-- Description:	Deletes all records about selected order
-- ==========================================================================================
CREATE TRIGGER TRG_AFTER_CANCELED_ORDER
	ON [Order]
	AFTER UPDATE, INSERT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @OrderID int = (SELECT OrderID FROM inserted)
	DECLARE @OrderStatus bit = (SELECT Canceled FROM inserted)
	IF @OrderStatus = 1
	BEGIN
		PRINT 'CANCELING ORDER ...'
		CREATE TABLE #ORDERED_CONF_DAY (OrderedConfDayID int)

		INSERT INTO #ORDERED_CONF_DAY
		SELECT OrderedConfDayID FROM OrderedConfDay
		WHERE OrderID = @OrderID
		
		DELETE OrderedWorkshop
		FROM OrderedWorkshop
		JOIN #ORDERED_CONF_DAY ON #ORDERED_CONF_DAY.OrderedConfDayID = OrderedWorkshop.OrderedConfDayID	
		
		DELETE OrderedConfDay
		FROM OrderedConfDay
		JOIN #ORDERED_CONF_DAY ON #ORDERED_CONF_DAY.OrderedConfDayID = OrderedConfDay.OrderedConfDayID
		
		DELETE ConferenceDayParticipant
		FROM ConferenceDayParticipant
		WHERE OrderID = @OrderID
		
		DELETE WorkshopParticipant
		FROM WorkshopParticipant
		WHERE OrderID = @OrderID
			
	END
END
GO

-- ==========================================================================================
-- Author: Damian Hanusiak	
-- Description:	Checks if new ordered conference day is from the same conference as others.
-- Checks duplicates.
-- Checks place limit.
-- ==========================================================================================
CREATE TRIGGER TRG_AFTER_ADD_ORDERED_CONF_DAY
	ON OrderedConfDay 
	AFTER UPDATE, INSERT 
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @InsertedConferenceDayId int = (SELECT ConferenceDayID FROM inserted);
	DECLARE @InertedConferenceID int = (SELECT ConferenceID FROM ConferenceDay AS CD
										 WHERE CD.ConferenceDayID = @InsertedConferenceDayId);

	DECLARE @OrderID int = (SELECT OrderID FROM inserted);
	DECLARE @ConferenceID int = (SELECT TOP 1 ConferenceID FROM OrderedConfDay AS OCD
									JOIN ConferenceDay AS CD
									ON OCD.ConferenceDayID = CD.ConferenceDayID
									WHERE OCD.OrderID = @OrderID);

	DECLARE @Err_msg varchar(60) = 'You can order only days from the same conference.';

	IF (@ConferenceID IS NOT NULL AND @ConferenceID != @InertedConferenceID)
	BEGIN
		PRINT @OrderID;
		;THROW 50000, @Err_msg, 1;
		ROLLBACK TRANSACTION;
	END
	
	DECLARE @Err_msg2 varchar(60) = 'Cannot duplicate order for the same conference day.';
	IF (SELECT COUNT(ConferenceDayID) FROM OrderedConfDay AS OCD
		WHERE OCD.OrderID = @OrderID AND OCD.ConferenceDayID = @InsertedConferenceDayId) > 1
	BEGIN
		PRINT @OrderID;
		;THROW 50000, @Err_msg2, 1;
		ROLLBACK TRANSACTION;
	END
	
	DECLARE @Err_msg3 varchar(60) = 'Seat limit has been exceeded.';
	DECLARE @avaliableSeats int = dbo.GET_AVAILABLE_SEATS_ON_CONFDAY(@InsertedConferenceDayId);
	

	DECLARE @bookedSeats int = (SELECT BookedSeats FROM inserted);

	--PRINT '@avaliableSeats before: '+CAST(@avaliableSeats + @bookedSeats as varchar(20));
	--PRINT '@avaliableSeats (including changes): '+CAST(@avaliableSeats as varchar(20));
	--PRINT '@bookedSeats: '+CAST(@bookedSeats as varchar(20));

	IF ((@avaliableSeats) < 0)
		BEGIN
		;THROW 50000, @Err_msg3, 1;
		ROLLBACK TRANSACTION;
	END	
END
GO

-- ==========================================================================================
-- Author: Damian Hanusiak	
-- Description:	Checks if inserted workshop id is from order for proper conference day.
-- You can order only that workshops which are realted with its conference days. 
-- TODO Checks duplicates.
-- Checks place limit.
-- ==========================================================================================
CREATE TRIGGER TRG_AFTER_ADD_ORDERED_WORKSHOP
	ON OrderedWorkshop 
	AFTER UPDATE, INSERT 
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @InsertedOCDID int = (SELECT OrderedConfDayID FROM inserted);
	DECLARE @InsertedWID int = (SELECT WorkshopID FROM inserted);

	-- ConferenceDayId related to inserted OrderedConfDayID
	DECLARE @nConferenceDayId int = (SELECT ConferenceDayID FROM OrderedConfDay WHERE OrderedConfDayID = @InsertedOCDID);
	-- ConferenceDayId related to inserted WorkshopID
	DECLARE @cConferenceDayId int = (SELECT W.ConferenceDayID FROM ConferenceDay AS CD
						JOIN Workshop AS W
						ON CD.ConferenceDayID = W.ConferenceDayID
						WHERE W.WorkshopID = @InsertedWID);
	
	DECLARE @Err_msg varchar(60) = 'Ordered workshop must be correlated with ordered conference day.';
	IF (@nConferenceDayId != @cConferenceDayId)
	BEGIN
		;THROW 50000, @Err_msg, 1;
		ROLLBACK TRANSACTION;
	END	

	DECLARE @Err_msg2 varchar(60) = 'Seat limit has been exceeded.';
	DECLARE @avaliableSeats int = dbo.GET_AVAILABLE_SEATS_ON_WORKSHOP(@InsertedWID);
	DECLARE @bookedSeats int = (SELECT BookedSeats FROM inserted);
	IF (@avaliableSeats) < 0
		BEGIN
		;THROW 50000, @Err_msg2, 1;
		ROLLBACK TRANSACTION;
	END	
END
GO

